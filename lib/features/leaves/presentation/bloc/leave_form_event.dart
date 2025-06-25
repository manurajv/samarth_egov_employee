import 'package:equatable/equatable.dart';

abstract class LeaveFormEvent extends Equatable {
  const LeaveFormEvent();

  @override
  List<Object?> get props => [];
}

class LeaveFormLeaveTypeChanged extends LeaveFormEvent {
  final String leaveType;

  const LeaveFormLeaveTypeChanged(this.leaveType);

  @override
  List<Object?> get props => [leaveType];
}

class LeaveFormFromDateChanged extends LeaveFormEvent {
  final DateTime fromDate;

  const LeaveFormFromDateChanged(this.fromDate);

  @override
  List<Object?> get props => [fromDate];
}

class LeaveFormToDateChanged extends LeaveFormEvent {
  final DateTime toDate;

  const LeaveFormToDateChanged(this.toDate);

  @override
  List<Object?> get props => [toDate];
}

class LeaveFormReasonChanged extends LeaveFormEvent {
  final String reason;

  const LeaveFormReasonChanged(this.reason);

  @override
  List<Object?> get props => [reason];
}

class LeaveFormSubmitted extends LeaveFormEvent {
  final String email;
  final String organizationSlug;

  const LeaveFormSubmitted({
    required this.email,
    required this.organizationSlug,
  });

  @override
  List<Object?> get props => [email, organizationSlug];
}

class LeaveFormReset extends LeaveFormEvent {
  const LeaveFormReset();
}