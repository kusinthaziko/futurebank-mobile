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

  const Authenticated({
    required this.accessToken,
    required this.userId,
    this.institutionId,
  });
}

class Loading extends AuthState {
  const Loading();
}
