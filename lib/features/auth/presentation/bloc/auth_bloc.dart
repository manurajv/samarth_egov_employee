import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/auth_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc(this.authUseCase) : super(const AuthInitial()) {
    on<GetUniversitiesRequested>(
      _onGetUniversitiesRequested,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
    on<SendSignInLinkRequested>(
      _onSendSignInLinkRequested,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
    on<VerifySignInLinkRequested>(
      _onVerifySignInLinkRequested,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
  }

  Future<void> _onGetUniversitiesRequested(
      GetUniversitiesRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final universities = await authUseCase.getUniversities().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('API request timed out'),
      );
      print('AuthBloc: Universities loaded: $universities');
      emit(UniversitiesLoaded(universities));
    } catch (e) {
      print('GetUniversitiesRequested failed: $e');
      emit(const AuthError('Failed to load universities. Please check your connection.'));
    }
  }

  Future<void> _onSendSignInLinkRequested(
      SendSignInLinkRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final response = await authUseCase.sendSignInLink(
        event.email,
        event.organizationSlug,
      );
      print('AuthBloc: Sign-in link sent for ${event.email}');
      emit(LinkSent(
        email: event.email,
        organizationSlug: event.organizationSlug,
        message: response.message,
      ));
    } catch (e) {
      print('SendSignInLinkRequested failed: $e');
      emit(AuthError(e.toString()));
      emit(const AuthError('Failed to send sign-in link. Please try again.'));
    }
  }

  Future<void> _onVerifySignInLinkRequested(
      VerifySignInLinkRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final response = await authUseCase.verifySignInLink(
        event.email,
        event.organizationSlug,
      );
      print('AuthBloc: Sign-in link verified for ${event.email}');
      emit(AuthSuccess(token: response.token));
    } catch (e) {
      print('VerifySignInLinkRequested failed: $e');
      emit(const AuthError('Failed to verify sign-in link. Please try again.'));
    }
  }
}