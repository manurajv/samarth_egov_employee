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
  const VerifySignInLinkRequested({
    required this.email,
    required this.organizationSlug,
  });
  @override
  List<Object?> get props => [email, organizationSlug];
}