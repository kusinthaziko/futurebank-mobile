import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../domain/providers.dart';
import '../widgets/eligibility_card.dart';
import '../widgets/loan_list_card.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(provider)),
        data: (data) => ListView(
          padding: const EdgeInsets.all(sp16),
          children: [
            EligibilityCard(eligibility: data.eligibility),
            const SizedBox(height: sp20),
            ...data.loans.map((l) => LoanListCard(loan: l)),
          ],
        ),
      ),
    );
  }
}
