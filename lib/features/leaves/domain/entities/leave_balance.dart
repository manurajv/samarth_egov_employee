import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final String leaveType;
  final int availableDays;

  const LeaveBalance({
    required this.leaveType,
    required this.availableDays,
  });

  @override
  List<Object> get props => [leaveType, availableDays];
}