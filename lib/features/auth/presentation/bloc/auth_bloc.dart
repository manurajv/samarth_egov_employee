import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/forgot_pwd_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final ForgotPwdUsecase forgotPwdUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.forgotPwdUsecase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await loginUsecase.execute(
      event.employeeId,
      event.password,
    );
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (token) => emit(AuthSuccess(token)),
    );
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await forgotPwdUsecase.execute(event.emailOrId);
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(PasswordResetSent()),
    );
  }
}