import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/leave_balance.dart';
import '../../domain/usecases/get_leave_balance.dart';

abstract class LeaveBalanceEvent extends Equatable {
  const LeaveBalanceEvent();

  @override
  List<Object> get props => [];
}

class FetchLeaveBalances extends LeaveBalanceEvent {
  final String email;
  final String organizationSlug;

  const FetchLeaveBalances({required this.email, required this.organizationSlug});

  @override
  List<Object> get props => [email, organizationSlug];
}

abstract class LeaveBalanceState extends Equatable {
  const LeaveBalanceState();

  @override
  List<Object?> get props => [];
}

class LeaveBalanceInitial extends LeaveBalanceState {
  const LeaveBalanceInitial();
}

class LeaveBalanceLoading extends LeaveBalanceState {
  const LeaveBalanceLoading();
}

class LeaveBalanceLoaded extends LeaveBalanceState {
  final List<LeaveBalance> leaveBalances;

  const LeaveBalanceLoaded(this.leaveBalances);

  @override
  List<Object?> get props => [leaveBalances];
}

class LeaveBalanceError extends LeaveBalanceState {
  final String error;

  const LeaveBalanceError(this.error);

  @override
  List<Object?> get props => [error];
}

class LeaveBalanceBloc extends Bloc<LeaveBalanceEvent, LeaveBalanceState> {
  final GetLeaveBalances getLeaveBalances;

  LeaveBalanceBloc(this.getLeaveBalances) : super(const LeaveBalanceInitial()) {
    on<FetchLeaveBalances>(_onFetchBalances);
  }

  Future<void> _onFetchBalances(FetchLeaveBalances event, Emitter<LeaveBalanceState> emit) async {
    emit(const LeaveBalanceLoading());
    try {
      final result = await getLeaveBalances(event.email, event.organizationSlug);
      result.fold(
            (failure) => emit(LeaveBalanceError('Failed to fetch leave balances: ${failure.message}')),
            (balances) => emit(LeaveBalanceLoaded(balances)),
      );
    } catch (e) {
      emit(LeaveBalanceError(e.toString()));
    }
  }
}