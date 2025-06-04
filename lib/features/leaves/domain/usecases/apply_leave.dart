import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/leave_repository.dart';

class ApplyLeave {
  final LeaveRepository repository;

  ApplyLeave(this.repository);

  Future<Either<Failure, void>> call(LeaveParams params) async {
    return await repository.applyLeave(params);
  }
}

class LeaveParams extends Equatable {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;

  const LeaveParams({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });

  @override
  List<Object> get props => [leaveType, fromDate, toDate, reason];
}