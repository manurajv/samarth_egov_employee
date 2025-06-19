import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;

  ProfileBloc({required this.getProfile}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      print('ProfileBloc: Emitting ProfileLoading');
      final result = await getProfile();
      result.fold(
            (failure) {
          print('ProfileBloc: LoadProfile failed: $failure');
          String message;
          if (failure is AuthenticationFailure) {
            message = 'Unauthorized';
          } else if (failure is ServerFailure) {
            message = 'Server error occurred';
          } else if (failure is CacheFailure) {
            message = 'Missing organization or email';
          } else if (failure is NetworkFailure) {
            message = 'No internet connection';
          } else {
            message = 'Unexpected error occurred';
          }
          emit(ProfileError(message: message));
        },
            (profile) {
          print('ProfileBloc: Profile fetched: ${profile.fullName}');
          emit(ProfileLoaded(profile: profile));
        },
      );
    });
  }
}