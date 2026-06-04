import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class WeeklyInsightsCard extends StatelessWidget {
  final String amountSaved;
  final String savingsChange;
  final String topSpendCategory;
  final String topSpendAmount;
  final String loanStatus;
  final String healthScoreChange;
  final bool onTrack;

  const WeeklyInsightsCard({
    super.key,
    required this.amountSaved,
    required this.savingsChange,
    required this.topSpendCategory,
    required this.topSpendAmount,
    required this.loanStatus,
    required this.healthScoreChange,
    this.onTrack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(sp16, sp8, sp16, sp8),
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary700, primary500],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: radius16,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_graph, size: 18, color: gold300),
          const SizedBox(width: sp8),
          Text('Your Week in Review',
              style: AppTextStyles.titleMedium.copyWith(color: white)),
        ]),
        const SizedBox(height: sp12),
        _row(Icons.savings, 'Saved $amountSaved ($savingsChange)', success100),
        const SizedBox(height: 6),
        _row(Icons.trending_up, 'Top spend: $topSpendCategory $topSpendAmount', gold100),
        const SizedBox(height: 6),
        _row(
          onTrack ? Icons.check_circle : Icons.warning,
          'Loan repayment: ${onTrack ? "On track" : "Needs attention"}',
          onTrack ? success100 : error100,
        ),
        const SizedBox(height: 6),
        _row(Icons.favorite, 'Health score: $healthScoreChange', primary100),
      ]),
    );
  }

  Widget _row(IconData icon, String text, Color color) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: sp8),
      Expanded(child: Text(text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: white.withValues(alpha: 0.9),
          ))),
    ]);
  }
}
