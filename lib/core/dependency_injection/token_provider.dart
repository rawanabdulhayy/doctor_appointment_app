class AuthTokenProvider {
  String? _token;

  void setToken(String token) => _token = token;
  String? get token => _token;
  void clearToken() => _token = null;
}