import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final String leaveType;
  final int availableDays;

  const LeaveBalance({
    required this.leaveType,
    required this.availableDays,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      leaveType: json['leaveType'] as String,
      availableDays: json['availableDays'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveType': leaveType,
      'availableDays': availableDays,
    };
  }

  @override
  List<Object?> get props => [leaveType, availableDays];
}