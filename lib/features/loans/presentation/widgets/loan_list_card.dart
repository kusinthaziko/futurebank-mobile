// Single responsibility: one loan card in list
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/loan_models.dart';

class LoanListCard extends StatelessWidget {
  final LoanModel loan;
  const LoanListCard({super.key, required this.loan});

  Color get _statusColor => switch (loan.status) {
    'approved' || 'disbursed' || 'active' || 'closed' => success500,
    'rejected' || 'defaulted' => error500,
    _ => warning500,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/loans/${loan.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: sp8),
        child: FBCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MWK ${loan.amountRequested}',
                      style: AppTextStyles.titleMedium,
                    ),
                    Text(
                      loan.purpose,
                      style: AppTextStyles.caption.copyWith(color: gray500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp8,
                  vertical: sp4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: radiusPill,
                ),
                child: Text(
                  loan.status.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
