import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/transactions/domain/transaction_notifier.dart';
import 'package:app/features/transactions/data/repository.dart';
import 'package:app/features/accounts/data/models/account_models.dart';
import 'package:app/core/providers/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockTxRepo extends Mock implements TransactionRepository {}

void main() {
  group('TxPageState', () {
    test('initial state has correct defaults', () {
      final state = const TxPageState();
      expect(state.transactions, isEmpty);
      expect(state.isLoading, false);
      expect(state.isLoadingMore, false);
      expect(state.hasMore, true);
      expect(state.page, 0);
      expect(state.error, isNull);
      expect(state.filter, isNull);
      expect(state.searchQuery, isNull);
      expect(state.dateFrom, isNull);
      expect(state.dateTo, isNull);
    });

    test('copyWith updates properties', () {
      final state = const TxPageState();
      final updated = state.copyWith(
        page: 2,
        isLoading: true,
        hasMore: false,
        filter: 'deposit',
      );

      expect(updated.page, 2);
      expect(updated.isLoading, true);
      expect(updated.hasMore, false);
      expect(updated.filter, 'deposit');
      expect(updated.transactions, isEmpty);
    });

    test('copyWith preserves unset properties', () {
      final state = const TxPageState(page: 1);
      final updated = state.copyWith(isLoading: true);

      expect(updated.page, 1);
      expect(updated.isLoading, true);
      expect(updated.hasMore, true);
    });
  });

  group('TxPageNotifier', () {
    late _MockTxRepo mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = _MockTxRepo();
      container = ProviderContainer(
        overrides: [
          txRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is correct', () {
      final p = StateNotifierProvider
          .family<TxPageNotifier, TxPageState, String>(
        (ref, accountId) => TxPageNotifier(accountId, ref),
      );

      final notifier = container.read(p('test-account').notifier);
      expect(notifier.state.transactions, isEmpty);
      expect(notifier.state.page, 0);
      expect(notifier.state.hasMore, true);
    });

    test('prependTransaction adds to beginning', () {
      final p = StateNotifierProvider
          .family<TxPageNotifier, TxPageState, String>(
        (ref, accountId) => TxPageNotifier(accountId, ref),
      );

      final notifier = container.read(p('test-account').notifier);

      notifier.prependTransaction(
        TxModel(
          id: '1',
          reference: 'REF1',
          amount: '5000',
          transactionType: 'deposit',
          status: 'completed',
          insertedAt: '2024-01-15T10:00:00Z',
        ),
      );
      expect(notifier.state.transactions.length, 1);
      expect(notifier.state.transactions.first.id, '1');
    });

    test('loadMore updates state with transactions', () async {
      when(
        () => mockRepo.fetchTransactions(
          accountId: any(named: 'accountId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => [
        TxModel(id: '1', reference: 'REF1', amount: '5000',
            transactionType: 'deposit', status: 'completed',
            insertedAt: '2024-01-15T10:00:00Z'),
        TxModel(id: '2', reference: 'REF2', amount: '2000',
            transactionType: 'withdrawal', status: 'completed',
            insertedAt: '2024-01-14T10:00:00Z'),
      ]);

      final p = StateNotifierProvider
          .family<TxPageNotifier, TxPageState, String>(
        (ref, accountId) => TxPageNotifier(accountId, ref),
      );

      final notifier = container.read(p('test-account').notifier);
      await notifier.loadMore();

      expect(notifier.state.transactions.length, 2);
      expect(notifier.state.transactions[0].id, '1');
      expect(notifier.state.page, 1);
      expect(notifier.state.isLoadingMore, false);
    });

    test('filter updates state', () async {
      when(
        () => mockRepo.fetchTransactions(
          accountId: any(named: 'accountId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);

      final p = StateNotifierProvider
          .family<TxPageNotifier, TxPageState, String>(
        (ref, accountId) => TxPageNotifier(accountId, ref),
      );

      final notifier = container.read(p('test-account').notifier);
      notifier.setFilter('deposit');

      // Wait for async refresh to complete
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.filter, 'deposit');
      expect(notifier.state.searchQuery, isNull);
    });

    test('refresh resets to page 1', () async {
      when(
        () => mockRepo.fetchTransactions(
          accountId: any(named: 'accountId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => [
        TxModel(id: '1', reference: 'REF1', amount: '5000',
            transactionType: 'deposit', status: 'completed',
            insertedAt: '2024-01-15T10:00:00Z'),
      ]);

      final p = StateNotifierProvider
          .family<TxPageNotifier, TxPageState, String>(
        (ref, accountId) => TxPageNotifier(accountId, ref),
      );

      final notifier = container.read(p('test-account').notifier);

      await notifier.loadMore();
      expect(notifier.state.page, 1);

      await notifier.refresh();
      expect(notifier.state.page, 1);
      expect(notifier.state.isLoading, false);
    });
  });
}
