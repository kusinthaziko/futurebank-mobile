import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class LoanStatusStepper extends StatelessWidget {
  final String status;
  final String? rejectedReason;
  final String? decidedAt;
  final String? submittedAt;
  final String? disbursedAt;

  const LoanStatusStepper({
    super.key,
    required this.status,
    this.rejectedReason,
    this.decidedAt,
    this.submittedAt,
    this.disbursedAt,
  });

  static const _steps = [
    'submitted', 'under_review', 'approved', 'disbursed', 'active', 'closed',
  ];

  int get _currentIndex {
    // If rejected, show up to rejected position
    if (status == 'rejected') return 2;
    final i = _steps.indexOf(status);
    return i < 0 ? 0 : i;
  }

  bool get _isRejected => status == 'rejected';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(_steps.length, (i) {
          final done = i <= _currentIndex && !(_isRejected && i > 2);
          final isCurrent = i == _currentIndex && !_isRejected;
          final isRejectedStep = _isRejected && i == 2;

          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isRejectedStep
                      ? error500
                      : done
                          ? primary500
                          : gray100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isRejectedStep
                        ? error500
                        : done
                            ? primary500
                            : gray300,
                  ),
                ),
                child: isRejectedStep
                    ? const Icon(Icons.close, size: 14, color: Colors.white)
                    : done
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
              ),
              if (i < _steps.length - 1)
                Container(
                  width: 2,
                  height: 32,
                  color: i < _currentIndex ? primary500 : gray100,
                ),
            ]),
            const SizedBox(width: sp12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: i < _steps.length - 1 ? 8 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[i].replaceAll('_', ' ').toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isCurrent
                            ? primary500
                            : done
                                ? gray700
                                : gray300,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (i == 0 && submittedAt != null)
                      Text(submittedAt!,
                          style: AppTextStyles.caption.copyWith(color: gray500)),
                    if (i == 2 && _isRejected && rejectedReason != null) ...[
                      const SizedBox(height: sp4),
                      Container(
                        padding: const EdgeInsets.all(sp8),
                        decoration: BoxDecoration(
                          color: error100,
                          borderRadius: radius8,
                        ),
                        child: Text(rejectedReason!,
                            style: AppTextStyles.caption
                                .copyWith(color: error500)),
                      ),
                    ],
                    if (i == 2 && !_isRejected && decidedAt != null)
                      Text(decidedAt!,
                          style: AppTextStyles.caption.copyWith(color: gray500)),
                    if (i == 3 && disbursedAt != null)
                      Text(disbursedAt!,
                          style: AppTextStyles.caption.copyWith(color: gray500)),
                  ],
                ),
              ),
            ),
          ]);
        }),
      ],
    );
  }
}
