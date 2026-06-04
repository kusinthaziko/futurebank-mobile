// Single responsibility: balance card widget only
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../data/models/dashboard_data.dart';
import '../../domain/providers.dart';

final _balanceBlurredProvider = StateProvider<bool>((ref) => false);

class BalanceCard extends ConsumerWidget {
  final AccountModel account;
  const BalanceCard({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blurred = ref.watch(_balanceBlurredProvider);

    final balanceSub = ref.watch(balanceSubscriptionProvider(account.id));
    final liveBalance = balanceSub.whenOrNull(data: (a) => a.balance);
    final displayBalance = liveBalance ?? account.balance;

    final deltaAsync = ref.watch(monthlyDeltaProvider(account.id));
    final delta = deltaAsync.whenOrNull(data: (d) => d);

    final numericBalance = double.tryParse(displayBalance) ?? 0;

    return FBCard(
      gradient: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total Balance',
              style: AppTextStyles.labelMedium.copyWith(color: Colors.white70)),
          IconButton(
            icon: Icon(blurred ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70, size: 20),
            onPressed: () =>
                ref.read(_balanceBlurredProvider.notifier).state = !blurred,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ]),
        const SizedBox(height: sp8),
        if (blurred)
          Text('${account.currency} ••••••',
              style: AppTextStyles.displayMedium.copyWith(color: white))
        else
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: numericBalance),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, _) => Text(
              '${account.currency} ${value.toStringAsFixed(2)}',
              style: AppTextStyles.displayMedium.copyWith(color: white),
            ),
          ),
        const SizedBox(height: sp4),
        Row(children: [
          Text(account.accountNumber,
              style: AppTextStyles.caption.copyWith(color: Colors.white54)),
          const Spacer(),
          if (delta != null)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                delta >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: delta >= 0 ? success100 : error100,
              ),
              const SizedBox(width: sp2),
              Text(
                '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                    color: delta >= 0 ? success100 : error100),
              ),
            ]),
        ]),
      ]),
    );
  }
}
