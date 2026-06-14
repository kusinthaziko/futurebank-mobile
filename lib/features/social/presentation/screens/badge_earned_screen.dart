import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class BadgeEarnedScreen extends StatelessWidget {
  final String badgeName;
  final String badgeType;
  final int pointsAdded;

  const BadgeEarnedScreen({
    super.key,
    this.badgeName = 'Savings Streak',
    this.badgeType = 'savings_streak',
    this.pointsAdded = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary700,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(sp32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: gold100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gold300.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(_badgeIcon, size: 60, color: gold500),
              ),
              const SizedBox(height: sp32),
              Text(
                "You've earned",
                style: AppTextStyles.titleMedium.copyWith(
                  color: white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: sp8),
              Text(
                '$badgeName Badge!',
                style: AppTextStyles.displayMedium.copyWith(color: gold300),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: sp24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp24,
                  vertical: sp12,
                ),
                decoration: BoxDecoration(
                  color: success500.withValues(alpha: 0.2),
                  borderRadius: radiusPill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: success500, size: 20),
                    const SizedBox(width: sp8),
                    Text(
                      '+$pointsAdded pts',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: success500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go('/profile'),
                child: Text(
                  'View my badges',
                  style: AppTextStyles.labelLarge.copyWith(color: white),
                ),
              ),
              const SizedBox(height: sp32),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _badgeIcon => switch (badgeType) {
    'savings_streak' => Icons.local_fire_department,
    'referral' => Icons.share,
    'loan_repayment' => Icons.credit_score,
    _ => Icons.emoji_events,
  };
}
