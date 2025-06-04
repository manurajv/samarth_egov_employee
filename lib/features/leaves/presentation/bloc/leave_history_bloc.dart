import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/leave_history.dart';
import '../../domain/usecases/get_leave_history.dart';

abstract class LeaveHistoryEvent extends Equatable {
  const LeaveHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaveHistory extends LeaveHistoryEvent {
  const FetchLeaveHistory();
}

abstract class LeaveHistoryState extends Equatable {
  const LeaveHistoryState();

  @override
  List<Object?> get props => [];
}

class LeaveHistoryLoading extends LeaveHistoryState {
  const LeaveHistoryLoading();
}

class LeaveHistoryLoaded extends LeaveHistoryState {
  final List<LeaveHistory> leaveHistory;

  const LeaveHistoryLoaded(this.leaveHistory);

  @override
  List<Object?> get props => [leaveHistory];
}

class LeaveHistoryError extends LeaveHistoryState {
  final String error;

  const LeaveHistoryError(this.error);

  @override
  List<Object?> get props => [error];
}

class LeaveHistoryBloc extends Bloc<LeaveHistoryEvent, LeaveHistoryState> {
  final GetLeaveHistory getLeaveHistory;

  LeaveHistoryBloc(this.getLeaveHistory) : super(const LeaveHistoryLoading()) {
    on<FetchLeaveHistory>(_onFetchHistory);
  }

  Future<void> _onFetchHistory(FetchLeaveHistory event, Emitter<LeaveHistoryState> emit) async {
    emit(const LeaveHistoryLoading());
    try {
      final result = await getLeaveHistory();
      result.fold(
            (failure) => emit(const LeaveHistoryError('Failed to fetch leave history')),
            (history) => emit(LeaveHistoryLoaded(history)),
      );
    } catch (e) {
      emit(LeaveHistoryError(e.toString()));
    }
  }
}