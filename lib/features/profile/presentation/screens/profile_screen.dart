import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/components/fb_health_score.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query Profile {
          me {
            id full_name email kyc_level kyc_status
            financial_health_score blockchain_did avatar_url
          }
          financialHealthScore {
            score savings_consistency loan_repayment_rate
            challenge_completions account_age_days kyc_level
          }
        }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(
            body: Center(child: CircularProgressIndicator()));
        final me = result.data?['me'] as Map<String, dynamic>? ?? {};
        final hs = result.data?['financialHealthScore'] as Map<String, dynamic>?;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _showSettings(context, ref),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              // Avatar + name
              Center(child: Column(children: [
                FBAvatar(name: me['full_name'] ?? '', imageUrl: me['avatar_url'], size: 80),
                const SizedBox(height: sp12),
                Text(me['full_name'] ?? '', style: AppTextStyles.titleLarge),
                Text(me['email'] ?? '', style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                const SizedBox(height: sp8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp4),
                  decoration: BoxDecoration(
                      color: me['kyc_level'] >= 2 ? success100 : warning100,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text('KYC Level ${me['kyc_level']}',
                      style: AppTextStyles.labelMedium.copyWith(
                          color: me['kyc_level'] >= 2 ? success500 : warning500)),
                ),
              ])),
              const SizedBox(height: sp24),

              // Health Score with arc gauge
              if (hs != null) FBCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Financial Health', style: AppTextStyles.titleMedium),
                const SizedBox(height: sp16),
                Center(child: FBHealthScoreMeter(score: hs['score'] ?? 0, size: 140)),
                const SizedBox(height: sp16),
                _ScoreBar('Savings consistency',
                    (hs['savings_consistency'] as num?)?.toDouble() ?? 0),
                _ScoreBar('Loan repayment',
                    (hs['loan_repayment_rate'] as num?)?.toDouble() ?? 0),
                _ScoreBar('Challenges', (hs['challenge_completions'] as num?)?.toDouble() ?? 0,
                    max: 5),
                _ScoreBar('KYC level',
                    (hs['kyc_level'] as num?)?.toDouble() ?? 0, max: 3),
              ])),
              const SizedBox(height: sp16),

              // Financial Passport Card
              _PassportCard(did: me['blockchain_did']),
              const SizedBox(height: sp16),

              // KYC upgrade if needed
              if ((me['kyc_level'] as int? ?? 0) < 2) FBCard(
                outlined: true,
                child: Row(children: [
                  const Icon(Icons.verified_user_outlined, color: warning500),
                  const SizedBox(width: sp12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Upgrade KYC', style: AppTextStyles.labelLarge),
                    Text('Unlock higher limits and loan eligibility',
                        style: AppTextStyles.caption.copyWith(color: gray500)),
                  ])),
                  TextButton(
                    onPressed: () => context.push('/auth/kyc'),
                    child: const Text('Verify'),
                  ),
                ]),
              ),
              const SizedBox(height: sp24),

              FBButton(label: 'Sign Out', variant: FBButtonVariant.ghost,
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/auth/login');
                  }),
            ],
          ),
        );
      },
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _SettingsSheet(),
    );
  }
}

class _PassportCard extends StatelessWidget {
  final String? did;
  const _PassportCard({this.did});

  String get _truncated {
    if (did == null) return '';
    final parts = did!.split(':');
    if (parts.length < 4) return did!;
    return 'did:fb:${parts[2]}:****${parts.last.substring(parts.last.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    if (did == null) {
      return FBCard(outlined: true, child: Column(children: [
        const Icon(Icons.badge_outlined, color: gray300, size: 40),
        const SizedBox(height: sp8),
        Text('Financial Passport not yet issued',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
        Text('Verified on graduation',
            style: AppTextStyles.caption.copyWith(color: gray300)),
      ]));
    }

    return FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.badge, color: gold500),
        const SizedBox(width: sp8),
        Text('Financial Passport', style: AppTextStyles.titleMedium),
      ]),
      const SizedBox(height: sp12),
      Text('Identity:', style: AppTextStyles.caption.copyWith(color: gray500)),
      const SizedBox(height: sp4),
      Row(children: [
        Expanded(child: Text(_truncated,
            style: AppTextStyles.labelMedium.copyWith(color: primary500))),
        IconButton(
          icon: const Icon(Icons.copy, size: 16, color: primary500),
          onPressed: () => Clipboard.setData(ClipboardData(text: did!)),
          constraints: const BoxConstraints(), padding: EdgeInsets.zero,
        ),
      ]),
      const SizedBox(height: sp12),
      Center(child: QrImageView(data: did!, size: 120)),
      const SizedBox(height: sp8),
      Center(child: Text('Scan to verify financial identity',
          style: AppTextStyles.caption.copyWith(color: gray500))),
    ]));
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  const _ScoreBar(this.label, this.value, {this.max = 1.0});

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
          Text('${(pct * 100).toInt()}%',
              style: AppTextStyles.labelMedium.copyWith(color: primary500)),
        ]),
        const SizedBox(height: sp4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct, minHeight: 6,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation(primary500),
          ),
        ),
      ]),
    );
  }
}

class _SettingsSheet extends ConsumerStatefulWidget {
  const _SettingsSheet();
  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  bool _blurBalance = false;
  bool _showOnLeaderboard = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(sp24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: gray300, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: sp16),
        Text('Settings', style: AppTextStyles.titleLarge),
        const SizedBox(height: sp24),
        Text('Privacy', style: AppTextStyles.labelLarge.copyWith(color: gray500)),
        SwitchListTile(
          title: const Text('Blur balance on home'),
          value: _blurBalance,
          onChanged: (v) => setState(() => _blurBalance = v),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Show on leaderboard'),
          value: _showOnLeaderboard,
          onChanged: (v) => setState(() => _showOnLeaderboard = v),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Help & FAQ'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('About'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: sp24),
      ]),
    );
  }
}
