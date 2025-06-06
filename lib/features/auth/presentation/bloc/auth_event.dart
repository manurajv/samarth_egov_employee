part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GetUniversitiesRequested extends AuthEvent {}

class SendOTPRequested extends AuthEvent {
  final String email;
  final String organizationSlug;

  const SendOTPRequested({required this.email, required this.organizationSlug});

  @override
  List<Object> get props => [email, organizationSlug];
}

class VerifyOTPRequested extends AuthEvent {
  final String verificationId;
  final String otp;
  final String email;
  final String organizationSlug;

  const VerifyOTPRequested({
    required this.verificationId,
    required this.otp,
    required this.email,
    required this.organizationSlug,
  });

  @override
  List<Object> get props => [verificationId, otp, email, organizationSlug];
}

class ResendOTPRequested extends AuthEvent {
  final String email;
  final String organizationSlug;

  const ResendOTPRequested({required this.email, required this.organizationSlug});

  @override
  List<Object> get props => [email, organizationSlug];
}