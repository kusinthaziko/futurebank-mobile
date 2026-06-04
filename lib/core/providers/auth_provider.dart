import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/domain/auth_state.dart';

const _storage = FlutterSecureStorage();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const Loading()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _storage.read(key: 'access_token');
    final userId = await _storage.read(key: 'user_id');
    final institutionId = await _storage.read(key: 'institution_id');
    if (token != null && userId != null) {
      state = Authenticated(
        accessToken: token,
        userId: userId,
        institutionId: institutionId,
      );
    } else {
      state = const Unauthenticated();
    }
  }

  Future<void> login(
    String accessToken, String refreshToken, String userId, {
    String? institutionId,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'user_id', value: userId);
    if (institutionId != null) {
      await _storage.write(key: 'institution_id', value: institutionId);
    }
    state = Authenticated(
      accessToken: accessToken,
      userId: userId,
      institutionId: institutionId,
    );
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const Unauthenticated();
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
