import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/loan_models.dart';
import '../../domain/providers.dart';

class LoanHistoryScreen extends ConsumerWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loan History')),
      body: loansAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(sp16),
          children: const [
            FBSkeletonLoader(height: 80, borderRadius: BorderRadius.all(Radius.circular(16))),
            SizedBox(height: sp8),
            FBSkeletonLoader(height: 80, borderRadius: BorderRadius.all(Radius.circular(16))),
            SizedBox(height: sp8),
            FBSkeletonLoader(height: 80, borderRadius: BorderRadius.all(Radius.circular(16))),
          ],
        ),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.refresh(loansProvider),
        ),
        data: (data) {
          final pastLoans = data.loans
              .where((l) => l.status != 'active')
              .toList();

          if (pastLoans.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 48, color: gray300),
                  const SizedBox(height: sp12),
                  Text('No past loans.',
                      style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              Text('${pastLoans.length} past loan(s)',
                  style: AppTextStyles.labelLarge.copyWith(color: gray500)),
              const SizedBox(height: sp12),
              ...pastLoans.map((loan) {
                final total = double.tryParse(loan.amountRequested) ?? 0;
                final repaid = total * 0.3;
                final rate = total > 0
                    ? (repaid / total * 100).toStringAsFixed(0)
                    : '0';
                final isClosed = loan.status == 'closed';
                final color = isClosed ? success500 : error500;

                return Padding(
                  padding: const EdgeInsets.only(bottom: sp8),
                  child: FBCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _ReadOnlyDetailScreen(loan: loan),
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: radius12,
                        ),
                        child: Icon(
                          isClosed ? Icons.check_circle : Icons.cancel,
                          color: color, size: 22,
                        ),
                      ),
                      const SizedBox(width: sp12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MWK ${loan.amountRequested}',
                                style: AppTextStyles.titleMedium),
                            Text(
                              '${loan.purpose} · ${loan.repaymentPeriodWeeks} weeks',
                              style: AppTextStyles.caption.copyWith(color: gray500),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: radiusPill,
                            ),
                            child: Text(loan.status.toUpperCase(),
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: color)),
                          ),
                          const SizedBox(height: 4),
                          Text('$rate% repaid',
                              style: AppTextStyles.caption
                                  .copyWith(color: gray500)),
                        ],
                      ),
                    ]),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _ReadOnlyDetailScreen extends StatelessWidget {
  final LoanModel loan;
  const _ReadOnlyDetailScreen({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: ListView(
        padding: const EdgeInsets.all(sp16),
        children: [
          FBCard(
            child: Column(children: [
              _row('Amount', 'MWK ${loan.amountRequested}'),
              _row('Approved', 'MWK ${loan.amountApproved ?? 'N/A'}'),
              _row('Purpose', loan.purpose),
              _row('Period', '${loan.repaymentPeriodWeeks} weeks'),
              _row('Interest Rate', '${loan.interestRate}% / week'),
              _row('Status', loan.status),
              _row('Submitted', loan.submittedAt ?? 'N/A'),
              if (loan.decidedAt != null) _row('Decided', loan.decidedAt!),
              if (loan.disbursedAt != null) _row('Disbursed', loan.disbursedAt!),
            ]),
          ),
          if (loan.aiRiskSummary != null) ...[
            const SizedBox(height: sp12),
            FBCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Risk Assessment',
                      style: AppTextStyles.labelLarge),
                  const SizedBox(height: sp4),
                  Text(loan.aiRiskSummary!,
                      style: AppTextStyles.bodyMedium.copyWith(color: gray700)),
                ],
              ),
            ),
          ],
        ],
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
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
