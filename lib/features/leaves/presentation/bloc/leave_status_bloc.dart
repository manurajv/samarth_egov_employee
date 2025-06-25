import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/leave_status.dart';
import '../../domain/usecases/get_leave_status.dart';

abstract class LeaveStatusEvent extends Equatable {
  const LeaveStatusEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaveStatuses extends LeaveStatusEvent {
  final String email;
  final String organizationSlug;

  const FetchLeaveStatuses({required this.email, required this.organizationSlug});

  @override
  List<Object> get props => [email, organizationSlug];
}

abstract class LeaveStatusState extends Equatable {
  const LeaveStatusState();

  @override
  List<Object?> get props => [];
}

class LeaveStatusLoading extends LeaveStatusState {
  const LeaveStatusLoading();
}

class LeaveStatusLoaded extends LeaveStatusState {
  final List<LeaveStatus> leaveStatuses;

  const LeaveStatusLoaded(this.leaveStatuses);

  @override
  List<Object?> get props => [leaveStatuses];
}

class LeaveStatusError extends LeaveStatusState {
  final String error;

  const LeaveStatusError(this.error);

  @override
  List<Object?> get props => [error];
}

class LeaveStatusBloc extends Bloc<LeaveStatusEvent, LeaveStatusState> {
  final GetLeaveStatus getLeaveStatus;

  LeaveStatusBloc(this.getLeaveStatus) : super(const LeaveStatusLoading()) {
    on<FetchLeaveStatuses>(_onFetchStatuses);
  }

  Future<void> _onFetchStatuses(FetchLeaveStatuses event, Emitter<LeaveStatusState> emit) async {
    emit(const LeaveStatusLoading());
    try {
      final result = await getLeaveStatus(event.email, event.organizationSlug);
      result.fold(
            (failure) => emit(LeaveStatusError('Failed to fetch leave statuses: ${failure.message}')),
            (statuses) => emit(LeaveStatusLoaded(statuses)),
      );
    } catch (e) {
      emit(LeaveStatusError(e.toString()));
    }
  }
}