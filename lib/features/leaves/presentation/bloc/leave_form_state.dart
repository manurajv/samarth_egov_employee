import 'package:equatable/equatable.dart';

abstract class LeaveFormState extends Equatable {
  final String? leaveType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reason;
  final Map<String, String> errors;

  const LeaveFormState({
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.reason = '',
    this.errors = const {},
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, errors];
}

class LeaveFormInitial extends LeaveFormState {
  const LeaveFormInitial({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.errors = const {},
  });
}

class LeaveFormLoading extends LeaveFormState {
  const LeaveFormLoading({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.errors = const {},
  });
}

class LeaveFormSuccess extends LeaveFormState {
  const LeaveFormSuccess({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    super.errors = const {},
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
    super.errors = const {},
  });

  @override
  List<Object?> get props => [error, leaveType, fromDate, toDate, reason, errors];
}

class LeaveFormInvalid extends LeaveFormState {
  const LeaveFormInvalid({
    super.leaveType,
    super.fromDate,
    super.toDate,
    super.reason = '',
    required super.errors,
  });
}