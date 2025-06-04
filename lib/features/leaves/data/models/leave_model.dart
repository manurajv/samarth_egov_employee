import 'package:equatable/equatable.dart';

class LeaveModel extends Equatable {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;

  const LeaveModel({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'leaveType': leaveType,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'reason': reason,
    };
  }

  @override
  List<Object> get props => [leaveType, fromDate, toDate, reason];
}