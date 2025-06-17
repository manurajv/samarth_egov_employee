part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final String employeeName;
  final double profileCompletion;
  final List<LeaveBalance> leaveBalances;
  final List<ServiceRecord> serviceRecords;
  final List<Appraisal> appraisals;
  final List<Grievance> grievances;
  final List<SalarySlip> salarySlips;

  const DashboardLoaded({
    required this.employeeName,
    required this.profileCompletion,
    required this.leaveBalances,
    required this.serviceRecords,
    required this.appraisals,
    required this.grievances,
    required this.salarySlips,
  });

  @override
  List<Object> get props => [
    employeeName,
    profileCompletion,
    leaveBalances,
    serviceRecords,
    appraisals,
    grievances,
    salarySlips,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}