import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final savingsRingItem = CatalogItem(
  name: 'SavingsProgressRing',
  dataSchema: S.object(
    description: 'Show savings goal progress. Use when user asks about savings goals or progress toward a target.',
    properties: {
      'goal_name': S.string(description: 'Name of the savings goal'),
      'current_amount': S.string(description: 'Amount saved so far e.g. "MWK 5,000"'),
      'target_amount': S.string(description: 'Target amount e.g. "MWK 50,000"'),
      'percentage': S.number(description: 'Progress percentage 0-100'),
      'deadline': S.string(description: 'Goal deadline date'),
    },
    required: ['goal_name', 'percentage'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final name = json['goal_name'] as String? ?? '';
    final current = json['current_amount'] as String? ?? '';
    final target = json['target_amount'] as String? ?? '';
    final pct = (json['percentage'] as num?)?.toDouble() ?? 0;
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: radius16, boxShadow: shadowRaised,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.savings, size: 18, color: primary500),
          const SizedBox(width: sp8),
          Text(name, style: AppTextStyles.titleMedium),
        ]),
        const SizedBox(height: sp12),
        ClipRRect(
          borderRadius: radiusPill,
          child: LinearProgressIndicator(
            value: (pct / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: gray100,
            valueColor: const AlwaysStoppedAnimation(primary500),
          ),
        ),
        const SizedBox(height: sp8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(current, style: AppTextStyles.labelLarge.copyWith(color: success500)),
          Text('${pct.toStringAsFixed(0)}%', style: AppTextStyles.labelLarge.copyWith(color: primary500)),
          Text(target, style: AppTextStyles.labelMedium.copyWith(color: gray500)),
        ]),
      ]),
    );
  },
);
