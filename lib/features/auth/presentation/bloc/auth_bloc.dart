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
        const Duration(seconds: 15),
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
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('API request timed out'),
      );
      print('AuthBloc: Sign-in link sent for ${event.email}');
      emit(LinkSent(
        email: event.email,
        organizationSlug: event.organizationSlug,
        message: response.message,
      ));
    } catch (e) {
      print('SendSignInLinkRequested failed: $e');
      emit(AuthError('Failed to send sign-in link: ${e.toString()}'));
    }
  }

  Future<void> _onVerifySignInLinkRequested(
      VerifySignInLinkRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final isValid = await authUseCase.verifySignInLink(
        event.email,
        event.organizationSlug,
        event.token.toString(),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Token verification timed out'),
      );

      if (!isValid) {
        throw Exception('Invalid or expired verification link');
      }

      final users = await authUseCase.getUsers(event.organizationSlug, event.email);
      if (users.isEmpty) {
        throw Exception('User not found');
      }

      final user = users.first;
      await authUseCase.storeUserSession(
        id: user['id'].toString(),
        email: user['email'],
        name: user['name'],
        organizationSlug: event.organizationSlug,
      );

      print('AuthBloc: Sign-in link verified for ${event.email}, user=${user['name']}');
      emit(AuthSuccess(
        user: {
          'id': user['id'],
          'email': user['email'],
          'name': user['name'],
          'organizationSlug': event.organizationSlug,
        },
      ));
    } catch (e) {
      print('VerifySignInLinkRequested failed: $e');
      emit(AuthError('Failed to verify sign-in link: ${e.toString()}'));
    }
  }
}