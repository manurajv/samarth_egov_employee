import 'package:dio/dio.dart';
import '../../data/models/dashboard_models.dart';

class DashboardRepository {
  final Dio dio;

  DashboardRepository({required this.dio});

  Future<dynamic> getProfile() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/profile');
      print('Profile Response: ${response.data}');
      return response.data;
    } catch (e) {
      print('Profile Error: $e');
      rethrow;
    }
  }

  Future<List<LeaveBalance>> getLeaveBalances() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/leaves');
      print('Leave Balances Response: ${response.data}');
      // Handle both list and wrapped list (e.g., {"leaveBalances": [...]})
      final data = response.data is Map<String, dynamic> ? response.data['leaveBalances'] : response.data;
      return (data as List).map((json) => LeaveBalance.fromJson(json)).toList();
    } catch (e) {
      print('Leave Balances Error: $e');
      rethrow;
    }
  }

  Future<List<ServiceRecord>> getServiceRecords() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/service-book');
      print('Service Records Response: ${response.data}');
      return (response.data as List).map((json) => ServiceRecord.fromJson(json)).toList();
    } catch (e) {
      print('Service Records Error: $e');
      rethrow;
    }
  }

  Future<List<Appraisal>> getAppraisals() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/appraisals');
      print('Appraisals Response: ${response.data}');
      return (response.data as List).map((json) => Appraisal.fromJson(json)).toList();
    } catch (e) {
      print('Appraisals Error: $e');
      rethrow;
    }
  }

  Future<List<Grievance>> getGrievances() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/grievances');
      print('Grievances Response: ${response.data}');
      return (response.data as List).map((json) => Grievance.fromJson(json)).toList();
    } catch (e) {
      print('Grievances Error: $e');
      rethrow;
    }
  }

  Future<List<SalarySlip>> getSalarySlips() async {
    try {
      final response = await dio.get('https://user1749627892472.requestly.tech/delhi-university/employee/salary-slips');
      print('Salary Slips Response: ${response.data}');
      return (response.data as List).map((json) => SalarySlip.fromJson(json)).toList();
    } catch (e) {
      print('Salary Slips Error: $e');
      rethrow;
    }
  }
}