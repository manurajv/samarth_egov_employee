part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class GetUniversitiesRequested extends AuthEvent {
  const GetUniversitiesRequested();
}

class SendSignInLinkRequested extends AuthEvent {
  final String email;
  final String organizationSlug;
  const SendSignInLinkRequested({
    required this.email,
    required this.organizationSlug,
  });
  @override
  List<Object?> get props => [email, organizationSlug];
}

class VerifySignInLinkRequested extends AuthEvent {
  final String email;
  final String organizationSlug;
  final String? token;
  const VerifySignInLinkRequested({
    required this.email,
    required this.organizationSlug,
    this.token,
  });
  @override
  List<Object?> get props => [email, organizationSlug, token];
}

class CheckUserExists extends AuthEvent {
  final String email;
  final String organizationSlug;
  const CheckUserExists({
    required this.email,
    required this.organizationSlug,
  });
  @override
  List<Object?> get props => [email, organizationSlug];
}