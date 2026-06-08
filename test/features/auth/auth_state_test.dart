import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/domain/auth_state.dart';

void main() {
  group('AuthState', () {
    test('Unauthenticated is not authenticated', () {
      final state = const Unauthenticated();
      expect(state.isAuthenticated, false);
    });

    test('Authenticated is authenticated', () {
      final state = const Authenticated(
        accessToken: 'token123',
        userId: 'user456',
      );
      expect(state.isAuthenticated, true);
    });

    test('Loading is not authenticated', () {
      final state = const Loading();
      expect(state.isAuthenticated, false);
    });
  });

  group('Authenticated', () {
    test('stores access token and userId', () {
      final state = const Authenticated(
        accessToken: 'abc',
        userId: 'def',
        institutionId: 'inst1',
        role: 'student',
      );
      expect(state.accessToken, 'abc');
      expect(state.userId, 'def');
      expect(state.institutionId, 'inst1');
      expect(state.role, 'student');
    });

    test('omits optional fields when null', () {
      final state = const Authenticated(
        accessToken: 'tok',
        userId: 'uid',
      );
      expect(state.institutionId, isNull);
      expect(state.role, isNull);
    });

    test('pattern matching works with switch', () {
      const AuthState authenticated = Authenticated(
        accessToken: 'tok',
        userId: 'uid',
      );
      const AuthState unauthenticated = Unauthenticated();
      const AuthState loading = Loading();

      String describe(AuthState s) => switch (s) {
        Authenticated(:final accessToken) => 'auth:$accessToken',
        Unauthenticated() => 'no-auth',
        Loading() => 'loading',
      };

      expect(describe(authenticated), 'auth:tok');
      expect(describe(unauthenticated), 'no-auth');
      expect(describe(loading), 'loading');
    });
  });

  group('Loading', () {
    test('is const and default constructible', () {
      const a = Loading();
      const b = Loading();
      expect(a, equals(b));
    });
  });

  group('Unauthenticated', () {
    test('is const and default constructible', () {
      const a = Unauthenticated();
      const b = Unauthenticated();
      expect(a, equals(b));
    });
  });
}
