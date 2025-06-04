import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_history.dart';
import '../../domain/entities/leave_status.dart';
import '../../domain/usecases/apply_leave.dart';

abstract class LeaveRemoteDataSource {
  Future<void> applyLeave(LeaveParams params);
  Future<List<LeaveBalance>> getLeaveBalances();
  Future<List<LeaveHistory>> getLeaveHistory();
  Future<List<LeaveStatus>> getLeaveStatuses();
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio dio;

  LeaveRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> applyLeave(LeaveParams params) async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      // TODO: Implement real API call
    } catch (e) {
      throw ServerException(message: 'Apply leave server error');
    }
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalances() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      return [
        const LeaveBalance(leaveType: 'Casual Leave', availableDays: 8),
        const LeaveBalance(leaveType: 'Earned Leave', availableDays: 15),
        const LeaveBalance(leaveType: 'Maternity Leave', availableDays: 90),
        // ... other leave types
      ];
    } catch (e) {
      throw ServerException(message: 'Leave balnce server error');
    }
  }

  @override
  Future<List<LeaveHistory>> getLeaveHistory() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      return [
        LeaveHistory(
          leaveType: 'Casual Leave',
          fromDate: DateTime(2023, 10, 1),
          toDate: DateTime(2023, 10, 3),
          reason: 'Personal reason',
          status: 'Approved',
        ),
        LeaveHistory(
          leaveType: 'Earned Leave',
          fromDate: DateTime(2023, 9, 10),
          toDate: DateTime(2023, 9, 12),
          reason: 'Family event',
          status: 'Rejected',
        ),
      ];
    } catch (e) {
      throw ServerException(message: 'Leave History server error');
    }
  }

  @override
  Future<List<LeaveStatus>> getLeaveStatuses() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      return [
        LeaveStatus(
          leaveType: 'Casual Leave',
          fromDate: DateTime(2023, 11, 15),
          toDate: DateTime(2023, 11, 16),
          reason: 'Medical appointment',
          status: 'Pending',
        ),
      ];
    } catch (e) {
      throw ServerException(message: 'Leave Status server error');
    }
  }
}