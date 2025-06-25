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
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
    on<SendSignInLinkRequested>(
      _onSendSignInLinkRequested,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
    );
    on<VerifySignInLinkRequested>(
      _onVerifySignInLinkRequested,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 300)).asyncExpand(mapper),
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
      //emit(const AuthError('Failed to load universities. Please check your connection.'));
    }
  }

  Future<void> _onSendSignInLinkRequested(
      SendSignInLinkRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      // First verify user exists in organization
      final users = await authUseCase.getUsers(event.organizationSlug, event.email);

      // Strict check - must find exactly one matching user
      if (users.length != 1 || users[0]['email'] != event.email) {
        throw Exception('User not found in this organization');
      }

      // If user exists, send the link
      final response = await authUseCase.sendSignInLink(
        event.email,
        event.organizationSlug,
      );

      emit(LinkSent(
        email: event.email,
        organizationSlug: event.organizationSlug,
        message: response.message,
      ));
    } catch (e) {
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
        name: user['name'] ?? 'Unknown',
        organizationSlug: event.organizationSlug,
      );

      emit(AuthSuccess(
        user: {
          'id': user['id'],
          'email': user['email'],
          'name': user['name'] ?? 'Unknown',
          'organizationSlug': event.organizationSlug,
        },
      ));
    } catch (e) {
      emit(AuthError('Failed to verify sign-in link: ${e.toString()}'));
    }
  }
}