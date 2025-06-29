import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/leave_repository.dart';

class ApplyLeave {
  final LeaveRepository repository;

  ApplyLeave(this.repository);

  Future<Either<Failure, void>> call(LeaveParams params, String organizationSlug) async {
    return await repository.applyLeave(params, organizationSlug);
  }
}

class LeaveParams extends Equatable {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String email;

  const LeaveParams({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'leaveType': leaveType,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'reason': reason,
      'email': email,
    };
  }

  @override
  List<Object> get props => [leaveType, fromDate, toDate, reason, email];
}