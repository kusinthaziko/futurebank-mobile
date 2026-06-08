import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/domain/auth_state.dart';
import 'package:app/core/providers/auth_provider.dart';

void main() {
  // Initialize bindings and mock flutter_secure_storage platform channel
  TestWidgetsFlutterBinding.ensureInitialized();

  const _channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (MethodCall methodCall) async {
      // Return null for read (no stored token), void for write/delete
      switch (methodCall.method) {
        case 'read':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group('AuthNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is Loading, then resolves to Unauthenticated', () async {
      final auth = container.read(authProvider);
      expect(auth, isA<Loading>());

      // Wait for async init to complete
      await Future<void>.delayed(Duration.zero);

      // After reading secure storage (returns null), should be Unauthenticated
      final updated = container.read(authProvider);
      expect(updated, isA<Unauthenticated>());
    });

    test('login transitions to Authenticated', () async {
      final notifier = container.read(authProvider.notifier);

      await notifier.login(
        'access-token-123',
        'refresh-token-456',
        'user-789',
        institutionId: 'inst-001',
        role: 'student',
      );

      final state = container.read(authProvider);
      expect(state, isA<Authenticated>());

      final auth = state as Authenticated;
      expect(auth.accessToken, 'access-token-123');
      expect(auth.userId, 'user-789');
      expect(auth.institutionId, 'inst-001');
      expect(auth.role, 'student');
    });

    test('login without optional fields works', () async {
      final notifier = container.read(authProvider.notifier);

      await notifier.login('tok', 'ref', 'uid');

      final state = container.read(authProvider) as Authenticated;
      expect(state.accessToken, 'tok');
      expect(state.userId, 'uid');
      expect(state.institutionId, isNull);
      expect(state.role, isNull);
    });

    test('logout transitions to Unauthenticated', () async {
      final notifier = container.read(authProvider.notifier);

      await notifier.login('tok', 'ref', 'uid');
      expect(container.read(authProvider), isA<Authenticated>());

      await notifier.logout();

      final state = container.read(authProvider);
      expect(state, isA<Unauthenticated>());
    });

    test('multiple sequential logins update state correctly', () async {
      final notifier = container.read(authProvider.notifier);

      await notifier.login('tok1', 'ref1', 'uid1');
      expect((container.read(authProvider) as Authenticated).accessToken, 'tok1');

      await notifier.login('tok2', 'ref2', 'uid2');
      expect((container.read(authProvider) as Authenticated).accessToken, 'tok2');
    });
  });
}
