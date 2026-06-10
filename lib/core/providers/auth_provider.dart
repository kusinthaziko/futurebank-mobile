import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../features/auth/domain/auth_state.dart';
import '../services/security_service.dart';
import '../graphql/client.dart';

const _storage = FlutterSecureStorage();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const Loading()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _storage.read(key: 'access_token');
    final userId = await _storage.read(key: 'user_id');
    final institutionId = await _storage.read(key: 'institution_id');
    final role = await _storage.read(key: 'role');
    if (token != null && userId != null) {
      state = Authenticated(
        accessToken: token,
        userId: userId,
        institutionId: institutionId,
        role: role,
      );
    } else {
      state = const Unauthenticated();
    }
  }

  Future<void> login(
    String accessToken,
    String refreshToken,
    String userId, {
    String? institutionId,
    String? role,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'user_id', value: userId);
    if (institutionId != null) {
      await _storage.write(key: 'institution_id', value: institutionId);
    }
    if (role != null) {
      await _storage.write(key: 'role', value: role);
    }
    state = Authenticated(
      accessToken: accessToken,
      userId: userId,
      institutionId: institutionId,
      role: role,
    );
  }

  Future<void> logout() async {
    SecurityService().resetScreenshotPrevention();
    await _storage.deleteAll();
    state = const Unauthenticated();
  }

  /// Reads the stored refresh token and exchanges it for new tokens via the backend.
  /// Call this periodically to keep the access token fresh.
  Future<void> refreshToken() async {
    final storedRefresh = await _storage.read(key: 'refresh_token');
    if (storedRefresh == null || storedRefresh.isEmpty) return;

    final client = buildGraphQLClient(null);
    final result = await client.mutate(MutationOptions(
      document: gql(r'''
        mutation RefreshToken($refreshToken: String!) {
          refresh_token(refresh_token: $refreshToken) {
            access_token
            refresh_token
          }
        }
      '''),
      variables: {'refreshToken': storedRefresh},
    ));
    if (result.hasException) return;
    final data = result.data?['refresh_token'];
    if (data == null) return;

    final newAccess = data['access_token'] as String;
    final newRefresh = data['refresh_token'] as String;

    await _storage.write(key: 'access_token', value: newAccess);
    await _storage.write(key: 'refresh_token', value: newRefresh);

    final current = state;
    if (current is Authenticated) {
      state = Authenticated(
        accessToken: newAccess,
        userId: current.userId,
        institutionId: current.institutionId,
        role: current.role,
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);

final accessTokenProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth is Authenticated) return auth.accessToken;
  return null;
});

final userIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth is Authenticated) return auth.userId;
  return null;
});

final institutionIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth is Authenticated) return auth.institutionId;
  return null;
});

final roleProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth is Authenticated) return auth.role;
  return null;
});
