import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/apply_leave.dart';

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
  const LeaveFormSubmitted();
}

abstract class LeaveFormState extends Equatable {
  const LeaveFormState();

  String? get leaveType;
  DateTime? get fromDate;
  DateTime? get toDate;
  String get reason;
  Map<String, String> get errors => {};

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, errors];
}

class LeaveFormInitial extends LeaveFormState {
  @override
  final String? leaveType;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final String reason;

  const LeaveFormInitial({
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.reason = '',
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason];
}

class LeaveFormLoading extends LeaveFormState {
  @override
  String? get leaveType => null;
  @override
  DateTime? get fromDate => null;
  @override
  DateTime? get toDate => null;
  @override
  String get reason => '';
}

class LeaveFormSuccess extends LeaveFormState {
  @override
  String? get leaveType => null;
  @override
  DateTime? get fromDate => null;
  @override
  DateTime? get toDate => null;
  @override
  String get reason => '';
}

class LeaveFormFailure extends LeaveFormState {
  final String error;

  const LeaveFormFailure(this.error);

  @override
  String? get leaveType => null;
  @override
  DateTime? get fromDate => null;
  @override
  DateTime? get toDate => null;
  @override
  String get reason => '';
  @override
  List<Object?> get props => [error];
}

class LeaveFormInvalid extends LeaveFormState {
  @override
  final String? leaveType;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final String reason;
  @override
  final Map<String, String> errors;

  const LeaveFormInvalid({
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.reason = '',
    required this.errors,
  });

  @override
  List<Object?> get props => [leaveType, fromDate, toDate, reason, errors];
}

class LeaveFormBloc extends Bloc<LeaveFormEvent, LeaveFormState> {
  final ApplyLeave applyLeave;

  LeaveFormBloc({required this.applyLeave}) : super(const LeaveFormInitial()) {
    on<LeaveFormLeaveTypeChanged>(_onLeaveTypeChanged);
    on<LeaveFormFromDateChanged>(_onFromDateChanged);
    on<LeaveFormToDateChanged>(_onToDateChanged);
    on<LeaveFormReasonChanged>(_onReasonChanged);
    on<LeaveFormSubmitted>(_onSubmitted);
  }

  void _onLeaveTypeChanged(LeaveFormLeaveTypeChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormInitial(
      leaveType: event.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: state.reason,
    ));
  }

  void _onFromDateChanged(LeaveFormFromDateChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormInitial(
      leaveType: state.leaveType,
      fromDate: event.fromDate,
      toDate: state.toDate,
      reason: state.reason,
    ));
  }

  void _onToDateChanged(LeaveFormToDateChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormInitial(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: event.toDate,
      reason: state.reason,
    ));
  }

  void _onReasonChanged(LeaveFormReasonChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormInitial(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: event.reason,
    ));
  }

  Future<void> _onSubmitted(LeaveFormSubmitted event, Emitter<LeaveFormState> emit) async {
    final errors = <String, String>{};

    if (state.leaveType == null || state.leaveType!.isEmpty) {
      errors['leaveType'] = 'Leave type is required';
    }
    if (state.fromDate == null) {
      errors['fromDate'] = 'From date is required';
    }
    if (state.toDate == null) {
      errors['toDate'] = 'To date is required';
    } else if (state.fromDate != null && state.toDate!.isBefore(state.fromDate!)) {
      errors['toDate'] = 'To date must be after from date';
    }
    if (state.reason.isEmpty) {
      errors['reason'] = 'Reason is required';
    }

    if (errors.isNotEmpty) {
      emit(LeaveFormInvalid(
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
        errors: errors,
      ));
      return;
    }

    emit(LeaveFormLoading());
    try {
      await applyLeave(LeaveParams(
        leaveType: state.leaveType!,
        fromDate: state.fromDate!,
        toDate: state.toDate!,
        reason: state.reason,
      ));
      emit(LeaveFormSuccess());
    } catch (e) {
      emit(LeaveFormFailure(e.toString()));
    }
  }
}