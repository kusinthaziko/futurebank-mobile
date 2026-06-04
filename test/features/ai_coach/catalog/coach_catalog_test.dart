import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/ai_coach/catalog/coach_catalog.dart';

void main() {
  test('catalog builds with all 8 coach items', () {
    final catalog = buildCoachCatalog();

    final itemNames = catalog.items.map((i) => i.name).toSet();
    expect(itemNames.contains('BalanceCard'), isTrue);
    expect(itemNames.contains('HealthScoreMeter'), isTrue);
    expect(itemNames.contains('SavingsProgressRing'), isTrue);
    expect(itemNames.contains('SpendingBreakdownChart'), isTrue);
    expect(itemNames.contains('LoanStatusCard'), isTrue);
    expect(itemNames.contains('TransactionList'), isTrue);
    expect(itemNames.contains('ChallengeProgressCard'), isTrue);
    expect(itemNames.contains('ActionButton'), isTrue);
  });

  test('each catalog item has name, dataSchema, and widgetBuilder', () {
    final catalog = buildCoachCatalog();

    for (final item in catalog.items) {
      expect(item.name, isNotEmpty, reason: 'Item name must not be empty');
      expect(item.dataSchema, isNotNull,
          reason: '${item.name} must have a dataSchema');
      expect(item.widgetBuilder, isNotNull,
          reason: '${item.name} must have a widgetBuilder');
    }
  });

  test('each catalog item has required fields in dataSchema', () {
    final catalog = buildCoachCatalog();

    for (final item in catalog.items) {
      final schema = item.dataSchema;
      expect(schema.required, isA<List>());
      expect((schema.required as List).isNotEmpty, isTrue,
          reason: '${item.name} must have required fields');
    }
  });
}
