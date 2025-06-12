class AuthResponse {
  final String message;
  final String token;

  const AuthResponse({
    required this.message,
    this.token = '',
  });
}