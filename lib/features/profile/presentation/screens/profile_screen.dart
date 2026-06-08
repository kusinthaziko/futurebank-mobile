import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/components/fb_health_score.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../features/auth/data/cloudinary_service.dart';
import '../../domain/providers.dart';
import '../../../../core/widgets/error_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _showPhotoPicker(BuildContext context, WidgetRef ref) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (source == null || !context.mounted) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 512, maxHeight: 512);
    if (picked == null || !context.mounted) return;

    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading photo...'), duration: Duration(minutes: 1)),
    );

    try {
      final imageUrl = await CloudinaryService.uploadImageAndGetUrl(picked.path);
      if (imageUrl == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload failed. Try again.')),
          );
        }
        return;
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      await ref.read(updateAvatarProvider(imageUrl).future);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo updated!'), duration: Duration(seconds: 2)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final badgesAsync = ref.watch(badgesProvider);
    final role = ref.watch(roleProvider);

    return ScreenshotProtectedScreen(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(profileProvider)),
        data: (data) => ListView(
          padding: const EdgeInsets.all(sp16),
          children: [
            Center(child: Column(children: [
              Stack(children: [
                GestureDetector(
                  onTap: () => _showPhotoPicker(context, ref),
                  child: FBAvatar(name: data.user.fullName,
                      imageUrl: data.user.avatarUrl, size: 80),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: GestureDetector(
                    onTap: () => _showPhotoPicker(context, ref),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: primary500,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: sp12),
              Text(data.user.fullName, style: AppTextStyles.titleLarge),
              Text(data.user.email,
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
              const SizedBox(height: sp8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp4),
                decoration: BoxDecoration(
                    color: data.user.kycLevel >= 2 ? success100 : warning100,
                    borderRadius: radiusPill),
                child: Text('KYC Level ${data.user.kycLevel}',
                    style: AppTextStyles.labelMedium.copyWith(
                        color: data.user.kycLevel >= 2 ? success500 : warning500)),
              ),
              if (role != null) ...[
                const SizedBox(height: sp4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp4),
                  decoration: BoxDecoration(
                      color: primary100,
                      borderRadius: radiusPill),
                  child: Text(role.replaceAll('_', ' ').toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(color: primary500)),
                ),
              ],
            ])),
            const SizedBox(height: sp24),

            // Health score - tappable to health score screen
            GestureDetector(
              onTap: () => context.push('/health-score'),
              child: FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Financial Health', style: AppTextStyles.titleMedium),
                  Icon(Icons.chevron_right, color: gray500),
                ]),
                const SizedBox(height: sp16),
                Center(child: FBHealthScoreMeter(score: data.healthScore.score, size: 140)),
                const SizedBox(height: sp16),
                _ScoreBar('Savings consistency', data.healthScore.savingsConsistency),
                _ScoreBar('Loan repayment', data.healthScore.loanRepaymentRate),
                _ScoreBar('Challenges', data.healthScore.challengeCompletions / 5),
                _ScoreBar('KYC level', data.healthScore.kycLevel / 3),
              ])),
            ),
            const SizedBox(height: sp16),

            // Badges - tappable
            badgesAsync.when(
              loading: () => const FBSkeletonLoader(height: 60),
              error: (_, __) => const SizedBox(),
              data: (badges) => badges.isEmpty ? const SizedBox() : GestureDetector(
                onTap: () => context.push('/passport'),
                child: FBCard(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Badges (${badges.length})', style: AppTextStyles.titleMedium),
                    const Icon(Icons.chevron_right, color: gray500),
                  ]),
                ),
              ),
            ),
            if (badgesAsync.asData?.value.isNotEmpty ?? false)
              const SizedBox(height: sp16),

            // Financial Passport - tappable
            if (data.user.blockchainDid != null)
              GestureDetector(
                onTap: () => context.push('/passport'),
                child: FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Icon(Icons.badge, color: gold500),
                      SizedBox(width: sp8),
                      Text('Financial Passport', style: AppTextStyles.titleMedium),
                    ]),
                    Icon(Icons.chevron_right, color: gray500),
                  ]),
                  const SizedBox(height: sp12),
                  Center(child: QrImageView(data: data.user.blockchainDid!, size: 120)),
                  const SizedBox(height: sp8),
                  Row(children: [
                    Expanded(child: Text(
                      _truncateDid(data.user.blockchainDid!),
                      style: AppTextStyles.caption.copyWith(color: primary500),
                    )),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16, color: primary500),
                      onPressed: () => Clipboard.setData(
                          ClipboardData(text: data.user.blockchainDid!)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ]),
                ])),
              ),

            // KYC upgrade prompt
            if (data.user.kycLevel < 2) ...[
              const SizedBox(height: sp16),
              FBCard(outlined: true, child: Row(children: [
                const Icon(Icons.verified_user_outlined, color: warning500),
                const SizedBox(width: sp12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Upgrade KYC', style: AppTextStyles.labelLarge),
                  Text('Unlock higher limits and loans',
                      style: AppTextStyles.caption.copyWith(color: gray500)),
                ])),
                TextButton(
                    onPressed: () => context.push('/auth/kyc'),
                    child: const Text('Verify')),
              ])),
            ],

            // Admin panel link (shown for admin roles)
            if (role == 'admin' || role == 'super_admin' || role == 'finance_manager') ...[
              const SizedBox(height: sp16),
              FBCard(
                onTap: () => context.push('/admin'),
                child: const Row(children: [
                  Icon(Icons.admin_panel_settings, color: primary500),
                  SizedBox(width: sp12),
                  Text('Admin Panel', style: AppTextStyles.labelLarge),
                  Spacer(),
                  Icon(Icons.chevron_right, color: gray500),
                ]),
              ),
            ],

            const SizedBox(height: sp24),
            FBButton(
              label: 'Sign Out',
              variant: FBButtonVariant.ghost,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/auth/login');
              },
            ),
          ],
        ),
      ),
    ));
  }

  String _truncateDid(String did) {
    final parts = did.split(':');
    if (parts.length < 4) return did;
    return 'did:fb:${parts[2]}:****${parts.last.substring(parts.last.length.clamp(4, parts.last.length) - 4)}';
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double value;
  const _ScoreBar(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
        Text('${(value.clamp(0.0, 1.0) * 100).toInt()}%',
            style: AppTextStyles.labelMedium.copyWith(color: primary500)),
      ]),
      const SizedBox(height: sp4),
      ClipRRect(
        borderRadius: radius4,
        child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0), minHeight: 6,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation(primary500)),
      ),
    ]),
  );
}
