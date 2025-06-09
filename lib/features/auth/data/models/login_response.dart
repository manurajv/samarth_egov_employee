import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String token;
  final String message;

  const AuthResponse({
    required this.token,
    required this.message,
  });

  @override
  List<Object> get props => [token, message];
}