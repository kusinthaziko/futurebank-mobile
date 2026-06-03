import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

Catalog buildCoachCatalog() {
  final balanceCard = CatalogItem(
    name: 'BalanceCard',
    dataSchema: S.object(
      description: 'Show account balance. Use when user asks about their balance.',
      properties: {
        'balance': S.string(description: 'e.g. MWK 24,500'),
        'monthly_change': S.string(description: 'e.g. +MWK 3,200'),
        'trend': S.string(description: 'up | down | flat'),
      },
      required: ['balance'],
    ),
    widgetBuilder: (ctx) {
      final json = ctx.data as Map<String, Object?>;
      final balance = json['balance'] as String? ?? '';
      final change = json['monthly_change'] as String? ?? '';
      final trend = json['trend'] as String? ?? 'flat';
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0D2F6E), Color(0xFF1A56DB)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(balance, style: const TextStyle(color: Colors.white, fontSize: 24,
              fontWeight: FontWeight.w600)),
          Text(change, style: TextStyle(
              color: trend == 'up' ? Colors.greenAccent : Colors.white70, fontSize: 12)),
        ]),
      );
    },
  );

  final healthScore = CatalogItem(
    name: 'HealthScoreMeter',
    dataSchema: S.object(
      description: 'Show financial health score. Use for health score questions.',
      properties: {
        'score': S.integer(description: '0-1000'),
        'tier': S.string(description: 'Poor/Fair/Good/Excellent/Elite'),
      },
      required: ['score'],
    ),
    widgetBuilder: (ctx) {
      final json = ctx.data as Map<String, Object?>;
      final score = (json['score'] as num?)?.toInt() ?? 0;
      final tier = json['tier'] as String? ?? '';
      final color = score >= 700 ? const Color(0xFF0D9B64)
          : score >= 400 ? const Color(0xFFF59E0B) : const Color(0xFFDC2626);
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 8)]),
        child: Row(children: [
          SizedBox(width: 56, height: 56,
              child: CircularProgressIndicator(value: score / 1000, color: color, strokeWidth: 6)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$score / 1000', style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w700, color: color)),
            Text(tier, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          ]),
        ]),
      );
    },
  );

  final savingsRing = CatalogItem(
    name: 'SavingsProgressRing',
    dataSchema: S.object(
      description: 'Show savings goal progress. Use for savings/goals questions.',
      properties: {
        'goal_name': S.string(),
        'current_amount': S.string(),
        'target_amount': S.string(),
        'percentage': S.number(description: '0-100'),
      },
      required: ['goal_name', 'percentage'],
    ),
    widgetBuilder: (ctx) {
      final json = ctx.data as Map<String, Object?>;
      final name = json['goal_name'] as String? ?? '';
      final current = json['current_amount'] as String? ?? '';
      final target = json['target_amount'] as String? ?? '';
      final pct = (json['percentage'] as num?)?.toDouble() ?? 0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: pct / 100,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF1A56DB))),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(current, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
            Text('${pct.toStringAsFixed(0)}%',
                style: const TextStyle(color: Color(0xFF1A56DB), fontWeight: FontWeight.w600)),
            Text(target, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          ]),
        ]),
      );
    },
  );

  final loanCard = CatalogItem(
    name: 'LoanStatusCard',
    dataSchema: S.object(
      description: 'Show loan status. Use when user asks about loans.',
      properties: {
        'status': S.string(),
        'amount': S.string(),
        'next_payment': S.string(),
        'progress_pct': S.number(description: '0-100 percent repaid'),
      },
      required: ['status', 'amount'],
    ),
    widgetBuilder: (ctx) {
      final json = ctx.data as Map<String, Object?>;
      final status = json['status'] as String? ?? '';
      final amount = json['amount'] as String? ?? '';
      final next = json['next_payment'] as String? ?? '';
      final pct = (json['progress_pct'] as num?)?.toDouble() ?? 0;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(100)),
              child: Text(status.toUpperCase(),
                  style: const TextStyle(color: Color(0xFF1A56DB), fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: (pct / 100).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF0D9B64))),
          if (next.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Next: $next',
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          ],
        ]),
      );
    },
  );

  return BasicCatalogItems.asCatalog().copyWith(
    newItems: [
      balanceCard, healthScore, savingsRing, loanCard,
    ],
  );
}

String buildCoachSystemPrompt(Catalog catalog) {
  return PromptBuilder.chat(
    catalog: catalog,
    systemPromptFragments: ['''
You are a personal financial coach for a university student.
Always respond using widgets from the catalog — never plain text.

Widget usage:
- Balance question → BalanceCard
- Health score question → HealthScoreMeter
- Savings/goals question → SavingsProgressRing
- Loan question → LoanStatusCard

Max 2 widgets per response. Never invent numbers.
'''],
  ).systemPromptJoined();
}
