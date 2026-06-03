import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query MyLoans {
          myLoans { id status amount_requested purpose blockchain_contract_hash }
          loanEligibility { eligible max_amount reason }
        }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Center(child: CircularProgressIndicator());
        if (result.hasException) return Center(child: Text('${result.exception}'));

        final loans = (result.data?['myLoans'] as List? ?? []).cast<Map<String, dynamic>>();
        final eligibility = result.data?['loanEligibility'] as Map<String, dynamic>? ?? {};
        final eligible = eligibility['eligible'] == true;

        return Scaffold(
          appBar: AppBar(title: const Text('Loans')),
          body: ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              FBCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Loan Eligibility', style: AppTextStyles.titleMedium),
                  const SizedBox(height: sp8),
                  if (eligible) ...[
                    Text('Max: MWK ${eligibility['max_amount'] ?? 0}',
                        style: AppTextStyles.bodyMedium.copyWith(color: success500)),
                    const SizedBox(height: sp12),
                    FBButton(label: 'Apply for a Loan',
                        onPressed: () => context.push('/loans/apply')),
                  ] else
                    Text(eligibility['reason'] ?? 'KYC level 3 required',
                        style: AppTextStyles.bodyMedium.copyWith(color: error500)),
                ]),
              ),
              const SizedBox(height: sp20),
              ...loans.map((loan) => _LoanCard(loan: loan)),
            ],
          ),
        );
      },
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Map<String, dynamic> loan;
  const _LoanCard({required this.loan});

  Color get _statusColor => switch ('${loan['status']}') {
    'approved' || 'disbursed' || 'active' => success500,
    'rejected' || 'defaulted' => error500,
    _ => warning500,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: sp8),
      child: FBCard(
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MWK ${loan['amount_requested']}', style: AppTextStyles.titleMedium),
            Text('${loan['purpose']}',
                style: AppTextStyles.caption.copyWith(color: gray500)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1), borderRadius: radiusPill),
            child: Text('${loan['status']}'.toUpperCase(),
                style: AppTextStyles.labelMedium.copyWith(color: _statusColor)),
          ),
        ]),
      ),
    );
  }
}
