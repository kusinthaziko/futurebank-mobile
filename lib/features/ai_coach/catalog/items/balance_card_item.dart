import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final balanceCardItem = CatalogItem(
  name: 'BalanceCard',
  dataSchema: S.object(
    description: 'Show the user\'s current account balance with monthly change. Use when user asks about their balance or overall financial state.',
    properties: {
      'balance': S.string(description: 'Formatted balance e.g. "MWK 24,500"'),
      'monthly_change': S.string(description: 'Change this month e.g. "+MWK 3,200"'),
      'trend': S.string(description: 'up | down | flat'),
    },
    required: ['balance'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final balance = json['balance'] as String? ?? '';
    final change = json['monthly_change'] as String? ?? '';
    final trend = json['trend'] as String? ?? 'flat';
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primary700, primary500]),
        borderRadius: radius16,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Balance', style: AppTextStyles.caption.copyWith(color: white.withValues(alpha: 0.7))),
        const SizedBox(height: sp4),
        Text(balance, style: AppTextStyles.displayMedium.copyWith(color: white)),
        Row(children: [
          Icon(
            trend == 'up' ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14, color: trend == 'up' ? success100 : error100,
          ),
          const SizedBox(width: sp4),
          Text(change, style: AppTextStyles.labelMedium.copyWith(
            color: trend == 'up' ? success100 : error100)),
        ]),
      ]),
    );
  },
);
