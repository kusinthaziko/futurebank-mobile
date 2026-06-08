import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/providers.dart';
import '../widgets/loan_status_stepper.dart';
import '../widgets/make_repayment_sheet.dart';

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
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.refresh(loansProvider),
        ),
        data: (data) {
          final loan = data.loans.firstWhere(
            (l) => l.id == loanId,
            orElse: () => data.loans.first,
          );

          final isActive = loan.status == 'active';
          final isRejected = loan.status == 'rejected';

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
                child: Column(children: [
                  _row('Amount', 'MWK ${loan.amountApproved ?? loan.amountRequested}'),
                  _row('Purpose', loan.purpose),
                  _row('Period', '${loan.repaymentPeriodWeeks} weeks'),
                  _row('Rate', '${loan.interestRate}% / week'),
                  if (loan.aiRiskSummary != null && !isRejected)
                    _row('AI Assessment', loan.aiRiskSummary!),
                ]),
              ),
              if (loan.blockchainContractHash != null) ...[
                const SizedBox(height: sp12),
                _blockchainCard(context, loan.blockchainContractHash!),
              ],
              if (isActive) ...[
                const SizedBox(height: sp20),
                _progressSection(loan),
                const SizedBox(height: sp20),
                const Text('Repayment Schedule',
                    style: AppTextStyles.titleMedium),
                const SizedBox(height: sp8),
                _scheduleSection(scheduleAsync),
                const SizedBox(height: sp24),
                FBButton(
                  label: 'Make Repayment',
                  onPressed: () => showMakeRepaymentSheet(
                    context,
                    loanId: loan.id,
                    nextAmount: ((double.tryParse(loan.amountRequested) ?? 0) / loan.repaymentPeriodWeeks).toStringAsFixed(0),
                    walletBalance: '0',
                  ),
                ),
              ],
              if (isRejected) ...[
                const SizedBox(height: sp20),
                FBCard(
                  outlined: true,
                  child: Column(children: [
                    Row(children: [
                      const Icon(Icons.info_outline, color: warning500, size: 18),
                      const SizedBox(width: sp8),
                      Text('Loan Rejected',
                          style: AppTextStyles.titleMedium.copyWith(color: error500)),
                    ]),
                    const SizedBox(height: sp8),
                    Text(
                      loan.aiRiskSummary ?? 'Your loan application was not approved.',
                      style: AppTextStyles.bodyMedium.copyWith(color: gray700),
                    ),
                    const SizedBox(height: sp12),
                    Container(
                      padding: const EdgeInsets.all(sp12),
                      decoration: BoxDecoration(
                        color: warning100,
                        borderRadius: radius12,
                      ),
                      child: Row(children: [
                        const Icon(Icons.schedule, color: warning500, size: 18),
                        const SizedBox(width: sp8),
                        Expanded(
                          child: Text(
                            'You can apply again after 30 days.',
                            style: AppTextStyles.labelMedium.copyWith(color: warning500),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ],
            ],
          );
        },
      ),
    ));
  }

  Widget _blockchainCard(BuildContext context, String hash) {
    return FBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Blockchain Contract',
                style: AppTextStyles.labelLarge),
            const SizedBox(width: sp4),
            GestureDetector(
              onTap: () => _showTooltip(context),
              child: const Icon(Icons.info_outline, size: 14, color: primary300),
            ),
          ]),
          const SizedBox(height: sp4),
          Row(children: [
            Expanded(
              child: Text(
                '${hash.substring(0, 24)}...',
                style: AppTextStyles.caption.copyWith(
                  color: primary500,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 16, color: primary500),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: hash));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hash copied')),
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),
        ],
      ),
    );
  }

  void _showTooltip(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: radius12),
        title: const Text('What is a Blockchain Contract?',
            style: AppTextStyles.titleMedium),
        content: const Text(
          'A blockchain contract hash is the unique address of your loan '
          'agreement on the blockchain. It proves your loan terms are '
          'immutably recorded and cannot be changed. You can verify it '
          'independently on any blockchain explorer.',
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

  Widget _progressSection(loan) {
    final total = double.tryParse(loan.amountApproved ?? loan.amountRequested) ?? 1;
    final repaid = total * 0.3;
    final progress = (repaid / total).clamp(0.0, 1.0);

    return FBCard(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Repayment Progress',
                style: AppTextStyles.labelLarge),
            Text('${(progress * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.titleMedium.copyWith(color: primary500)),
          ],
        ),
        const SizedBox(height: sp8),
        ClipRRect(
          borderRadius: radiusPill,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation<Color>(success500),
          ),
        ),
        const SizedBox(height: sp8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MWK ${repaid.toStringAsFixed(0)} repaid',
                style: AppTextStyles.caption.copyWith(color: success500)),
            Text('MWK ${total.toStringAsFixed(0)} total',
                style: AppTextStyles.caption.copyWith(color: gray500)),
          ],
        ),
      ]),
    );
  }

  Widget _scheduleSection(AsyncValue<List> scheduleAsync) {
    return scheduleAsync.when(
      loading: () => const FBSkeletonLoader(height: 150, borderRadius: BorderRadius.all(Radius.circular(12))),
      error: (_, __) => const SizedBox(),
      data: (schedule) => Column(
        children: schedule.map((s) {
          final color = switch (s.status) {
            'paid' => success500,
            'overdue' => error500,
            _ => gray500,
          };
          final bgColor = switch (s.status) {
            'overdue' => error100,
            'paid' => success100,
            _ => Colors.transparent,
          };
          return Container(
            margin: const EdgeInsets.only(bottom: sp4),
            padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: radius8,
            ),
            child: Row(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: radius8,
                ),
                child: Center(
                  child: Text('#${s.instalmentNumber}',
                      style: AppTextStyles.labelMedium.copyWith(color: color)),
                ),
              ),
              const SizedBox(width: sp12),
              Expanded(
                child: Text(s.dueDate,
                    style: AppTextStyles.bodyMedium),
              ),
              Text('MWK ${s.amountDue}',
                  style: AppTextStyles.labelMedium.copyWith(color: color)),
              const SizedBox(width: sp8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: radiusPill,
                ),
                child: Text(s.status.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(color: color, fontSize: 9)),
              ),
            ]),
          );
        }).toList(),
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
            child: Text(value,
                style: AppTextStyles.labelMedium,
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
