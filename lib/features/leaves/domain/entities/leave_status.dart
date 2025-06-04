import 'package:equatable/equatable.dart';

class LeaveStatus extends Equatable {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String status;

  const LeaveStatus({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, status];
}