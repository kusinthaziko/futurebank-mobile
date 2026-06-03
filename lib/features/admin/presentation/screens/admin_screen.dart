import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Pending Deposits'), Tab(text: 'Loan Applications')]),
        ),
        body: const TabBarView(
          children: [_PendingDepositsTab(), _LoanQueueTab()]),
      ),
    );
  }
}

class _PendingDepositsTab extends StatelessWidget {
  const _PendingDepositsTab();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query {
          transactionHistory(accountId: "", limit: 50) {
            id reference amount description status inserted_at
          }
        }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Center(child: CircularProgressIndicator());
        final txs = ((result.data?['transactionHistory'] as List? ?? [])
            .cast<Map<String, dynamic>>())
            .where((t) => t['status'] == 'pending').toList();

        if (txs.isEmpty) {
          return Center(child: Text('No pending deposits',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(sp16),
          itemCount: txs.length,
          itemBuilder: (_, i) {
            final tx = txs[i];
            return FBCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('MWK ${tx['amount']}', style: AppTextStyles.titleMedium),
                  Text('${tx['reference']}',
                      style: AppTextStyles.caption.copyWith(color: gray500)),
                ]),
                const SizedBox(height: sp8),
                Row(children: [
                  Expanded(child: FBButton(
                    label: 'Confirm',
                    onPressed: () {},
                  )),
                  const SizedBox(width: sp8),
                  Expanded(child: FBButton(
                    label: 'Reject',
                    variant: FBButtonVariant.destructive,
                    onPressed: () {},
                  )),
                ]),
              ]),
            );
          },
        );
      },
    );
  }
}

class _LoanQueueTab extends StatelessWidget {
  const _LoanQueueTab();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query { pendingLoans(institutionId: "") {
          id amount_requested purpose status ai_risk_score ai_risk_summary
          applicant_id submitted_at
        }}
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Center(child: CircularProgressIndicator());
        final loans = (result.data?['pendingLoans'] as List? ?? []).cast<Map<String, dynamic>>();

        if (loans.isEmpty) {
          return Center(child: Text('No pending loans',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(sp16),
          itemCount: loans.length,
          itemBuilder: (_, i) {
            final loan = loans[i];
            final risk = (loan['ai_risk_score'] as num?)?.toDouble() ?? 0.5;
            final riskColor = risk < 0.3 ? success500 : risk < 0.6 ? warning500 : error500;
            return FBCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('MWK ${loan['amount_requested']}', style: AppTextStyles.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: sp8, vertical: sp4),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
                    child: Text('Risk: ${(risk * 100).toInt()}%',
                        style: AppTextStyles.labelMedium.copyWith(color: riskColor)),
                  ),
                ]),
                Text('${loan['purpose']}',
                    style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                if (loan['ai_risk_summary'] != null) ...[
                  const SizedBox(height: sp4),
                  Text('${loan['ai_risk_summary']}',
                      style: AppTextStyles.caption.copyWith(color: gray500)),
                ],
                const SizedBox(height: sp12),
                Row(children: [
                  Expanded(child: FBButton(label: 'Approve', onPressed: () {})),
                  const SizedBox(width: sp8),
                  Expanded(child: FBButton(
                      label: 'Reject', variant: FBButtonVariant.destructive, onPressed: () {})),
                ]),
              ]),
            );
          },
        );
      },
    );
  }
}
