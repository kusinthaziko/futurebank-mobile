import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class RegisterStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const RegisterStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sp24, vertical: sp12),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: (i ~/ 2) < currentStep ? color : inactive,
              ),
            );
          }
          final step = i ~/ 2;
          final done = step < currentStep;
          final active = step == currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done || active ? color : inactive,
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '${step + 1}',
                      style: AppTextStyles.caption.copyWith(
                        color: active ? Colors.white : color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}
