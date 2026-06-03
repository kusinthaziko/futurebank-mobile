import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/loan_models.dart';

class EligibilityCard extends StatelessWidget {
  final LoanEligibility eligibility;
  const EligibilityCard({super.key, required this.eligibility});

  @override
  Widget build(BuildContext context) {
    return FBCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Loan Eligibility', style: AppTextStyles.titleMedium),
        const SizedBox(height: sp8),
        if (eligibility.eligible) ...[
          Text('Max: ${eligibility.maxAmount}',
              style: AppTextStyles.bodyMedium.copyWith(color: success500)),
          const SizedBox(height: sp12),
          FBButton(label: 'Apply for a Loan',
              onPressed: () => context.push('/loans/apply')),
        ] else
          Text(eligibility.reason ?? 'KYC level 3 required',
              style: AppTextStyles.bodyMedium.copyWith(color: error500)),
      ]),
    );
  }
}
