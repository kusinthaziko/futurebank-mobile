import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/dimensions.dart';

final actionButtonItem = CatalogItem(
  name: 'ActionButton',
  dataSchema: S.object(
    description: 'Show a call-to-action button. Use when a clear next action is available after showing data.',
    properties: {
      'label': S.string(description: 'Short button label. Max 3 words.'),
      'action': S.string(
        description: 'The navigation action to perform',
        enumValues: ['apply_loan', 'view_transactions', 'view_goals', 'join_challenge', 'make_repayment'],
      ),
    },
    required: ['label', 'action'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final label = json['label'] as String? ?? 'Continue';
    final action = json['action'] as String? ?? '';

    final route = switch (action) {
      'apply_loan' => '/loans/apply',
      'view_transactions' => '/transactions',
      'view_goals' => '/goals',
      'join_challenge' => '/challenges',
      'make_repayment' => '/loans/repay',
      _ => null,
    };

    return Builder(builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: sp8),
      child: FBButton(
        label: label,
        onPressed: route != null ? () => Navigator.of(context).pushNamed(route) : null,
        icon: Icon(
          switch (action) {
            'apply_loan' => Icons.add_card,
            'view_transactions' => Icons.receipt_long,
            'view_goals' => Icons.flag,
            'join_challenge' => Icons.emoji_events,
            'make_repayment' => Icons.payments,
            _ => Icons.arrow_forward,
          },
          size: 18,
        ),
      ),
    ));
  },
);
