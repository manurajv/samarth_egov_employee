part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String employeeId;
  final String password;

  const LoginRequested(this.employeeId, this.password);

  @override
  List<Object> get props => [employeeId, password];
}

class ForgotPasswordRequested extends AuthEvent {
  final String emailOrId;

  const ForgotPasswordRequested(this.emailOrId);

  @override
  List<Object> get props => [emailOrId];
}

class VerifyOTPRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  const VerifyOTPRequested({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object> get props => [verificationId, otp];
}

class ResendOTPRequested extends AuthEvent {
  final String phoneNumber;

  const ResendOTPRequested(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}