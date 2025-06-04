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

  factory LeaveStatus.fromJson(Map<String, dynamic> json) {
    return LeaveStatus(
      leaveType: json['leaveType'] as String,
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: DateTime.parse(json['toDate'] as String),
      reason: json['reason'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveType': leaveType,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'reason': reason,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, status];
}