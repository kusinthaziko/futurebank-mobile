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
  final String? activeLoanId;

  const EligibilityCard({
    super.key,
    required this.eligibility,
    this.activeLoanId,
  });

  @override
  Widget build(BuildContext context) {
    final hasActive = activeLoanId != null;

    return FBCard(
      gradient: eligibility.eligible && !hasActive,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(
              eligibility.eligible ? Icons.check_circle : Icons.cancel,
              color: eligibility.eligible ? success500 : error500,
              size: 20,
            ),
            const SizedBox(width: sp8),
            Text('Loan Eligibility',
                style: AppTextStyles.titleMedium.copyWith(
                  color: eligibility.eligible && !hasActive ? white : gray900,
                )),
          ],
        ),
        const SizedBox(height: sp16),
        if (eligibility.eligible && !hasActive) ...[
          _row('Max Loan', 'MWK ${eligibility.maxAmount}', white),
          _row('Health Score', 'Excellent', success500),
          _row('KYC Level', 'Level 3', gold300),
          const SizedBox(height: sp8),
          Text(
            'Based on your profile, you have a low risk assessment.',
            style: AppTextStyles.caption.copyWith(              color: white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: sp16),
          FBButton(
            label: 'Apply for a Loan',
            onPressed: () => context.push('/loans/apply'),
          ),
        ] else if (hasActive) ...[
          _row('Status', 'Active loan in progress', warning500),
          const SizedBox(height: sp8),
          Text(
            'You have an active loan. Please settle it before applying for a new one.',
            style: AppTextStyles.caption.copyWith(
              color: gray500,
            ),
          ),
          const SizedBox(height: sp12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.push('/loans/$activeLoanId'),
              style: TextButton.styleFrom(
                backgroundColor: primary100,
                shape: RoundedRectangleBorder(borderRadius: radiusPill),
                padding: const EdgeInsets.symmetric(vertical: sp12),
              ),
              child: const Text('View Active Loan',
                  style: AppTextStyles.labelLarge),
            ),
          ),
        ] else ...[
          _row('Status', 'Not Eligible', error500),
          const SizedBox(height: sp8),
          Text(
            eligibility.reason ?? 'Complete KYC Level 3 to qualify.',
            style: AppTextStyles.bodyMedium.copyWith(color: error500),
          ),
          const SizedBox(height: sp12),
          const FBButton(
            label: 'Apply for a Loan',
            variant: FBButtonVariant.secondary,
            onPressed: null,
          ),
          const SizedBox(height: sp4),
          Text(
            'You are not eligible yet.',
            style: AppTextStyles.caption.copyWith(color: gray500),
          ),
        ],
      ]),
    );
  }

  Widget _row(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sp4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(
              color: color.withValues(alpha: 0.7))),
          Text(value, style: AppTextStyles.labelMedium.copyWith(color: color)),
        ],
      ),
    );
  }
}
