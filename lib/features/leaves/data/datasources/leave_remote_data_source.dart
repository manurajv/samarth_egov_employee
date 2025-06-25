import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/apply_leave.dart';
import '../models/leave_balance.dart';
import '../models/leave_history.dart';
import '../models/leave_status.dart';

abstract class LeaveRemoteDataSource {
  Future<void> applyLeave(LeaveParams params, String organizationSlug);
  Future<List<LeaveBalance>> getLeaveBalances(String email, String organizationSlug);
  Future<List<LeaveHistory>> getLeaveHistory(String email, String organizationSlug);
  Future<List<LeaveStatus>> getLeaveStatuses(String email, String organizationSlug);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://user1749627892472.requestly.tech';

  LeaveRemoteDataSourceImpl({required this.dio, required this.storage});

  @override
  Future<void> applyLeave(LeaveParams params, String organizationSlug) async {
    try {
      final response = await dio.post(
        '$baseUrl/$organizationSlug/employee/leave-statuses',
        data: {
          'leaveType': params.leaveType,
          'fromDate': params.fromDate.toIso8601String(),
          'toDate': params.toDate.toIso8601String(),
          'reason': params.reason,
          'status': 'Pending',
          'email': params.email,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );

      if (response.statusCode != 201) {
        throw ServerException(
          message: 'Failed to apply leave: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode.toString() ?? 'unknown',
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: 'unknown',
      );
    }
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalances(String email, String organizationSlug) async {
    try {
      final response = await dio.get(
        '$baseUrl/$organizationSlug/employee/leaves',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode.toString(),
          );
        }

        if (response.data is! Map<String, dynamic> || !response.data.containsKey('leaveBalances')) {
          throw ServerException(
            message: 'Invalid response format: Expected a map with "leaveBalances" key',
            statusCode: response.statusCode.toString(),
          );
        }

        final List<dynamic> data = response.data['leaveBalances'];
        return data.map((json) => LeaveBalance.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave balances: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.statusCode == 404
            ? 'Leave balances endpoint not found. Check Requestly mock configuration.'
            : e.message ?? 'Network error',
        statusCode: e.response?.statusCode.toString() ?? 'unknown',
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: 'unknown',
      );
    }
  }

  @override
  Future<List<LeaveHistory>> getLeaveHistory(String email, String organizationSlug) async {
    try {
      final response = await dio.get(
        '$baseUrl/$organizationSlug/employee/leave-history',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode.toString(),
          );
        }

        if (response.data is! Map<String, dynamic> || !response.data.containsKey('leaveHistory')) {
          throw ServerException(
            message: 'Invalid response format: Expected a map with "leaveHistory" key',
            statusCode: response.statusCode.toString(),
          );
        }

        final List<dynamic> data = response.data['leaveHistory'];
        return data.map((json) => LeaveHistory.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave history: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.statusCode == 404
            ? 'Leave history endpoint not found. Check Requestly mock configuration.'
            : e.message ?? 'Network error',
        statusCode: e.response?.statusCode.toString() ?? 'unknown',
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: 'unknown',
      );
    }
  }

  @override
  Future<List<LeaveStatus>> getLeaveStatuses(String email, String organizationSlug) async {
    try {
      final response = await dio.get(
        '$baseUrl/$organizationSlug/employee/leave-statuses',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await _getAuthHeader(),
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode.toString(),
          );
        }

        if (response.data is! Map<String, dynamic> || !response.data.containsKey('leaveStatuses')) {
          throw ServerException(
            message: 'Invalid response format: Expected a map with "leaveStatuses" key',
            statusCode: response.statusCode.toString(),
          );
        }

        final List<dynamic> data = response.data['leaveStatuses'];
        return data.map((json) => LeaveStatus.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave statuses: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.statusCode == 404
            ? 'Leave statuses endpoint not found. Check Requestly mock configuration.'
            : e.message ?? 'Network error',
        statusCode: e.response?.statusCode.toString() ?? 'unknown',
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: 'unknown',
      );
    }
  }

  Future<String> _getAuthHeader() async {
    final authToken = await storage.read(key: 'auth_token');
    return authToken != null ? 'Bearer $authToken' : '';
  }
}