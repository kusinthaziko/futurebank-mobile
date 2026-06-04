import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../accounts/data/models/account_models.dart';

void showTransactionDetailSheet(BuildContext context, TxModel tx) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => TransactionDetailSheet(tx: tx),
  );
}

class TransactionDetailSheet extends StatelessWidget {
  final TxModel tx;
  const TransactionDetailSheet({super.key, required this.tx});

  String get _typeLabel {
    switch (tx.transactionType) {
      case 'deposit': return 'Deposit';
      case 'withdrawal': return 'Withdrawal';
      case 'transfer': return 'Transfer';
      case 'loan_disbursement': return 'Loan Disbursement';
      case 'loan_repayment': return 'Loan Repayment';
      case 'interest_credit': return 'Interest Credit';
      default: return tx.transactionType;
    }
  }

  bool get _isCredit => tx.transactionType == 'deposit'
      || tx.transactionType == 'interest_credit'
      || tx.transactionType == 'loan_disbursement';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(sp24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: sp20),
          Center(
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: _isCredit ? success100 : error100,
                borderRadius: radius16,
              ),
              child: Icon(
                _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: _isCredit ? success500 : error500, size: 24,
              ),
            ),
          ),
          const SizedBox(height: sp12),
          Center(
            child: Text(
              '${_isCredit ? '+' : '-'}MWK ${tx.amount}',
              style: AppTextStyles.displayMedium.copyWith(
                color: _isCredit ? success500 : error500,
              ),
            ),
          ),
          Center(
            child: Text(
              _typeLabel,
              style: AppTextStyles.labelLarge.copyWith(color: gray500),
            ),
          ),
          const SizedBox(height: sp24),
          _buildRow(context, 'Reference', tx.reference, copyable: true),
          _buildRow(context, 'Type', _typeLabel),
          _buildRow(context, 'Currency', 'MWK'),
          if (tx.description != null && tx.description!.isNotEmpty)
            _buildRow(context, 'Description', tx.description!),
          _buildRow(context, 'Status', tx.status, isStatus: true),
          _buildRow(context, 'Date', tx.insertedAt),
          if (tx.transactionType == 'loan_disbursement') ...[
            const SizedBox(height: sp8),
            _buildRow(context, 'Blockchain Tx', 'View on chain', isBlockchain: true),
          ],
          const SizedBox(height: sp24),
          FBButton(
            label: 'Download Receipt',
            icon: const Icon(Icons.download, size: 18),
            variant: FBButtonVariant.secondary,
            onPressed: () => context.push('/receipt/${tx.id}'),
          ),
          const SizedBox(height: sp8),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {
    bool copyable = false,
    bool isStatus = false,
    bool isBlockchain = false,
  }) {
    final statusColor = switch (value) {
      'completed' => success500,
      'pending' || 'processing' => warning500,
      _ => error500,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: AppTextStyles.caption.copyWith(color: gray500)),
          ),
          const SizedBox(width: sp8),
          Expanded(
            child: isBlockchain
                ? GestureDetector(
                    onTap: () => _showBlockchainTooltip(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View on chain',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: primary500)),
                        const SizedBox(width: sp4),
                        const Icon(Icons.info_outline,
                            size: 14, color: primary300),
                      ],
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(value,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isStatus ? statusColor : gray900,
                            )),
                      ),
                      if (copyable) ...[
                        const SizedBox(width: sp4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reference copied'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Icon(Icons.copy, size: 14, color: primary300),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showBlockchainTooltip(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: radius12),
        title: const Text('What is a Blockchain Tx?',
            style: AppTextStyles.titleMedium),
        content: const Text(
          'A blockchain transaction hash is a unique digital fingerprint '
          'for this transaction on the blockchain. It proves the transaction '
          'was recorded on a decentralized ledger and cannot be altered. '
          'You can use it to verify this transaction independently.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
