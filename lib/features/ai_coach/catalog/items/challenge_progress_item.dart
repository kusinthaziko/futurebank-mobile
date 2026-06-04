import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final challengeProgressItem = CatalogItem(
  name: 'ChallengeProgressCard',
  dataSchema: S.object(
    description: 'Show challenge progress with streak. Use when user asks about challenges, streak, or leaderboard position.',
    properties: {
      'title': S.string(description: 'Challenge name e.g. "Save MWK 20,000"'),
      'current_value': S.number(description: 'Current progress value'),
      'target_value': S.number(description: 'Target value to complete'),
      'days_remaining': S.integer(description: 'Days left to complete'),
      'streak_days': S.integer(description: 'Current streak in days'),
    },
    required: ['title', 'current_value', 'target_value'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final title = json['title'] as String? ?? '';
    final current = (json['current_value'] as num?)?.toDouble() ?? 0;
    final target = (json['target_value'] as num?)?.toDouble() ?? 1;
    final daysLeft = (json['days_remaining'] as num?)?.toInt() ?? 0;
    final streak = (json['streak_days'] as num?)?.toInt() ?? 0;
    final pct = (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: radius16, boxShadow: shadowRaised,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (streak > 0) ...[
            const Icon(Icons.local_fire_department, size: 18, color: warning500),
            const SizedBox(width: sp4),
          ],
          Text(title, style: AppTextStyles.titleMedium),
        ]),
        const SizedBox(height: sp12),
        ClipRRect(
          borderRadius: radiusPill,
          child: LinearProgressIndicator(
            value: pct, minHeight: 10,
            backgroundColor: gray100,
            valueColor: AlwaysStoppedAnimation(
              pct >= 1.0 ? success500 : primary500),
          ),
        ),
        const SizedBox(height: sp8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${current.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}',
              style: AppTextStyles.labelMedium.copyWith(color: gray700)),
          Text('${(pct * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.labelLarge.copyWith(color: primary500)),
        ]),
        const SizedBox(height: sp8),
        Row(children: [
          if (streak > 0) ...[
            const Icon(Icons.local_fire_department, size: 14, color: warning500),
            const SizedBox(width: sp4),
            Text('$streak-day streak',
                style: AppTextStyles.labelMedium.copyWith(color: warning500)),
            const Spacer(),
          ],
          const Icon(Icons.access_time, size: 14, color: gray500),
          const SizedBox(width: sp4),
          Text(daysLeft > 0 ? '$daysLeft days left' : 'Last day!',
              style: AppTextStyles.caption.copyWith(
                color: daysLeft <= 1 ? error500 : gray500,
                fontWeight: daysLeft <= 1 ? FontWeight.w600 : FontWeight.w400,
              )),
        ]),
      ]),
    );
  },
);
