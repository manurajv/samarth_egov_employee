import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/dashboard_models.dart';
import '../../domain/repositories/dashboard_repository.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

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
  final List<LeaveBalance> leaveBalances;
  final List<ServiceRecord> serviceRecords;
  final List<Appraisal> appraisals;
  final List<Grievance> grievances;
  final List<SalarySlip> salarySlips;

  const DashboardLoaded({
    required this.employeeName,
    required this.leaveBalances,
    required this.serviceRecords,
    required this.appraisals,
    required this.grievances,
    required this.salarySlips,
  });

  @override
  List<Object> get props => [
    employeeName,
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

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository}) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    try {
      // Fetch data from all endpoints concurrently
      final results = await Future.wait([
        dashboardRepository.getProfile().catchError((e) => <String, dynamic>{'fullName': 'Manuraj Vimukthi'}),
        dashboardRepository.getLeaveBalances().catchError((e) => <LeaveBalance>[]),
        dashboardRepository.getServiceRecords().catchError((e) => <ServiceRecord>[]),
        dashboardRepository.getAppraisals().catchError((e) => <Appraisal>[]),
        dashboardRepository.getGrievances().catchError((e) => <Grievance>[]),
        dashboardRepository.getSalarySlips().catchError((e) => <SalarySlip>[]),
      ]);

      // Handle profile response
      final profileData = results[0];
      final String employeeName;
      if (profileData is List<dynamic> && profileData.isNotEmpty) {
        employeeName = (profileData[0] as Map<String, dynamic>)['fullName'] as String? ?? 'Manuraj Vimukthi';
      } else if (profileData is Map<String, dynamic>) {
        employeeName = profileData['fullName'] as String? ?? 'Manuraj Vimukthi';
      } else {
        employeeName = 'Manuraj Vimukthi';
      }

      final leaveBalances = results[1] as List<LeaveBalance>;
      final serviceRecords = results[2] as List<ServiceRecord>;
      final appraisals = results[3] as List<Appraisal>;
      final grievances = results[4] as List<Grievance>;
      final salarySlips = results[5] as List<SalarySlip>;

      emit(DashboardLoaded(
        employeeName: employeeName,
        leaveBalances: leaveBalances,
        serviceRecords: serviceRecords,
        appraisals: appraisals,
        grievances: grievances,
        salarySlips: salarySlips,
      ));
      print('DashboardLoaded: employeeName=$employeeName, '
          'leaveBalances=$leaveBalances, '
          'serviceRecords=$serviceRecords, '
          'appraisals=$appraisals, '
          'grievances=$grievances, '
          'salarySlips=$salarySlips');
    } catch (e) {
      emit(DashboardError(message: e.toString()));
      print('DashboardError: $e');
    }
  }
}