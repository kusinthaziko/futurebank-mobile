import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/client.dart';
import '../providers/auth_provider.dart';
import '../../features/accounts/data/models/account_models.dart';

// --- Subscription strings ---
const _balanceChangedSub = r'''
  subscription BalanceChanged($accountId: ID!) {
    balanceChanged(accountId: $accountId) { id balance currency }
  }
''';

const _transactionUpdatedSub = r'''
  subscription TxUpdated($accountId: ID!) {
    transactionUpdated(accountId: $accountId) {
      id reference description amount transaction_type status inserted_at
    }
  }
''';

const _loanStatusSub = r'''
  subscription LoanStatus($loanId: ID!) {
    loanStatusChanged(loanId: $loanId) { id status decided_at }
  }
''';

const _newNotificationSub = r'''
  subscription NewNotification {
    newNotification { id type title body read inserted_at }
  }
''';

// --- Providers ---

final balanceSubscriptionProvider =
    StreamProvider.autoDispose.family<AccountModel, String>((ref, accountId) {
  final token = ref.watch(authProvider).accessToken;
  final client = ref.read(graphQLClientProvider(token));
  return client
      .subscribe(SubscriptionOptions(
        document: gql(_balanceChangedSub),
        variables: {'accountId': accountId},
      ))
      .where((r) => !r.hasException && r.data != null)
      .map((r) => AccountModel.fromJson({
            'id': r.data!['balanceChanged']['id'],
            'accountNumber': '',
            'accountType': 'savings',
            'balance': r.data!['balanceChanged']['balance'],
            'currency': r.data!['balanceChanged']['currency'],
            'status': 'active',
            'interestRate': '0',
          }));
});

final transactionSubscriptionProvider =
    StreamProvider.autoDispose.family<TxModel, String>((ref, accountId) {
  final token = ref.watch(authProvider).accessToken;
  final client = ref.read(graphQLClientProvider(token));
  return client
      .subscribe(SubscriptionOptions(
        document: gql(_transactionUpdatedSub),
        variables: {'accountId': accountId},
      ))
      .where((r) => !r.hasException && r.data != null)
      .map((r) {
        final t = r.data!['transactionUpdated'];
        return TxModel.fromJson({
          'id': t['id'], 'reference': t['reference'],
          'description': t['description'], 'amount': t['amount'],
          'transactionType': t['transaction_type'],
          'status': t['status'], 'insertedAt': t['inserted_at'],
        });
      });
});

final loanStatusSubscriptionProvider =
    StreamProvider.autoDispose.family<Map<String, dynamic>, String>((ref, loanId) {
  final token = ref.watch(authProvider).accessToken;
  final client = ref.read(graphQLClientProvider(token));
  return client
      .subscribe(SubscriptionOptions(
        document: gql(_loanStatusSub),
        variables: {'loanId': loanId},
      ))
      .where((r) => !r.hasException && r.data != null)
      .map((r) => r.data!['loanStatusChanged'] as Map<String, dynamic>);
});

final notificationSubscriptionProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final token = ref.watch(authProvider).accessToken;
  final client = ref.read(graphQLClientProvider(token));
  return client
      .subscribe(SubscriptionOptions(document: gql(_newNotificationSub)))
      .where((r) => !r.hasException && r.data != null)
      .map((r) => r.data!['newNotification'] as Map<String, dynamic>);
});
