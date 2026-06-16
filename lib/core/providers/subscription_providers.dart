import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/client.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/accounts/data/models/account_models.dart';
import '../../features/loans/data/models/loan_models.dart';
import '../../features/social/data/models/social_models.dart';

String? _tokenFromAuth(AuthState auth) => switch (auth) {
  Authenticated(:final accessToken) => accessToken,
  _ => null,
};

const _balanceChangedSub = r'''
  subscription BalanceChanged($accountId: ID!) {
    balanceChanged(accountId: $accountId) { id balance currency }
  }
''';

const _transactionUpdatedSub = r'''
  subscription TxUpdated($accountId: ID!) {
    transactionUpdated(accountId: $accountId) {
      id reference description amount transactionType status insertedAt
    }
  }
''';

const _loanStatusSub = r'''
  subscription LoanStatus($loanId: ID!) {
    loanStatusChanged(loanId: $loanId) { id status decidedAt }
  }
''';

const _newNotificationSub = r'''
  subscription NewNotification {
    newNotification { id type title body read insertedAt }
  }
''';

const _challengeLeaderboardSub = r'''
  subscription LeaderboardUpdated($challengeId: ID!) {
    challengeLeaderboardUpdated(challengeId: $challengeId) {
      userId fullName score rank
    }
  }
''';

const _groupBalanceSub = r'''
  subscription GroupBalanceUpdated($groupId: ID!) {
    groupBalanceUpdated(groupId: $groupId) { id balance currency }
  }
''';

final balanceSubscriptionProvider = StreamProvider.autoDispose
    .family<AccountModel, String>((ref, accountId) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(
            SubscriptionOptions(
              document: gql(_balanceChangedSub),
              variables: {'accountId': accountId},
            ),
          )
          .where((r) => !r.hasException && r.data != null)
          .map(
            (r) => AccountModel.fromJson({
              'id': r.data!['balanceChanged']['id'],
              'accountNumber': '',
              'accountType': 'savings',
              'balance': r.data!['balanceChanged']['balance'],
              'currency': r.data!['balanceChanged']['currency'],
              'status': 'active',
              'interestRate': '0',
            }),
          );
    });

final transactionSubscriptionProvider = StreamProvider.autoDispose
    .family<TxModel, String>((ref, accountId) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(
            SubscriptionOptions(
              document: gql(_transactionUpdatedSub),
              variables: {'accountId': accountId},
            ),
          )
          .where((r) => !r.hasException && r.data != null)
          .map((r) {
            final t = r.data!['transactionUpdated'];
            return TxModel.fromJson({
              'id': t['id'],
              'reference': t['reference'],
              'description': t['description'],
              'amount': t['amount'],
              'transactionType': t['transactionType'],
              'status': t['status'],
              'insertedAt': t['insertedAt'],
            });
          });
    });

final loanStatusSubscriptionProvider = StreamProvider.autoDispose
    .family<LoanModel, String>((ref, loanId) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(
            SubscriptionOptions(
              document: gql(_loanStatusSub),
              variables: {'loanId': loanId},
            ),
          )
          .where((r) => !r.hasException && r.data != null)
          .map((r) {
            final d = r.data!['loanStatusChanged'];
            return LoanModel.fromJson({
              'id': d['id'],
              'status': d['status'],
              'decidedAt': d['decidedAt'],
              'amountRequested': '0',
              'purpose': '',
              'repaymentPeriodWeeks': 0,
              'interestRate': '0',
            });
          });
    });

final notificationSubscriptionProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(SubscriptionOptions(document: gql(_newNotificationSub)))
          .where((r) => !r.hasException && r.data != null)
          .map((r) => r.data!['newNotification'] as Map<String, dynamic>);
    });

final challengeLeaderboardSubscriptionProvider = StreamProvider.autoDispose
    .family<List<LeaderboardEntry>, String>((ref, challengeId) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(
            SubscriptionOptions(
              document: gql(_challengeLeaderboardSub),
              variables: {'challengeId': challengeId},
            ),
          )
          .where((r) => !r.hasException && r.data != null)
          .map((r) {
            final list = r.data!['challengeLeaderboardUpdated'] as List;
            return list.map((e) => LeaderboardEntry.fromJson(e)).toList();
          });
    });

final groupBalanceSubscriptionProvider = StreamProvider.autoDispose
    .family<AccountModel, String>((ref, groupId) {
      final token = _tokenFromAuth(ref.watch(authProvider));
      final client = ref.read(graphQLClientProvider(token));
      return client
          .subscribe(
            SubscriptionOptions(
              document: gql(_groupBalanceSub),
              variables: {'groupId': groupId},
            ),
          )
          .where((r) => !r.hasException && r.data != null)
          .map((r) {
            final d = r.data!['groupBalanceUpdated'];
            return AccountModel.fromJson({
              'id': d['id'],
              'accountNumber': '',
              'accountType': 'group',
              'balance': d['balance'],
              'currency': d['currency'],
              'status': 'active',
              'interestRate': '0',
            });
          });
    });