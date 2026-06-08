import 'package:flutter/material.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

/// Shows loan repayment progress bar with repaid/total amounts.
class RepaymentProgressCard extends StatelessWidget {
  final double totalAmount;
  final double repaidAmount;

  const RepaymentProgressCard({
    super.key,
    required this.totalAmount,
    required this.repaidAmount,
  });

  double get _progress => (repaidAmount / totalAmount).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return FBCard(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Repayment Progress',
                style: AppTextStyles.labelLarge),
            Text('${(_progress * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.titleMedium.copyWith(color: primary500)),
          ],
        ),
        const SizedBox(height: sp8),
        ClipRRect(
          borderRadius: radiusPill,
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation<Color>(success500),
          ),
        ),
        const SizedBox(height: sp8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MWK ${repaidAmount.toStringAsFixed(0)} repaid',
                style: AppTextStyles.caption.copyWith(color: success500)),
            Text('MWK ${totalAmount.toStringAsFixed(0)} total',
                style: AppTextStyles.caption.copyWith(color: gray500)),
          ],
        ),
      ]),
    );
  }
}
