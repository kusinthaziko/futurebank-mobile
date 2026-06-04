import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/loans/presentation/widgets/loan_status_stepper.dart';

void main() {
  testWidgets('shows all status steps', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoanStatusStepper(status: 'submitted'),
        ),
      ),
    );

    expect(find.text('SUBMITTED'), findsOneWidget);
    expect(find.text('UNDER REVIEW'), findsOneWidget);
    expect(find.text('APPROVED'), findsOneWidget);
    expect(find.text('DISBURSED'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('CLOSED'), findsOneWidget);
  });

  testWidgets('highlights current step with dates', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoanStatusStepper(
            status: 'approved',
            submittedAt: '2024-01-01',
            decidedAt: '2024-01-05',
          ),
        ),
      ),
    );

    expect(find.text('SUBMITTED'), findsOneWidget);
    expect(find.text('UNDER REVIEW'), findsOneWidget);
    expect(find.text('APPROVED'), findsOneWidget);
    expect(find.text('2024-01-01'), findsOneWidget);
    expect(find.text('2024-01-05'), findsOneWidget);
  });

  testWidgets('shows disbursed date when available', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoanStatusStepper(
            status: 'disbursed',
            submittedAt: '2024-01-01',
            decidedAt: '2024-01-05',
            disbursedAt: '2024-01-07',
          ),
        ),
      ),
    );

    expect(find.text('2024-01-07'), findsOneWidget);
  });

  testWidgets('shows rejection reason when rejected', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoanStatusStepper(
            status: 'rejected',
            rejectedReason: 'Insufficient credit score',
          ),
        ),
      ),
    );

    expect(find.textContaining('Insufficient credit score'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsAtLeast(1));
    expect(find.text('SUBMITTED'), findsOneWidget);
    expect(find.text('UNDER REVIEW'), findsOneWidget);
  });
}
