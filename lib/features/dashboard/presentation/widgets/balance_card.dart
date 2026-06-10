import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../../../core/widgets/animations/card_lift.dart';
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

    return CardLift(
      child: Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: radius24,
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2F6E), Color(0xFF1A56DB), Color(0xFF4D7FE8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary500.withValues(alpha: 0.4),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius24,
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(top: -40, right: -30,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(bottom: -50, left: 20,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Frosted glass layer
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.transparent),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(sp20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Balance',
                          style: AppTextStyles.labelMedium.copyWith(
                              color: white.withValues(alpha: 0.7))),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        // chip: account type
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: sp8, vertical: 2),
                          decoration: BoxDecoration(
                            color: white.withValues(alpha: 0.15),
                            borderRadius: radiusPill,
                          ),
                          child: Text(account.accountType.toUpperCase(),
                              style: AppTextStyles.caption.copyWith(
                                  color: white, letterSpacing: 0.8)),
                        ),
                        const SizedBox(width: sp8),
                        GestureDetector(
                          onTap: () => ref
                              .read(_balanceBlurredProvider.notifier)
                              .state = !blurred,
                          child: Icon(
                            blurred
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: white.withValues(alpha: 0.7),
                            size: 18,
                          ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: sp12),
                  if (blurred)
                    Text('${account.currency} ••••••',
                        style: AppTextStyles.displayMedium.copyWith(
                            color: white, letterSpacing: 2))
                  else
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: numericBalance),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (_, value, __) => Text(
                        '${account.currency} ${value.toStringAsFixed(2)}',
                        style: AppTextStyles.displayMedium.copyWith(
                            color: white, letterSpacing: -0.5),
                      ),
                    ),
                  const Spacer(),
                  Row(children: [
                    Text(
                      account.accountNumber,
                      style: AppTextStyles.caption.copyWith(
                          color: white.withValues(alpha: 0.55)),
                    ),
                    const Spacer(),
                    if (delta != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: sp8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (delta >= 0 ? success500 : error500)
                              .withValues(alpha: 0.25),
                          borderRadius: radiusPill,
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(
                            delta >= 0
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            size: 13,
                            color: delta >= 0 ? success100 : error100,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}%',
                            style: AppTextStyles.caption.copyWith(
                                color: delta >= 0 ? success100 : error100,
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
