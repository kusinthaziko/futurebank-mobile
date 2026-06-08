import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../features/accounts/data/models/account_models.dart';
import 'transaction_detail_sheet.dart';

/// A single transaction row used in the transaction history list.
class TransactionTile extends StatelessWidget {
  final TxModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  bool get _isCredit =>
      transaction.transactionType == 'deposit' ||
      transaction.transactionType == 'interest_credit' ||
      transaction.transactionType == 'loan_disbursement';

  Color get _statusColor => switch (transaction.status) {
        'completed' => success500,
        'pending' || 'processing' => warning500,
        _ => error500,
      };

  Color get _statusBg => switch (transaction.status) {
        'completed' => success100,
        'pending' || 'processing' => warning100,
        _ => error100,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => showTransactionDetailSheet(context, transaction),
      child: Padding(
        padding: const EdgeInsets.only(bottom: sp4),
        child: SizedBox(
          height: 64,
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isCredit ? success100 : error100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: _isCredit ? success500 : error500,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description ?? transaction.transactionType,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _timeAgo(transaction.insertedAt),
                    style: AppTextStyles.caption.copyWith(color: gray500),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_isCredit ? '+' : '-'}MWK ${transaction.amount}',
                  style: AppTextStyles.labelLarge.copyWith(
                      color: _isCredit ? success500 : error500),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.status.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                        color: _statusColor, fontSize: 9),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  String _timeAgo(String insertedAt) {
    try {
      return formatTimeAgo(DateTime.parse(insertedAt));
    } catch (_) {
      return insertedAt;
    }
  }
}
