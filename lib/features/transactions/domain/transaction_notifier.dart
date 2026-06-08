import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/graphql/client.dart';
import '../../../core/utils/error_utils.dart';
import '../../auth/domain/auth_state.dart';
import '../../accounts/data/models/account_models.dart';
import '../data/repository.dart';

final txRepositoryProvider = Provider<TransactionRepository>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState is Authenticated ? authState.accessToken : null;
  return TransactionRepository(ref.read(graphQLClientProvider(token)));
});

class TxPageState {
  final List<TxModel> transactions;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final String? filter;
  final int page;
  final String? searchQuery;
  final String? dateFrom;
  final String? dateTo;

  const TxPageState({
    this.transactions = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.filter,
    this.page = 0,
    this.searchQuery,
    this.dateFrom,
    this.dateTo,
  });

  TxPageState copyWith({
    List<TxModel>? transactions,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    String? filter,
    int? page,
    String? searchQuery,
    String? dateFrom,
    String? dateTo,
  }) =>
      TxPageState(
        transactions: transactions ?? this.transactions,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: error ?? this.error,
        filter: filter ?? this.filter,
        page: page ?? this.page,
        searchQuery: searchQuery ?? this.searchQuery,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
      );
}

const _pageSize = 20;

class TxPageNotifier extends StateNotifier<TxPageState> {
  final String accountId;
  final Ref ref;

  TxPageNotifier(this.accountId, this.ref) : super(const TxPageState());

  void _reset() {
    state = state.copyWith(
        page: 0, transactions: [], hasMore: true, error: null);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final repo = ref.read(txRepositoryProvider);
      final next = state.page + 1;
      final results = await repo.fetchTransactions(
        accountId: accountId,
        limit: _pageSize,
        offset: state.page * _pageSize,
        type: state.filter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      );
      state = state.copyWith(
        transactions: [...state.transactions, ...results],
        hasMore: results.length >= _pageSize,
        page: next,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: friendlyErrorMessage(e));
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
        isLoading: true, page: 0, transactions: [], hasMore: true);
    try {
      final repo = ref.read(txRepositoryProvider);
      final results = await repo.fetchTransactions(
        accountId: accountId,
        limit: _pageSize,
        offset: 0,
        type: state.filter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      );
      state = state.copyWith(
        transactions: results,
        hasMore: results.length >= _pageSize,
        page: 1,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: friendlyErrorMessage(e));
    }
  }

  void setFilter(String? filter) {
    state = state.copyWith(filter: filter, searchQuery: null);
    _reset();
    refresh();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchQuery: null);
      _reset();
      refresh();
      return;
    }
    state = state.copyWith(searchQuery: query, isLoading: true);
    try {
      final repo = ref.read(txRepositoryProvider);
      final results = await repo.searchTransactions(
        accountId: accountId,
        query: query,
      );
      state = state.copyWith(
        transactions: results,
        hasMore: false,
        isLoading: false,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: friendlyErrorMessage(e));
    }
  }

  void setDateRange(String? from, String? to) {
    state = state.copyWith(dateFrom: from, dateTo: to);
    _reset();
    refresh();
  }

  void prependTransaction(TxModel tx) {
    state = state.copyWith(transactions: [tx, ...state.transactions]);
  }
}
