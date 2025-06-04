import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/leave_balance.dart';
import '../entities/leave_history.dart';
import '../entities/leave_status.dart';
import '../usecases/apply_leave.dart';

abstract class LeaveRepository {
  Future<Either<Failure, void>> applyLeave(LeaveParams params);
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances();
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory();
  Future<Either<Failure, List<LeaveStatus>>> getLeaveStatuses();
}