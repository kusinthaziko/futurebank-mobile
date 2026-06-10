// Single responsibility: health score tile only
import 'package:flutter/material.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_health_score.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../data/models/dashboard_data.dart';

class HealthScoreTile extends StatelessWidget {
  final HealthScoreModel healthScore;
  const HealthScoreTile({super.key, required this.healthScore});

  @override
  Widget build(BuildContext context) {
    return FBCard(
      child: Row(children: [
        FBHealthScoreMeter(score: healthScore.score, size: 64),
        const SizedBox(width: sp12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Financial Health', style: AppTextStyles.labelLarge),
          Text(_tier(healthScore.score),
              style: AppTextStyles.labelMedium.copyWith(color: success500)),
        ]),
        const Spacer(),
        const Icon(FbIcons.caretRight, color: gray500),
      ]),
    );
  }

  String _tier(int score) => score >= 900 ? 'Elite'
      : score >= 700 ? 'Excellent'
      : score >= 500 ? 'Good'
      : score >= 300 ? 'Fair' : 'Poor';
}
