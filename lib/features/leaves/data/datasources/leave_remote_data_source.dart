import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/apply_leave.dart';
import '../models/leave_balance.dart';
import '../models/leave_history.dart';
import '../models/leave_status.dart';

abstract class LeaveRemoteDataSource {
  Future<void> applyLeave(LeaveParams params);
  Future<List<LeaveBalance>> getLeaveBalances();
  Future<List<LeaveHistory>> getLeaveHistory();
  Future<List<LeaveStatus>> getLeaveStatuses();
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'http://10.0.2.2:3000'; // Configurable base URL

  LeaveRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> applyLeave(LeaveParams params) async {
    try {
      final response = await dio.post(
        '$baseUrl/leaveStatuses',
        data: {
          'leaveType': params.leaveType,
          'fromDate': params.fromDate.toIso8601String(),
          'toDate': params.toDate.toIso8601String(),
          'reason': params.reason,
          'status': 'Pending', // Default status
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 201) {
        throw ServerException(
          message: 'Failed to apply leave: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalances() async {
    try {
      final response = await dio.get(
        '$baseUrl/leaveBalances',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode,
          );
        }

        final List<dynamic> data = response.data;
        return data.map((json) => LeaveBalance.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave balances: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }

  @override
  Future<List<LeaveHistory>> getLeaveHistory() async {
    try {
      final response = await dio.get(
        '$baseUrl/leaveHistory',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode,
          );
        }

        final List<dynamic> data = response.data;
        return data.map((json) => LeaveHistory.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave history: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }

  @override
  Future<List<LeaveStatus>> getLeaveStatuses() async {
    try {
      final response = await dio.get(
        '$baseUrl/leaveStatuses',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode,
          );
        }

        final List<dynamic> data = response.data;
        return data.map((json) => LeaveStatus.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load leave statuses: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }
}