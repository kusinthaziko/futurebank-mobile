import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/providers.dart';
import '../widgets/loan_status_stepper.dart';
import '../widgets/make_repayment_sheet.dart';
import '../widgets/blockchain_contract_card.dart';
import '../widgets/repayment_progress_card.dart';
import '../widgets/repayment_schedule_list.dart';

class LoanDetailScreen extends ConsumerWidget {
  final String loanId;
  const LoanDetailScreen({super.key, required this.loanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);
    final scheduleAsync = ref.watch(repaymentScheduleProvider(loanId));

    ref.listen(loanStatusSubscriptionProvider(loanId), (_, next) {
      next.whenData((_) => ref.refresh(loansProvider));
    });

    return ScreenshotProtectedScreen(
      child: Scaffold(
        appBar: AppBar(title: const Text('Loan Details')),
        body: loansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              ErrorView(error: e, onRetry: () => ref.refresh(loansProvider)),
          data: (data) {
            final loan = data.loans.firstWhere(
              (l) => l.id == loanId,
              orElse: () => data.loans.first,
            );

            final isActive = loan.status == 'active';
            final isRejected = loan.status == 'rejected';
            final totalAmount =
                double.tryParse(loan.amountApproved ?? loan.amountRequested) ??
                0;

            return ListView(
              padding: const EdgeInsets.all(sp16),
              children: [
                LoanStatusStepper(
                  status: loan.status,
                  rejectedReason: isRejected ? loan.aiRiskSummary : null,
                  submittedAt: loan.submittedAt,
                  decidedAt: loan.decidedAt,
                  disbursedAt: loan.disbursedAt,
                ),
                const SizedBox(height: sp20),
                FBCard(
                  child: Column(
                    children: [
                      _row(
                        'Amount',
                        'MWK ${loan.amountApproved ?? loan.amountRequested}',
                      ),
                      _row('Purpose', loan.purpose),
                      _row('Period', '${loan.repaymentPeriodWeeks} weeks'),
                      _row('Rate', '${loan.interestRate}% / week'),
                      if (loan.aiRiskSummary != null && !isRejected)
                        _row('AI Assessment', loan.aiRiskSummary!),
                    ],
                  ),
                ),
                if (loan.blockchainContractHash != null) ...[
                  const SizedBox(height: sp12),
                  BlockchainContractCard(
                    contractHash: loan.blockchainContractHash!,
                  ),
                ],
                if (isActive) ...[
                  const SizedBox(height: sp20),
                  RepaymentProgressCard(
                    totalAmount: totalAmount,
                    repaidAmount: totalAmount * 0.3,
                  ),
                  const SizedBox(height: sp20),
                  const Text(
                    'Repayment Schedule',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: sp8),
                  RepaymentScheduleList(scheduleAsync: scheduleAsync),
                  const SizedBox(height: sp24),
                  FBButton(
                    label: 'Make Repayment',
                    onPressed: () => showMakeRepaymentSheet(
                      context,
                      loanId: loan.id,
                      nextAmount: ((totalAmount) / loan.repaymentPeriodWeeks)
                          .toStringAsFixed(0),
                      walletBalance: '0',
                    ),
                  ),
                ],
                if (isRejected) ...[
                  const SizedBox(height: sp20),
                  FBCard(
                    outlined: true,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: warning500,
                              size: 18,
                            ),
                            const SizedBox(width: sp8),
                            Text(
                              'Loan Rejected',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: error500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: sp8),
                        Text(
                          loan.aiRiskSummary ??
                              'Your loan application was not approved.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: gray700,
                          ),
                        ),
                        const SizedBox(height: sp12),
                        Container(
                          padding: const EdgeInsets.all(sp12),
                          decoration: BoxDecoration(
                            color: warning100,
                            borderRadius: radius12,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: warning500,
                                size: 18,
                              ),
                              const SizedBox(width: sp8),
                              Expanded(
                                child: Text(
                                  'You can apply again after 30 days.',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: warning500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: gray500)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
