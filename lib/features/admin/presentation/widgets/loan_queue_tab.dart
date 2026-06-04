import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/providers.dart';

class LoanQueueTab extends ConsumerWidget {
  const LoanQueueTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pendingLoansProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e',
            style: AppTextStyles.bodyMedium.copyWith(color: error500)),
      ),
      data: (loans) {
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
                      color: riskColor.withValues(alpha: 0.1), borderRadius: radiusPill),
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
                  Expanded(child: FBButton(
                    label: 'Approve',
                    onPressed: () => _showApproveDialog(context, ref, loan),
                  )),
                  const SizedBox(width: sp8),
                  Expanded(child: FBButton(
                    label: 'Reject',
                    variant: FBButtonVariant.destructive,
                    onPressed: () => _showRejectDialog(context, ref, loan['id'] as String),
                  )),
                ]),
              ]),
            );
          },
        );
      },
    );
  }

  void _showApproveDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> loan) {
    final amountCtrl = TextEditingController(text: loan['amount_requested'] as String);
    final notesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Approve Loan'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          FBInput(label: 'Amount (MWK)', controller: amountCtrl,
              keyboardType: TextInputType.number),
          const SizedBox(height: sp12),
          FBInput(label: 'Notes (optional)', controller: notesCtrl),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FBButton(
            label: 'Approve',
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(adminRepositoryProvider(ref.read(accessTokenProvider)))
                    .approveLoan(loan['id'] as String, amountCtrl.text.trim(),
                        notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loan approved')));
                  ref.invalidate(pendingLoansProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, String loanId) {
    final notesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Loan'),
        content: FBInput(label: 'Reason (required)', controller: notesCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FBButton(
            label: 'Reject',
            variant: FBButtonVariant.destructive,
            onPressed: () async {
              if (notesCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              try {
                await ref.read(adminRepositoryProvider(ref.read(accessTokenProvider)))
                    .rejectLoan(loanId, notesCtrl.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loan rejected')));
                  ref.invalidate(pendingLoansProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
