import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class LoanStatusStepper extends StatelessWidget {
  final String status;
  const LoanStatusStepper({super.key, required this.status});

  static const _steps = [
    'submitted', 'under_review', 'approved', 'disbursed', 'active', 'closed'
  ];

  int get _currentIndex {
    final i = _steps.indexOf(status);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(_steps.length, (i) {
      final done = i <= _currentIndex;
      final isCurrent = i == _currentIndex;
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: done ? primary500 : gray100,
              shape: BoxShape.circle,
              border: Border.all(color: done ? primary500 : gray300),
            ),
            child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          if (i < _steps.length - 1)
            Container(width: 2, height: 28, color: done ? primary500 : gray100),
        ]),
        const SizedBox(width: sp12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(_steps[i].replaceAll('_', ' ').toUpperCase(),
              style: AppTextStyles.labelMedium.copyWith(
                  color: isCurrent ? primary500 : done ? gray700 : gray300)),
        ),
      ]);
    }));
  }
}
