import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/di/injector.dart';
import '../../../../core/constants/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../data/models/dashboard_models.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiClient _apiClient = sl.get<ApiClient>();

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final orgSlug = sl.get<SharedPreferences>().getString('orgSlug') ?? 'delhi-university';
      final response = await _apiClient.get(ApiEndpoints.getEmployeeData(orgSlug));
      final data = response.data;

      final profile = data['profile'] as Map<String, dynamic>;
      final leaveBalances = (data['leaveBalances'] as List? ?? [])
          .map((e) => LeaveBalance.fromJson(e as Map<String, dynamic>))
          .toList();
      final serviceRecords = (data['serviceRecords'] as List? ?? [])
          .map((e) => ServiceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      final appraisals = (data['appraisals'] as List? ?? [])
          .map((e) => Appraisal.fromJson(e as Map<String, dynamic>))
          .toList();
      final grievances = (data['grievances'] as List? ?? [])
          .map((e) => Grievance.fromJson(e as Map<String, dynamic>))
          .toList();
      final salarySlips = (data['salarySlips'] as List? ?? [])
          .map((e) => SalarySlip.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(DashboardLoaded(
        employeeName: profile['fullName'] as String? ?? 'Unknown',
        profileCompletion: _calculateProfileCompletion(profile),
        leaveBalances: leaveBalances,
        serviceRecords: serviceRecords,
        appraisals: appraisals,
        grievances: grievances,
        salarySlips: salarySlips,
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard: $e'));
    }
  }

  double _calculateProfileCompletion(Map<String, dynamic> profile) {
    int totalFields = 0;
    int filledFields = 0;

    void checkFields(Map<String, dynamic> map) {
      for (final value in map.values) {
        totalFields++;
        if (value != null && value.toString().isNotEmpty) {
          filledFields++;
        } else if (value is Map<String, dynamic>) {
          checkFields(value);
        }
      }
    }

    checkFields(profile);
    return totalFields > 0 ? (filledFields / totalFields) * 100 : 100;
  }
}