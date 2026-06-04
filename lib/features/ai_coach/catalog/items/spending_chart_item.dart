import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final spendingChartItem = CatalogItem(
  name: 'SpendingBreakdownChart',
  dataSchema: S.object(
    description: 'Show spending categories breakdown. Use when user asks "where does my money go?" or wants spending analysis.',
    properties: {
      'categories': S.list(
        description: 'List of spending categories',
        items: S.object(properties: {
          'name': S.string(description: 'Category name e.g. Food, Transport'),
          'amount': S.string(description: 'Amount spent e.g. "MWK 5,000"'),
          'percentage': S.number(description: 'Percentage of total 0-100'),
          'color': S.string(description: 'Hex color e.g. "#1A56DB"'),
        }, required: ['name', 'percentage']),
      ),
    },
    required: ['categories'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final categories = (json['categories'] as List<Object?>?)?.cast<Map<String, Object?>>() ?? [];

    if (categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(sp16),
        child: Text('No spending data available.',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
      );
    }

    final sections = categories.asMap().entries.map((e) {
      final c = e.value;
      final pct = (c['percentage'] as num?)?.toDouble() ?? 0;
      final colorHex = c['color'] as String? ?? '#1A56DB';
      final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      return PieChartSectionData(
        value: pct,
        title: '${pct.toStringAsFixed(0)}%',
        titleStyle: AppTextStyles.labelMedium.copyWith(color: white, fontSize: 10),
        color: color,
        radius: 50,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: radius16, boxShadow: shadowRaised,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Spending Breakdown', style: AppTextStyles.titleMedium),
        const SizedBox(height: sp16),
        SizedBox(
          height: 200,
          child: Row(children: [
            Expanded(
              child: PieChart(PieChartData(
                sections: sections,
                centerSpaceRadius: 30,
                sectionsSpace: 2,
              )),
            ),
            const SizedBox(width: sp16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((c) {
                final name = c['name'] as String? ?? '';
                final amount = c['amount'] as String? ?? '';
                final colorHex = c['color'] as String? ?? '#1A56DB';
                final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: sp4),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle,
                    )),
                    const SizedBox(width: sp8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: AppTextStyles.caption),
                      if (amount.isNotEmpty)
                        Text(amount, style: AppTextStyles.labelMedium),
                    ]),
                  ]),
                );
              }).toList(),
            ),
          ]),
        ),
      ]),
    );
  },
);
