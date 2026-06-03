import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final String accountId;
  const TransactionHistoryScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(r'''
          query TxHistory($accountId: ID!, $limit: Int) {
            transactionHistory(accountId: $accountId, limit: $limit) {
              id reference description amount transaction_type status inserted_at
            }
          }
        '''),
        variables: {'accountId': accountId, 'limit': 50},
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
        final txs = (result.data?['transactionHistory'] as List? ?? [])
            .cast<Map<String, dynamic>>();
        return Scaffold(
          appBar: AppBar(title: const Text('Transactions')),
          body: txs.isEmpty
              ? Center(child: Text('No transactions yet.',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500)))
              : ListView.separated(
                  padding: const EdgeInsets.all(sp16),
                  itemCount: txs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _TxRow(tx: txs[i]),
                ),
        );
      },
    );
  }
}

class _TxRow extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _TxRow({required this.tx});

  bool get _isCredit => tx['transaction_type'] == 'deposit' ||
      tx['transaction_type'] == 'interest_credit';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: _isCredit ? success100 : error100, borderRadius: radius12),
        child: Icon(
          _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: _isCredit ? success500 : error500, size: 18),
      ),
      title: Text(tx['description'] ?? tx['transaction_type'] ?? '',
          style: AppTextStyles.bodyMedium),
      subtitle: Text(tx['reference'] ?? '',
          style: AppTextStyles.caption.copyWith(color: gray500)),
      trailing: Text(
        '${_isCredit ? '+' : '-'}MWK ${tx['amount']}',
        style: AppTextStyles.labelLarge.copyWith(
            color: _isCredit ? success500 : error500)),
    );
  }
}
