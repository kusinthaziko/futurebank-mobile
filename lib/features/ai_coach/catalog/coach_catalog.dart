import 'package:genui/genui.dart';
import 'items/balance_card_item.dart';
import 'items/health_score_item.dart';
import 'items/savings_ring_item.dart';
import 'items/spending_chart_item.dart';
import 'items/loan_status_item.dart';
import 'items/transaction_list_item.dart';
import 'items/challenge_progress_item.dart';
import 'items/action_button_item.dart';

Catalog buildCoachCatalog() {
  return BasicCatalogItems.asCatalog().copyWith(
    newItems: [
      balanceCardItem,
      healthScoreItem,
      savingsRingItem,
      spendingChartItem,
      loanStatusItem,
      transactionListItem,
      challengeProgressItem,
      actionButtonItem,
    ],
  );
}
