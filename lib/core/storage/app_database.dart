import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class CachedAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  DateTimeColumn get cachedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get json => text()();
  DateTimeColumn get cachedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedLoans extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  DateTimeColumn get cachedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

// Drift names this table's data class CachedProfileData, accessor cachedProfile
class CachedProfile extends Table {
  TextColumn get userId => text()();
  TextColumn get json => text()();
  DateTimeColumn get cachedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {userId};
}

@DriftDatabase(
  tables: [CachedAccounts, CachedTransactions, CachedLoans, CachedProfile],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  Future<void> cacheAccount(String id, String json) =>
      into(cachedAccounts).insertOnConflictUpdate(
        CachedAccountsCompanion.insert(
          id: id,
          json: json,
          cachedAt: DateTime.now(),
        ),
      );

  Future<CachedAccount?> getCachedAccount(String id) =>
      (select(cachedAccounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> cacheTx(String id, String accountId, String json) =>
      into(cachedTransactions).insertOnConflictUpdate(
        CachedTransactionsCompanion.insert(
          id: id,
          accountId: accountId,
          json: json,
          cachedAt: DateTime.now(),
        ),
      );

  Future<List<CachedTransaction>> getCachedTxs(String accountId) => (select(
    cachedTransactions,
  )..where((t) => t.accountId.equals(accountId))).get();

  Future<void> cacheLoan(String id, String json) =>
      into(cachedLoans).insertOnConflictUpdate(
        CachedLoansCompanion.insert(
          id: id,
          json: json,
          cachedAt: DateTime.now(),
        ),
      );

  Future<List<CachedLoan>> getCachedLoans() => select(cachedLoans).get();

  Future<void> clearCachedTxs(String accountId) => (delete(
    cachedTransactions,
  )..where((t) => t.accountId.equals(accountId))).go();

  Future<void> clearCachedLoans() => delete(cachedLoans).go();

  // CachedProfile table → accessor: cachedProfile, data class: CachedProfileData
  Future<void> cacheProfile(String userId, String json) =>
      into(cachedProfile).insertOnConflictUpdate(
        CachedProfileCompanion.insert(
          userId: userId,
          json: json,
          cachedAt: DateTime.now(),
        ),
      );

  Future<CachedProfileData?> getCachedProfile(String userId) => (select(
    cachedProfile,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<void> clearAll() async {
    await delete(cachedAccounts).go();
    await delete(cachedTransactions).go();
    await delete(cachedLoans).go();
    await delete(cachedProfile).go();
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'futurebank.db'));
  return NativeDatabase.createInBackground(file);
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
