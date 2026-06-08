import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:app/features/dashboard/data/models/dashboard_data.dart' as dash;
import 'package:app/features/accounts/data/models/account_models.dart';
import 'package:app/features/dashboard/domain/providers.dart';
import 'package:app/core/providers/subscription_providers.dart';

void main() {
  final mockAccount = dash.AccountModel(
    id: 'test-account',
    accountNumber: '1234567890',
    accountType: 'savings',
    balance: '24500.00',
    currency: 'MWK',
    status: 'active',
  );

  final mockLiveAccount = AccountModel(
    id: 'test-account',
    accountNumber: '1234567890',
    accountType: 'savings',
    balance: '24500.00',
    currency: 'MWK',
    status: 'active',
    interestRate: '0',
  );

  testWidgets('BalanceCard shows formatted balance', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          balanceSubscriptionProvider(mockAccount.id).overrideWith(
            (ref) => Stream.value(mockLiveAccount),
          ),
          monthlyDeltaProvider(mockAccount.id).overrideWith(
            (ref) async => 5.0,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BalanceCard(account: mockAccount),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(find.textContaining('MWK'), findsOneWidget);
    expect(find.text('MWK 24500.00'), findsOneWidget);
  });

  testWidgets('BalanceCard hides balance when blurred', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          balanceSubscriptionProvider(mockAccount.id).overrideWith(
            (ref) => Stream.value(mockLiveAccount),
          ),
          monthlyDeltaProvider(mockAccount.id).overrideWith(
            (ref) async => 5.0,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BalanceCard(account: mockAccount),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('MWK 24500.00'), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    // Tap the eye toggle to blur
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(find.text('MWK ••••••'), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    // Tap again to unblur
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('MWK 24500.00'), findsOneWidget);
  });

  testWidgets('BalanceCard shows account number and Total Balance label',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          balanceSubscriptionProvider(mockAccount.id).overrideWith(
            (ref) => Stream.value(mockLiveAccount),
          ),
          monthlyDeltaProvider(mockAccount.id).overrideWith(
            (ref) async => 5.0,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: BalanceCard(account: mockAccount),
          ),
        ),
      ),
    );

    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.textContaining('1234567890'), findsOneWidget);
  });
}
