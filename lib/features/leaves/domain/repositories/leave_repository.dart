import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../usecases/apply_leave.dart';
import '../../data/models/leave_balance.dart';
import '../../data/models/leave_history.dart';
import '../../data/models/leave_status.dart';

abstract class LeaveRepository {
  Future<Either<Failure, void>> applyLeave(LeaveParams params, String organizationSlug);
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances(String email, String organizationSlug);
  Future<Either<Failure, List<LeaveHistory>>> getLeaveHistory(String email, String organizationSlug);
  Future<Either<Failure, List<LeaveStatus>>> getLeaveStatuses(String email, String organizationSlug);
}