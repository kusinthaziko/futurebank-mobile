import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_database.dart';

class CacheService {
  final AppDatabase _db;

  CacheService(this._db);

  static const _ttl = <String, Duration>{
    'accounts': Duration(seconds: 30),
    'loans': Duration(seconds: 30),
    'transactions': Duration(seconds: 60),
    'profile': Duration(minutes: 5),
    'dashboard': Duration(seconds: 30),
    'social': Duration(seconds: 30),
  };

  Duration ttl(String key) =>
      _ttl[key] ?? const Duration(seconds: 30);

  bool _isFresh(DateTime cachedAt, Duration ttl) {
    return DateTime.now().difference(cachedAt) <= ttl;
  }

  Future<T?> getFresh<T>({
    required String key,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<T> Function() fromNetwork,
    required Future<void> Function(T) saveToCache,
  }) async {
    final cached = await _getCachedRaw(key, id);
    final ttl = this.ttl(key);

    if (cached != null && _isFresh(cached.cachedAt, ttl)) {
      try {
        final json = jsonDecode(cached.json) as Map<String, dynamic>;
        return fromJson(json);
      } catch (_) {}
    }

    try {
      final data = await fromNetwork();
      await saveToCache(data);
      return data;
    } catch (_) {
      if (cached != null) {
        try {
          final json = jsonDecode(cached.json) as Map<String, dynamic>;
          return fromJson(json);
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<T?> getFreshValue<T>(
    String key,
    String id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cached = await _getCachedRaw(key, id);
    if (cached == null) return null;
    if (!_isFresh(cached.cachedAt, ttl(key))) return null;
    try {
      return fromJson(jsonDecode(cached.json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<T?> getStaleValue<T>(
    String key,
    String id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cached = await _getCachedRaw(key, id);
    if (cached == null) return null;
    try {
      return fromJson(jsonDecode(cached.json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheJson(String key, String id, String json) async {
    switch (key) {
      case 'accounts':
        await _db.cacheAccount(id, json);
      case 'transactions':
        final items = jsonDecode(json)['items'] as List;
        await _db.clearCachedTxs(id);
        for (final item in items) {
          await _db.cacheTx(item['id'], id, jsonEncode(item));
        }
      case 'loans':
        final items = jsonDecode(json)['items'] as List;
        await _db.clearCachedLoans();
        for (final item in items) {
          await _db.cacheLoan(item['id'], jsonEncode(item));
        }
      case 'profile':
        await _db.cacheProfile(id, json);
      default:
        await _db.cacheAccount('__${key}_$id', json);
    }
  }

  Future<({String json, DateTime cachedAt})?> _getCachedRaw(
      String key, String id) async {
    switch (key) {
      case 'accounts':
        final r = await _db.getCachedAccount(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
      case 'transactions':
        final rows = await _db.getCachedTxs(id);
        if (rows.isNotEmpty) {
          final items = rows.map((r) => jsonDecode(r.json)).toList();
          final latest =
              rows.map((r) => r.cachedAt).reduce((a, b) => a.isAfter(b) ? a : b);
          return (json: jsonEncode({'items': items}), cachedAt: latest);
        }
      case 'loans':
        final rows = await _db.getCachedLoans();
        if (rows.isNotEmpty) {
          final items = rows.map((r) => jsonDecode(r.json)).toList();
          final latest =
              rows.map((r) => r.cachedAt).reduce((a, b) => a.isAfter(b) ? a : b);
          return (json: jsonEncode({'items': items}), cachedAt: latest);
        }
      case 'profile':
        final r = await _db.getCachedProfile(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
      default:
        final r = await _db.getCachedAccount('__${key}_$id');
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
    }
    return null;
  }
}

final cacheServiceProvider = Provider<CacheService>(
  (ref) => CacheService(ref.watch(databaseProvider)),
);
