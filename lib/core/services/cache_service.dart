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

  Future<({String json, DateTime cachedAt})?> _getCachedRaw(
      String key, String id) async {
    switch (key) {
      case 'accounts':
        final r = await _db.getCachedAccount(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
      case 'transactions':
        final r = await _db.getCachedAccount(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
      case 'loans':
        final r = await _db.getCachedAccount(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
      case 'profile':
        final r = await _db.getCachedProfile(id);
        if (r != null) return (json: r.json, cachedAt: r.cachedAt);
    }
    return null;
  }
}

final cacheServiceProvider = Provider<CacheService>(
  (ref) => CacheService(ref.watch(databaseProvider)),
);
