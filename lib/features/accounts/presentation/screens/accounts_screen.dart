import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../domain/providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.refresh(provider)),
        data: (data) => ListView(
          padding: const EdgeInsets.all(sp16),
          children: [
            ...data.accounts.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: sp12),
              child: FBCard(
                gradient: a.accountType == 'savings',
                onTap: () => context.push('/accounts/${a.id}/history'),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.accountType.toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(
                          color: a.accountType == 'savings' ? Colors.white70 : gray500)),
                  const SizedBox(height: sp8),
                  Text('${a.currency} ${a.balance}',
                      style: AppTextStyles.displayMedium.copyWith(
                          color: a.accountType == 'savings' ? Colors.white : gray900)),
                  const SizedBox(height: sp4),
                  Text(a.accountNumber,
                      style: AppTextStyles.caption.copyWith(
                          color: a.accountType == 'savings'
                              ? Colors.white54 : gray500)),
                ]),
              ),
            )),
            if (data.goals.isNotEmpty) ...[
              const SizedBox(height: sp8),
              Text('Savings Goals', style: AppTextStyles.titleMedium),
              const SizedBox(height: sp8),
              ...data.goals.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: sp8),
                child: FBCard(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(g.name, style: AppTextStyles.labelLarge),
                    Text('${g.category}',
                        style: AppTextStyles.caption.copyWith(color: gray500)),
                  ]),
                  const SizedBox(height: sp8),
                  LinearProgressIndicator(
                    value: _progress(g.currentAmount, g.targetAmount),
                    backgroundColor: gray100,
                    valueColor: const AlwaysStoppedAnimation(primary500),
                  ),
                  const SizedBox(height: sp4),
                  Text('${g.currentAmount} / ${g.targetAmount}',
                      style: AppTextStyles.caption.copyWith(color: gray500)),
                ])),
              )),
            ],
          ],
        ),
      ),
    );
  }

  double _progress(String current, String target) {
    final c = double.tryParse(current) ?? 0;
    final t = double.tryParse(target) ?? 1;
    return t > 0 ? (c / t).clamp(0.0, 1.0) : 0;
  }
}
