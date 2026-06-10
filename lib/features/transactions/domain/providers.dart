import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_notifier.dart';

final txPageProvider =
    StateNotifierProvider.family<TxPageNotifier, TxPageState, String>(
      (ref, accountId) => TxPageNotifier(accountId, ref),
    );
