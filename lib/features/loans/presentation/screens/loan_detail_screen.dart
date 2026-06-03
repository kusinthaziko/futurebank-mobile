import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';
import '../widgets/loan_status_stepper.dart';

class LoanDetailScreen extends ConsumerWidget {
  final String loanId;
  const LoanDetailScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);
    final scheduleAsync = ref.watch(repaymentScheduleProvider(loanId));

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (data) {
          final loan = data.loans.firstWhere(
            (l) => l.id == loanId,
            orElse: () => data.loans.first,
          );
          return ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              LoanStatusStepper(status: loan.status),
              const SizedBox(height: sp20),
              FBCard(child: Column(children: [
                _Row('Amount', 'MWK ${loan.amountApproved ?? loan.amountRequested}'),
                _Row('Purpose', loan.purpose),
                _Row('Period', '${loan.repaymentPeriodWeeks} weeks'),
                _Row('Rate', '${loan.interestRate}% / week'),
                if (loan.aiRiskSummary != null)
                  _Row('AI Assessment', loan.aiRiskSummary!),
              ])),
              if (loan.blockchainContractHash != null) ...[
                const SizedBox(height: sp12),
                FBCard(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blockchain Contract', style: AppTextStyles.labelLarge),
                    const SizedBox(height: sp4),
                    Row(children: [
                      Expanded(child: Text(
                        '${loan.blockchainContractHash!.substring(0, 20)}...',
                        style: AppTextStyles.caption.copyWith(color: primary500),
                      )),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16, color: primary500),
                        onPressed: () => Clipboard.setData(
                            ClipboardData(text: loan.blockchainContractHash!)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ]),
                  ],
                )),
              ],
              const SizedBox(height: sp20),
              Text('Repayment Schedule', style: AppTextStyles.titleMedium),
              const SizedBox(height: sp8),
              scheduleAsync.when(
                loading: () => const FBSkeletonLoader(height: 150),
                error: (_, __) => const SizedBox(),
                data: (schedule) => Column(children: schedule.map((s) {
                  final color = switch (s.status) {
                    'paid' => success500, 'overdue' => error500, _ => gray500
                  };
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: sp4),
                    child: Row(children: [
                      Text('#${s.instalmentNumber}',
                          style: AppTextStyles.labelMedium.copyWith(color: gray500)),
                      const SizedBox(width: sp8),
                      Expanded(child: Text(s.dueDate,
                          style: AppTextStyles.bodyMedium)),
                      Text('MWK ${s.amountDue}',
                          style: AppTextStyles.labelMedium.copyWith(color: color)),
                    ]),
                  );
                }).toList()),
              ),
              if (loan.status == 'active') ...[
                const SizedBox(height: sp24),
                FBButton(
                  label: 'Make Repayment',
                  onPressed: () => context.push('/loans/$loanId/repay'),
                ),
              ],
            ],
          );
        },
      ),
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
      Flexible(child: Text(value,
          style: AppTextStyles.labelMedium, textAlign: TextAlign.right)),
    ]),
  );
}
