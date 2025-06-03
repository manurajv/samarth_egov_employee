import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboard event,
      Emitter<DashboardState> emit,
      ) async {
    emit(DashboardLoading());
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      emit(DashboardLoaded(
        employeeName: 'John Doe', // Replace with actual employee name
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data'));
    }
  }
}