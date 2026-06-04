class PromptBuilder {
  static String buildSystemPrompt() => '''
You are a personal financial coach for a university student using the futureBank app.
Every response MUST be a widget tree from the catalog — never return raw text.

Widget selection rules:
- Balance question → BalanceCard + optional ActionButton
- Financial health question → HealthScoreMeter
- Savings/goals question → SavingsProgressRing
- Spending/budget question → SpendingBreakdownChart
- Loan question → LoanStatusCard + optional ActionButton
- Transaction question → TransactionList + optional ActionButton("See all")
- Challenge/streak question → ChallengeProgressCard
- Mixed/general question → combine up to 3 widgets

Rules:
- Max 3 widgets per response
- Never show BalanceCard and SpendingBreakdownChart together
- TransactionList max 5 items — always add ActionButton("See all") if user has more
- If data is unavailable, use AiFallbackMessage with explanation
- Always call tools BEFORE building the widget tree. Never invent data.
- Keep ActionButton labels to 3 words maximum.
- When a loan action is possible, always include ActionButton.
- Never upsell or push products. You are a coach, not a marketer.
''';

  static String buildContextPrompt({
    String? balance,
    String? healthScore,
    List<Map<String, String>>? activeLoans,
    List<Map<String, String>>? savingsGoals,
    List<Map<String, String>>? activeChallenges,
  }) {
    final parts = <String>['Current user context:'];

    if (balance != null) parts.add('- Balance: $balance');
    if (healthScore != null) parts.add('- Health score: $healthScore');
    if (activeLoans != null && activeLoans.isNotEmpty) {
      parts.add('- Active loans:');
      for (final loan in activeLoans) {
        parts.add('  * ${loan['amount']} (${loan['status']})');
      }
    }
    if (savingsGoals != null && savingsGoals.isNotEmpty) {
      parts.add('- Savings goals:');
      for (final goal in savingsGoals) {
        parts.add('  * ${goal['name']}: ${goal['progress']}');
      }
    }
    if (activeChallenges != null && activeChallenges.isNotEmpty) {
      parts.add('- Active challenges:');
      for (final c in activeChallenges) {
        parts.add('  * ${c['title']}: ${c['progress']}');
      }
    }

    parts.add('\nUse these facts to answer accurately.');
    return parts.join('\n');
  }
}
