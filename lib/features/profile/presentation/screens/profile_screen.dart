import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
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
          me { id full_name email kyc_level financial_health_score blockchain_did avatar_url }
          financialHealthScore {
            score savings_consistency loan_repayment_rate challenge_completions
          }
        }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(
            body: Center(child: CircularProgressIndicator()));
        final me = result.data?['me'] as Map<String, dynamic>? ?? {};
        final hs = result.data?['financialHealthScore'] as Map<String, dynamic>?;

        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              Center(child: Column(children: [
                FBAvatar(name: me['full_name'] ?? '', imageUrl: me['avatar_url'], size: 80),
                const SizedBox(height: sp12),
                Text(me['full_name'] ?? '', style: AppTextStyles.titleLarge),
                Text(me['email'] ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                const SizedBox(height: sp4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp4),
                  decoration: BoxDecoration(color: primary100, borderRadius: radiusPill),
                  child: Text('KYC Level ${me['kyc_level']}',
                      style: AppTextStyles.labelMedium.copyWith(color: primary500)),
                ),
              ])),
              const SizedBox(height: sp24),
              if (hs != null) FBCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Financial Health', style: AppTextStyles.titleMedium),
                  const SizedBox(height: sp8),
                  Row(children: [
                    Text('${hs['score']}',
                        style: AppTextStyles.displayMedium.copyWith(color: primary500)),
                    Text(' / 1000',
                        style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                  ]),
                  const SizedBox(height: sp8),
                  _Row('Savings consistency',
                      '${((hs['savings_consistency'] as num) * 100).toStringAsFixed(0)}%'),
                  _Row('Loan repayment',
                      '${((hs['loan_repayment_rate'] as num) * 100).toStringAsFixed(0)}%'),
                  _Row('Challenges done', '${hs['challenge_completions']}'),
                ])),
              const SizedBox(height: sp16),
              if (me['blockchain_did'] != null)
                FBCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Blockchain Identity', style: AppTextStyles.titleMedium),
                  const SizedBox(height: sp8),
                  SelectableText('${me['blockchain_did']}',
                      style: AppTextStyles.caption.copyWith(color: primary500)),
                ])),
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
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: sp4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
      Text(value, style: AppTextStyles.labelMedium),
    ]),
  );
}
