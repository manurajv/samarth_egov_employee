import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/apply_leave.dart';
import 'leave_form_event.dart';
import 'leave_form_state.dart';

class LeaveFormBloc extends Bloc<LeaveFormEvent, LeaveFormState> {
  final ApplyLeave applyLeave;

  LeaveFormBloc({required this.applyLeave}) : super(const LeaveFormInitial()) {
    on<LeaveFormLeaveTypeChanged>(_onLeaveTypeChanged);
    on<LeaveFormFromDateChanged>(_onFromDateChanged);
    on<LeaveFormToDateChanged>(_onToDateChanged);
    on<LeaveFormReasonChanged>(_onReasonChanged);
    on<LeaveFormSubmitted>(_onSubmitted);
    on<LeaveFormReset>(_onReset);
  }

  void _onLeaveTypeChanged(LeaveFormLeaveTypeChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormUpdated(
      leaveType: event.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: state.reason,
      email: state.email,
      organizationSlug: state.organizationSlug,
    ));
  }

  void _onFromDateChanged(LeaveFormFromDateChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormUpdated(
      leaveType: state.leaveType,
      fromDate: event.fromDate,
      toDate: state.toDate,
      reason: state.reason,
      email: state.email,
      organizationSlug: state.organizationSlug,
    ));
  }

  void _onToDateChanged(LeaveFormToDateChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormUpdated(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: event.toDate,
      reason: state.reason,
      email: state.email,
      organizationSlug: state.organizationSlug,
    ));
  }

  void _onReasonChanged(LeaveFormReasonChanged event, Emitter<LeaveFormState> emit) {
    emit(LeaveFormUpdated(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: event.reason,
      email: state.email,
      organizationSlug: state.organizationSlug,
    ));
  }

  Future<void> _onSubmitted(LeaveFormSubmitted event, Emitter<LeaveFormState> emit) async {
    final errors = <String>{};

    if (state.leaveType == null || state.leaveType!.isEmpty) {
      errors.add('leaveType: Leave type is required');
    }
    if (state.fromDate == null) {
      errors.add('fromDate: From date is required');
    }
    if (state.toDate == null) {
      errors.add('toDate: To date is required');
    } else if (state.fromDate != null && state.toDate!.isBefore(state.fromDate!)) {
      errors.add('toDate: To date must be after from date');
    }
    if (state.reason.trim().isEmpty) {
      errors.add('reason: Reason is required');
    }

    if (errors.isNotEmpty) {
      emit(LeaveFormInvalid(
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
        email: event.email,
        organizationSlug: event.organizationSlug,
        errors: {for (var e in errors) e.split(': ')[0]: e.split(': ')[1]},
      ));
      return;
    }

    emit(LeaveFormLoading(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: state.reason,
      email: event.email,
      organizationSlug: event.organizationSlug,
    ));
    try {
      await applyLeave(
        LeaveParams(
          leaveType: state.leaveType!,
          fromDate: state.fromDate!,
          toDate: state.toDate!,
          reason: state.reason,
          email: event.email,
        ),
        event.organizationSlug,
      );
      emit(LeaveFormSuccess(
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
        email: event.email,
        organizationSlug: event.organizationSlug,
      ));
    } catch (e) {
      emit(LeaveFormFailure(
        error: e.toString(),
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
        email: event.email,
        organizationSlug: event.organizationSlug,
      ));
    }
  }

  void _onReset(LeaveFormReset event, Emitter<LeaveFormState> emit) {
    emit(const LeaveFormInitial());
  }
}