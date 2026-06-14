import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/profile_models.dart';
import '../../domain/providers.dart';

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final badgesAsync = ref.watch(badgesProvider);

    return DefaultTabController(
      length: 3,
      child: ScreenshotProtectedScreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Financial Passport'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Summary'),
                Tab(text: 'Credentials'),
                Tab(text: 'Verify'),
              ],
            ),
          ),
          body: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.refresh(profileProvider),
            ),
            data: (data) {
              final user = data.user;
              final hs = data.healthScore;

              return TabBarView(
                children: [
                  _SummaryTab(user: user, hs: hs),
                  _CredentialsTab(badgesAsync: badgesAsync),
                  _VerifyTab(did: user.blockchainDid),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final UserProfile user;
  final HealthScoreData hs;
  const _SummaryTab({required this.user, required this.hs});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(sp16),
    children: [
      FBCard(
        gradient: true,
        child: Column(
          children: [
            const Icon(Icons.school, color: white, size: 40),
            const SizedBox(height: sp8),
            Text(
              'MUBAS',
              style: AppTextStyles.titleLarge.copyWith(color: white),
            ),
            const SizedBox(height: sp4),
            Text(
              'Building since ${_formatDate(hs.accountAgeDays)}',
              style: AppTextStyles.caption.copyWith(
                color: white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: sp16),
      FBCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Financial Stats', style: AppTextStyles.titleMedium),
            const SizedBox(height: sp12),
            _StatRow('Health Score Avg', '${hs.score}'),
            _StatRow('Savings Streak', '${hs.accountAgeDays} days'),
            _StatRow(
              'Loan Repayment',
              '${(hs.loanRepaymentRate * 100).toInt()}%',
            ),
            _StatRow('Challenges Completed', '${hs.challengeCompletions}'),
          ],
        ),
      ),
      const SizedBox(height: sp16),
      FBCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Milestones', style: AppTextStyles.titleMedium),
            const SizedBox(height: sp12),
            const _MilestoneTile(
              icon: Icons.person_add,
              title: 'Account Created',
              subtitle: 'First step on your financial journey',
            ),
            const _MilestoneTile(
              icon: Icons.savings,
              title: 'First Deposit',
              subtitle: 'Started building your savings habit',
            ),
            if (hs.challengeCompletions > 0)
              const _MilestoneTile(
                icon: Icons.emoji_events,
                title: 'First Badge',
                subtitle: 'Earned your first achievement',
              ),
            if ((hs.loanRepaymentRate) > 0)
              const _MilestoneTile(
                icon: Icons.credit_score,
                title: 'First Loan Repaid',
                subtitle: 'Demonstrated creditworthiness',
              ),
          ],
        ),
      ),
    ],
  );

  String _formatDate(int daysAgo) {
    final date = DateTime.now().subtract(Duration(days: daysAgo));
    return '${_months[date.month - 1]} ${date.year}';
  }
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
        Text(value, style: AppTextStyles.labelLarge),
      ],
    ),
  );
}

class _MilestoneTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MilestoneTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp6),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: primary100, borderRadius: radius8),
          child: Icon(icon, size: 18, color: primary500),
        ),
        const SizedBox(width: sp12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyMedium),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(color: gray500),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CredentialsTab extends StatelessWidget {
  final AsyncValue<List<BadgeModel>> badgesAsync;
  const _CredentialsTab({required this.badgesAsync});

  @override
  Widget build(BuildContext context) => badgesAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => Center(
      child: Text(
        'Could not load badges',
        style: AppTextStyles.bodyMedium.copyWith(color: gray500),
      ),
    ),
    data: (badges) => badges.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: gray300,
                ),
                const SizedBox(height: sp16),
                Text(
                  'No badges yet',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(sp16),
            itemCount: badges.length,
            itemBuilder: (_, i) {
              final b = badges[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: sp8),
                child: FBCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: gold100,
                          borderRadius: radius12,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: gold500,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: sp12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.name, style: AppTextStyles.labelLarge),
                            const SizedBox(height: sp2),
                            Text(
                              'Token ID: #${b.badgeId.substring(0, 8)}',
                              style: AppTextStyles.caption.copyWith(
                                color: gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

class _VerifyTab extends StatelessWidget {
  final String? did;
  const _VerifyTab({this.did});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(sp16),
    children: [
      FBCard(
        child: Column(
          children: [
            if (did != null)
              QrImageView(
                data: did!,
                size: 160,
                eyeStyle: const QrEyeStyle(color: primary500),
                dataModuleStyle: const QrDataModuleStyle(color: primary500),
              ),
            const SizedBox(height: sp16),
            const Text('Scan to Verify', style: AppTextStyles.titleMedium),
            const SizedBox(height: sp8),
            Text(
              'Anyone can scan this QR code to verify your financial record directly on the blockchain — no middleman, no paperwork.',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const SizedBox(height: sp16),
      if (did != null)
        FBCard(
          outlined: true,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      did!,
                      style: AppTextStyles.caption.copyWith(color: primary500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: primary500),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: did!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('DID copied!')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      const SizedBox(height: sp24),
      FBCard(
        outlined: true,
        child: Column(
          children: [
            const Text('What is a DID?', style: AppTextStyles.labelLarge),
            const SizedBox(height: sp8),
            Text(
              'A Decentralized Identifier (DID) is your unique blockchain identity. Unlike a traditional ID, it belongs to you — not any institution — and travels with you after graduation.',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500),
            ),
          ],
        ),
      ),
    ],
  );
}
