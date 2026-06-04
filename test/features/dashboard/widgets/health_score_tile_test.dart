import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/dashboard/presentation/widgets/health_score_tile.dart';
import 'package:app/features/dashboard/data/models/dashboard_data.dart';

void main() {
  HealthScoreModel healthScoreWithScore(int score) {
    return HealthScoreModel(
      score: score,
      savingsConsistency: 0.8,
      loanRepaymentRate: 0.9,
      challengeCompletions: 3,
    );
  }

  testWidgets('shows score and tier for Excellent score', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HealthScoreTile(healthScore: healthScoreWithScore(750)),
        ),
      ),
    );

    expect(find.text('Financial Health'), findsOneWidget);
    expect(find.text('Excellent'), findsAtLeast(1));
  });

  testWidgets('shows Elite tier for score >= 900', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HealthScoreTile(healthScore: healthScoreWithScore(950)),
        ),
      ),
    );

    expect(find.text('Elite'), findsAtLeast(1));
  });

  testWidgets('shows Good tier for score 500-699', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HealthScoreTile(healthScore: healthScoreWithScore(600)),
        ),
      ),
    );

    expect(find.text('Good'), findsAtLeast(1));
  });

  testWidgets('shows Fair tier for score 300-499', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HealthScoreTile(healthScore: healthScoreWithScore(400)),
        ),
      ),
    );

    expect(find.text('Fair'), findsAtLeast(1));
  });

  testWidgets('shows Poor tier for score < 300', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HealthScoreTile(healthScore: healthScoreWithScore(200)),
        ),
      ),
    );

    expect(find.text('Poor'), findsAtLeast(1));
  });
}
