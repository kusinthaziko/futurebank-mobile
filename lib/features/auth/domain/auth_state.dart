sealed class AuthState {
  const AuthState();

  bool get isAuthenticated => this is Authenticated;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticated extends AuthState {
  final String accessToken;
  final String userId;
  final String? institutionId;
  final String? role;

  const Authenticated({
    required this.accessToken,
    required this.userId,
    this.institutionId,
    this.role,
  });
}

class Loading extends AuthState {
  const Loading();
}
