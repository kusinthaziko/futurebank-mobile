import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/design_system/components/fb_health_score.dart';

final transactionListItem = CatalogItem(
  name: 'TransactionList',
  dataSchema: S.object(
    description:
        'Show recent transactions. Use when user asks about recent transactions or spending history. Max 5 items.',
    properties: {
      'transactions': S.list(
        items: S.object(
          properties: {
            'description': S.string(description: 'Transaction description'),
            'amount': S.string(description: 'Amount e.g. "MWK 5,000"'),
            'type': S.string(description: 'debit | credit'),
            'date': S.string(description: 'Transaction date'),
            'status': S.string(description: 'completed | pending | failed'),
          },
          required: ['description', 'amount', 'type'],
        ),
      ),
      'has_more': S.boolean(
        description: 'True if user has more than 5 transactions',
      ),
    },
    required: ['transactions'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final items =
        (json['transactions'] as List<Object?>?)
            ?.cast<Map<String, Object?>>() ??
        [];
    final hasMore = json['has_more'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius16,
        boxShadow: shadowRaised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Transactions', style: AppTextStyles.titleMedium),
          const SizedBox(height: sp12),
          ...items
              .take(5)
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: sp4),
                  child: FBTransactionTile(
                    description: t['description'] as String? ?? '',
                    amount: t['amount'] as String? ?? '',
                    type: t['type'] as String? ?? 'debit',
                    status: t['status'] as String? ?? 'completed',
                    timeAgo: t['date'] as String? ?? '',
                  ),
                ),
              ),
          if (hasMore) ...[
            const SizedBox(height: sp8),
            Text(
              '+ See all transactions',
              style: AppTextStyles.labelLarge.copyWith(color: primary500),
            ),
          ],
        ],
      ),
    );
  },
);
