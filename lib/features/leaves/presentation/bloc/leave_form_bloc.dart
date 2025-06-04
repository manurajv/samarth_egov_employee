import 'package:bloc/bloc.dart';
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

    emit(LeaveFormLoading(
      leaveType: state.leaveType,
      fromDate: state.fromDate,
      toDate: state.toDate,
      reason: state.reason,
    ));
    try {
      await applyLeave(LeaveParams(
        leaveType: state.leaveType!,
        fromDate: state.fromDate!,
        toDate: state.toDate!,
        reason: state.reason,
      ));
      emit(LeaveFormSuccess(
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
      ));
    } catch (e) {
      emit(LeaveFormFailure(
        error: e.toString(),
        leaveType: state.leaveType,
        fromDate: state.fromDate,
        toDate: state.toDate,
        reason: state.reason,
      ));
    }
  }

  void _onReset(LeaveFormReset event, Emitter<LeaveFormState> emit) {
    emit(const LeaveFormInitial());
  }
}