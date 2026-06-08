import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/subscription_providers.dart';
import '../../../../core/services/screenshot_protected_screen.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/providers.dart';
import '../../domain/transaction_notifier.dart';
import '../widgets/ai_search.dart';
import '../widgets/transaction_tile.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  final String accountId;
  const TransactionHistoryScreen({super.key, required this.accountId});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  static const _filters = [
    'All', 'Deposits', 'Withdrawals', 'Transfers', 'Loans',
  ];
  String? _activeFilter;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _scrollController.addListener(_onScroll);
    Future.microtask(
        () => ref.read(txPageProvider(widget.accountId).notifier).refresh());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  TxPageNotifier get _notifier =>
      ref.read(txPageProvider(widget.accountId).notifier);

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _notifier.loadMore();
    }
  }

  String _filterValue(String label) {
    switch (label) {
      case 'Deposits':
        return 'deposit';
      case 'Withdrawals':
        return 'withdrawal';
      case 'Transfers':
        return 'transfer';
      case 'Loans':
        return 'loan_disbursement';
      default:
        return 'All';
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primary500),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _notifier.setDateRange(
        picked.start.toIso8601String().split('T')[0],
        picked.end.toIso8601String().split('T')[0],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(txPageProvider(widget.accountId));

    ref.listen(transactionSubscriptionProvider(widget.accountId),
        (_, next) {
      next.whenData((tx) {
        _slideCtrl.forward(from: 0);
        _notifier.prependTransaction(tx);
      });
    });

    return ScreenshotProtectedScreen(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, size: 20),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: Column(
        children: [
          AISearchInput(
            onSubmitted: (q) => _notifier.search(q),
            onClear: () =>
                ref.read(txPageProvider(widget.accountId).notifier).search(''),
            isSearching: state.isLoading && state.searchQuery != null,
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: sp8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = (f == 'All' && _activeFilter == null) ||
                    _activeFilter == _filterValue(f);
                return ChoiceChip(
                  label: Text(f, style: AppTextStyles.labelMedium),
                  selected: sel,
                  selectedColor: primary500,
                  labelStyle: TextStyle(color: sel ? white : gray700),
                  onSelected: (_) {
                    setState(() {
                      _activeFilter = f == 'All' ? null : _filterValue(f);
                    });
                    _notifier.setFilter(_activeFilter);
                  },
                );
              },
            ),
          ),
          Expanded(child: _buildList(state)),
        ],
      ),
    ));
  }

  Widget _buildList(TxPageState state) {
    if (state.isLoading && state.transactions.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(sp16),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: sp12),
          child: FBSkeletonLoader(
              height: 64, borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    if (state.error != null && state.transactions.isEmpty) {
      return ErrorView(
        error: state.error!,
        onRetry: () => _notifier.refresh(),
      );
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 48, color: gray300),
            const SizedBox(height: sp12),
            Text('No transactions found.',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _slideAnim,
      builder: (_, __) => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(sp16),
        itemCount: state.transactions.length + (state.hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= state.transactions.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: sp12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final tx = state.transactions[i];
          final isNew = state.page == 1 && i == 0;

          final tile = TransactionTile(transaction: tx);

          return isNew
              ? SlideTransition(position: _slideAnim, child: tile)
              : tile;
        },
      ),
    );
  }
}
