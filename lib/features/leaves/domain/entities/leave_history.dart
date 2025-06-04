import 'package:equatable/equatable.dart';

class LeaveHistory extends Equatable {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String status;

  const LeaveHistory({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, status];
}