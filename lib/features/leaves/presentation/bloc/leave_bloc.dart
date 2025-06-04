import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveBalance extends LeaveEvent {}

class FetchLeaveHistory extends LeaveEvent {}

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveSuccess extends LeaveState {
  final List<dynamic> data; // Placeholder for leave balance or history

  const LeaveSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class LeaveFailure extends LeaveState {
  final String error;

  const LeaveFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  LeaveBloc() : super(LeaveInitial()) {
    on<FetchLeaveBalance>(_onFetchLeaveBalance);
    on<FetchLeaveHistory>(_onFetchLeaveHistory);
  }

  Future<void> _onFetchLeaveBalance(FetchLeaveBalance event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    try {
      // Mock data for now
      await Future.delayed(const Duration(seconds: 2));
      final mockData = [
        {'type': 'Casual Leave', 'balance': 10},
        {'type': 'Sick Leave', 'balance': 15},
      ];
      emit(LeaveSuccess(mockData));
    } catch (e) {
      emit(LeaveFailure(e.toString()));
    }
  }

  Future<void> _onFetchLeaveHistory(FetchLeaveHistory event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    try {
      // Mock data for now
      await Future.delayed(const Duration(seconds: 2));
      final mockData = [
        {'id': '1', 'type': 'Casual Leave', 'status': 'Approved'},
        {'id': '2', 'type': 'Sick Leave', 'status': 'Pending'},
      ];
      emit(LeaveSuccess(mockData));
    } catch (e) {
      emit(LeaveFailure(e.toString()));
    }
  }
}