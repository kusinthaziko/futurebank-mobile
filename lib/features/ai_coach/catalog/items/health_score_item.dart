import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final healthScoreItem = CatalogItem(
  name: 'HealthScoreMeter',
  dataSchema: S.object(
    description: 'Show financial health score with tier. Use when user asks about health score, financial standing, or creditworthiness.',
    properties: {
      'score': S.integer(description: '0-1000'),
      'tier': S.string(description: 'Poor | Fair | Good | Excellent | Elite'),
      'breakdown': S.object(description: 'Score breakdown categories', properties: {
        'payments': S.integer(), 'savings': S.integer(),
        'spending': S.integer(), 'stability': S.integer(),
      }),
    },
    required: ['score'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final score = (json['score'] as num?)?.toInt() ?? 0;
    final tier = json['tier'] as String? ?? '';
    final color = score >= 700 ? success500
        : score >= 400 ? warning500 : error500;
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: radius16, boxShadow: shadowRaised,
      ),
      child: Row(children: [
        SizedBox(
          width: 56, height: 56,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value: score / 1000, color: color, strokeWidth: 6,
              backgroundColor: gray100,
            ),
            Text('$score', style: AppTextStyles.labelLarge.copyWith(color: color)),
          ]),
        ),
        const SizedBox(width: sp16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tier, style: AppTextStyles.titleMedium.copyWith(color: color)),
          Text('Financial Health', style: AppTextStyles.caption.copyWith(color: gray500)),
        ]),
      ]),
    );
  },
);
