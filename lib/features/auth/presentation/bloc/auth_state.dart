part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class UniversitiesLoaded extends AuthState {
  final Map<String, String> universities;

  const UniversitiesLoaded(this.universities);

  @override
  List<Object> get props => [universities];
}

class LinkSent extends AuthState {
  final String email;
  final String organizationSlug;
  final String message;

  const LinkSent({
    required this.email,
    required this.organizationSlug,
    required this.message,
  });

  @override
  List<Object> get props => [email, organizationSlug, message];
}

class AuthSuccess extends AuthState {
  final String token;

  const AuthSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}