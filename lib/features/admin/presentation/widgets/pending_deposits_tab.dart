import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/error_utils.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/providers.dart';

class PendingDepositsTab extends ConsumerWidget {
  const PendingDepositsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pendingDepositsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.refresh(pendingDepositsProvider),
      ),
      data: (txs) {
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
                    onPressed: () => _confirmDeposit(context, ref, tx['id'] as String),
                  )),
                  const SizedBox(width: sp8),
                  Expanded(child: FBButton(
                    label: 'Reject',
                    variant: FBButtonVariant.destructive,
                    onPressed: () => _showRejectDialog(context, ref, tx['id'] as String),
                  )),
                ]),
              ]),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeposit(BuildContext context, WidgetRef ref, String txId) async {
    try {
      await ref.read(adminRepositoryProvider(ref.read(accessTokenProvider)))
          .confirmDeposit(txId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deposit confirmed')));
        ref.invalidate(pendingDepositsProvider);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(friendlyErrorMessage(e))));
      }
    }
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, String txId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Deposit'),
        content: FBInput(label: 'Reason (optional)', controller: reasonCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FBButton(
            label: 'Reject',
            variant: FBButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(adminRepositoryProvider(ref.read(accessTokenProvider)))
                    .rejectDeposit(txId, reason: reasonCtrl.text.trim().isEmpty
                        ? null : reasonCtrl.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deposit rejected')));
                  ref.invalidate(pendingDepositsProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(friendlyErrorMessage(e))));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
