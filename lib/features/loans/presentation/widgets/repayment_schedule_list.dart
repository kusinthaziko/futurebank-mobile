import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/loan_models.dart';

/// Renders the repayment schedule list with coloured status indicators.
class RepaymentScheduleList extends StatelessWidget {
  final AsyncValue<List<RepaymentInstalment>> scheduleAsync;

  const RepaymentScheduleList({super.key, required this.scheduleAsync});

  @override
  Widget build(BuildContext context) {
    return scheduleAsync.when(
      loading: () => const FBSkeletonLoader(
          height: 150,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      error: (_, __) => const SizedBox(),
      data: (schedule) => Column(
        children: schedule.map((s) => _ScheduleRow(instalment: s)).toList(),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final RepaymentInstalment instalment;
  const _ScheduleRow({required this.instalment});

  Color get _color => switch (instalment.status) {
        'paid' => success500,
        'overdue' => error500,
        _ => gray500,
      };

  Color get _bgColor => switch (instalment.status) {
        'overdue' => error100,
        'paid' => success100,
        _ => Colors.transparent,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: sp4),
      padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp8),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: radius8,
      ),
      child: Row(children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.1),
            borderRadius: radius8,
          ),
          child: Center(
            child: Text('#${instalment.instalmentNumber}',
                style: AppTextStyles.labelMedium.copyWith(color: _color)),
          ),
        ),
        const SizedBox(width: sp12),
        Expanded(
          child:
              Text(instalment.dueDate, style: AppTextStyles.bodyMedium),
        ),
        Text('MWK ${instalment.amountDue}',
            style: AppTextStyles.labelMedium.copyWith(color: _color)),
        const SizedBox(width: sp8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.15),
            borderRadius: radiusPill,
          ),
          child: Text(
            instalment.status.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
                color: _color, fontSize: 9),
          ),
        ),
      ]),
    );
  }
}
