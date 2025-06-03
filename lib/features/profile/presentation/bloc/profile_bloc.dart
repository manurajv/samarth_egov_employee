import 'package:flutter_bloc/flutter_bloc.dart';
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
      final result = await getProfile();
      result.fold(
            (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
            (profile) => emit(ProfileLoaded(profile: profile)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }
}