// Single responsibility: balance card widget only
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/dashboard_data.dart';

final _balanceBlurredProvider = StateProvider<bool>((ref) => false);

class BalanceCard extends ConsumerWidget {
  final AccountModel account;
  const BalanceCard({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blurred = ref.watch(_balanceBlurredProvider);
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
        Text(
          blurred ? '${account.currency} ••••••' : '${account.currency} ${account.balance}',
          style: AppTextStyles.displayMedium.copyWith(color: white),
        ),
        const SizedBox(height: sp4),
        Text(account.accountNumber,
            style: AppTextStyles.caption.copyWith(color: Colors.white54)),
      ]),
    );
  }
}
