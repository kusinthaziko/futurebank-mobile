import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthState {
  final String? accessToken;
  final String? userId;
  final String? institutionId;
  final bool isAuthenticated;

  const AuthState({
    this.accessToken,
    this.userId,
    this.institutionId,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? accessToken, String? userId,
    String? institutionId, bool? isAuthenticated,
  }) => AuthState(
    accessToken: accessToken ?? this.accessToken,
    userId: userId ?? this.userId,
    institutionId: institutionId ?? this.institutionId,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = const FlutterSecureStorage();

  AuthNotifier() : super(const AuthState()) { _init(); }

  Future<void> _init() async {
    final token = await _storage.read(key: 'access_token');
    final userId = await _storage.read(key: 'user_id');
    final institutionId = await _storage.read(key: 'institution_id');
    if (token != null && userId != null) {
      state = AuthState(
        accessToken: token, userId: userId,
        institutionId: institutionId, isAuthenticated: true,
      );
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
    state = AuthState(
      accessToken: accessToken, userId: userId,
      institutionId: institutionId, isAuthenticated: true,
    );
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);
