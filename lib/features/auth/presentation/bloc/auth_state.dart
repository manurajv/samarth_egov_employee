part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;

  const AuthSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class OTPSent extends AuthState {
  final String verificationId;

  const OTPSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class OTPResent extends AuthState {
  final String verificationId;

  const OTPResent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class UniversitiesLoaded extends AuthState {
  final Map<String, String> universities; // Map<name, slug>

  const UniversitiesLoaded(this.universities);

  @override
  List<Object> get props => [universities];
}