import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/otp_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final OTPUsecase otpUsecase;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc({
    required this.otpUsecase,
  }) : super(AuthInitial()) {
    on<GetUniversitiesRequested>(_onGetUniversitiesRequested);
    on<SendOTPRequested>(_onSendOTPRequested);
    on<VerifyOTPRequested>(_onVerifyOTPRequested);
    on<ResendOTPRequested>(_onResendOTPRequested);
  }

  Future<void> _onGetUniversitiesRequested(
      GetUniversitiesRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await otpUsecase.getUniversities();
    result.fold(
          (failure) {
        print('GetUniversitiesRequested failed: ${failure.message}');
        emit(AuthError('Failed to load universities. Please check your connection.'));
      },
          (universities) {
        print('GetUniversitiesRequested succeeded: $universities');
        emit(UniversitiesLoaded(universities as Map<String, String>));
      },
    );
  }

  Future<void> _onSendOTPRequested(
      SendOTPRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await otpUsecase.sendOTP(event.email, event.organizationSlug);
    result.fold(
          (failure) {
        print('SendOTPRequested failed: ${failure.message}');
        emit(AuthError('Failed to send OTP. Please check the email and organization.'));
      },
          (verificationId) => emit(OTPSent(verificationId)),
    );
  }

  Future<void> _onVerifyOTPRequested(
      VerifyOTPRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await otpUsecase.verifyOTP(
      event.verificationId,
      event.otp,
      event.email,
      event.organizationSlug,
    );
    result.fold(
          (failure) {
        print('VerifyOTPRequested failed: ${failure.message}');
        emit(AuthError('Failed to verify OTP. Please try again.'));
      },
          (token) async {
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'email', value: event.email);
        await _storage.write(key: 'organizationSlug', value: event.organizationSlug);
        emit(AuthSuccess(token));
      },
    );
  }

  Future<void> _onResendOTPRequested(
      ResendOTPRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await otpUsecase.sendOTP(event.email, event.organizationSlug);
    result.fold(
          (failure) {
        print('ResendOTPRequested failed: ${failure.message}');
        emit(AuthError('Failed to resend OTP. Please try again.'));
      },
          (verificationId) => emit(OTPResent(verificationId)),
    );
  }
}