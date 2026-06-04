import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/providers.dart';
import '../widgets/eligibility_card.dart';
import '../widgets/loan_list_card.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        actions: [
          TextButton(
            onPressed: () => context.push('/loans/history'),
            child: const Text('History'),
          ),
        ],
      ),
      body: loansAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(sp16),
          children: const [
            FBSkeletonLoader(height: 180, borderRadius: BorderRadius.all(Radius.circular(16))),
            SizedBox(height: sp20),
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
          final activeLoans =
              data.loans.where((l) => l.status == 'active').toList();
          final pastLoans = data.loans
              .where((l) => l.status != 'active')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(sp16),
            children: [
              EligibilityCard(
                eligibility: data.eligibility,
                activeLoanId: activeLoans.isNotEmpty ? activeLoans.first.id : null,
              ),
              if (activeLoans.isNotEmpty) ...[
                const SizedBox(height: sp20),
                const Text('Active Loans',
                    style: AppTextStyles.titleMedium),
                const SizedBox(height: sp8),
                ...activeLoans.map((l) => LoanListCard(loan: l)),
              ],
              if (data.eligibility.eligible && activeLoans.isEmpty) ...[
                const SizedBox(height: sp16),
                FBButton(
                  label: 'Apply for a Loan',
                  onPressed: () => context.push('/loans/apply'),
                ),
              ],
              if (pastLoans.isNotEmpty) ...[
                const SizedBox(height: sp24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Past Loans',
                        style: AppTextStyles.titleMedium),
                    TextButton(
                      onPressed: () => context.push('/loans/history'),
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: sp8),
                ...pastLoans.take(3).map((l) => LoanListCard(loan: l)),
              ],
            ],
          );
        },
      ),
    );
  }
}
