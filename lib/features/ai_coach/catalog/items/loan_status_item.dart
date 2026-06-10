import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

final loanStatusItem = CatalogItem(
  name: 'LoanStatusCard',
  dataSchema: S.object(
    description:
        'Show loan status and repayment progress. Use when user asks about their loan or repayment status.',
    properties: {
      'status': S.string(description: 'active | paid | overdue | pending'),
      'amount': S.string(description: 'Loan amount e.g. "MWK 100,000"'),
      'next_payment_date': S.string(description: 'Next due date'),
      'next_payment_amount': S.string(description: 'Next payment amount'),
      'progress_pct': S.number(description: 'Percent repaid 0-100'),
    },
    required: ['status', 'amount'],
  ),
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final status = json['status'] as String? ?? '';
    final amount = json['amount'] as String? ?? '';
    final nextDate = json['next_payment_date'] as String? ?? '';
    final nextAmount = json['next_payment_amount'] as String? ?? '';
    final pct = (json['progress_pct'] as num?)?.toDouble() ?? 0;

    final (statusColor, statusBg) = switch (status) {
      'active' => (primary500, primary100),
      'paid' => (success500, success100),
      'overdue' => (error500, error100),
      _ => (warning500, warning100),
    };

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(amount, style: AppTextStyles.titleLarge),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp8,
                  vertical: sp4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: radiusPill,
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: sp12),
          ClipRRect(
            borderRadius: radiusPill,
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: gray100,
              valueColor: const AlwaysStoppedAnimation(success500),
            ),
          ),
          const SizedBox(height: sp8),
          if (nextDate.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 12, color: gray500),
                const SizedBox(width: sp4),
                Text(
                  'Next: $nextDate',
                  style: AppTextStyles.caption.copyWith(color: gray500),
                ),
                if (nextAmount.isNotEmpty) ...[
                  const SizedBox(width: sp8),
                  Text(
                    nextAmount,
                    style: AppTextStyles.labelMedium.copyWith(color: gray700),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  },
);
