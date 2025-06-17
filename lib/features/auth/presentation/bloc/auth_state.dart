part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class UniversitiesLoaded extends AuthState {
  final Map<String, String> universities;
  const UniversitiesLoaded(this.universities);
  @override
  List<Object?> get props => [universities];
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
  List<Object?> get props => [email, organizationSlug, message];
}

class AuthSuccess extends AuthState {
  final Map<String, dynamic> user;
  const AuthSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class UserExists extends AuthState {
  const UserExists();
}

class UserNotFound extends AuthState {
  const UserNotFound();
}