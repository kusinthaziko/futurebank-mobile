import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionManager {
  final Map<String, StreamSubscription<Object?>> _subscriptions = {};
  final Map<String, int> _retryCounts = {};
  static const int _maxRetries = 5;

  StreamSubscription<T> subscribe<T>({
    required String key,
    required Stream<T> Function() streamFactory,
    required void Function(T data) onData,
    void Function(Object error)? onError,
    void Function()? onDone,
  }) {
    _cancel(key);

    final sub = _createWithRetry(
      key: key,
      streamFactory: streamFactory,
      onData: onData,
      onError: onError,
      onDone: onDone,
    );

    _subscriptions[key] = sub;
    return sub;
  }

  StreamSubscription<T> _createWithRetry<T>({
    required String key,
    required Stream<T> Function() streamFactory,
    required void Function(T data) onData,
    void Function(Object error)? onError,
    void Function()? onDone,
  }) {
    StreamSubscription<T>? sub;
    sub = streamFactory().listen(
      (data) {
        _retryCounts[key] = 0;
        onData(data);
      },
      onError: (Object error) {
        onError?.call(error);
        _retryCounts[key] = (_retryCounts[key] ?? 0) + 1;
        if (_retryCounts[key]! <= _maxRetries) {
          Future.delayed(_backoff(_retryCounts[key]!), () {
            if (_subscriptions.containsKey(key)) {
              _subscriptions[key] = _createWithRetry<T>(
                key: key,
                streamFactory: streamFactory,
                onData: onData,
                onError: onError,
                onDone: onDone,
              );
            }
          });
        }
      },
      onDone: () {
        onDone?.call();
      },
      cancelOnError: false,
    );
    return sub;
  }

  Duration _backoff(int attempt) {
    return Duration(seconds: (attempt * 2).clamp(1, 30));
  }

  void cancel(String key) {
    _cancel(key);
  }

  void _cancel(String key) {
    _subscriptions.remove(key)?.cancel();
    _retryCounts.remove(key);
  }

  void cancelAll() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
    _retryCounts.clear();
  }

  bool get hasActiveSubscriptions => _subscriptions.isNotEmpty;

  void dispose() {
    cancelAll();
  }
}

final subscriptionManagerProvider = Provider<SubscriptionManager>((ref) {
  final manager = SubscriptionManager();
  ref.onDispose(manager.dispose);
  return manager;
});
