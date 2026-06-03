class AuthStateModel {
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  const AuthStateModel({this.accessToken, this.refreshToken, this.user});
}
