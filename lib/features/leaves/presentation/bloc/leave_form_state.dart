import 'package:equatable/equatable.dart';

abstract class LeaveFormState extends Equatable {
  final String? leaveType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reason;
  final String? email;
  final String? organizationSlug;

  const LeaveFormState({
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.reason = '',
    this.email,
    this.organizationSlug,
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, email, organizationSlug];
}

class LeaveFormInitial extends LeaveFormState {
  const LeaveFormInitial({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });
}

class LeaveFormUpdated extends LeaveFormState {
  const LeaveFormUpdated({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });
}

class LeaveFormLoading extends LeaveFormState {
  const LeaveFormLoading({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });
}

class LeaveFormSuccess extends LeaveFormState {
  const LeaveFormSuccess({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });
}

class LeaveFormFailure extends LeaveFormState {
  final String error;

  const LeaveFormFailure({
    required this.error,
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });

  @override
  List<Object?> get props => [error, leaveType, fromDate, toDate, reason, email, organizationSlug];
}

class LeaveFormInvalid extends LeaveFormState {
  final Map<String, String> errors;

  const LeaveFormInvalid({
    required this.errors,
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.email,
    super.organizationSlug,
  });

  @override
  List<Object?> get props => [errors, leaveType, fromDate, toDate, reason, email, organizationSlug];
}