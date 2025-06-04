import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_appbar.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/common/app_snackbar.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/inputs/app_dropdown.dart';
import '../../../../core/widgets/inputs/app_textfield.dart';
import '../../../../core/widgets/inputs/date_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/leave_form_bloc.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({super.key});

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final leaveTypes = [
      'Casual Leave',
      'Restricted Holiday',
      'Earned Leave',
      'Half Pay Leave',
      'Commuted Leave',
      'Maternity Leave',
      'Paternity Leave',
      'Child Care Leave',
      'Study Leave',
      'Extraordinary Leave',
    ];

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.applyLeave,
        showBackButton: true,
      ),
      body: SafeArea(
        child: BlocConsumer<LeaveFormBloc, LeaveFormState>(
          listener: (context, state) {
            if (state is LeaveFormSuccess) {
              AppSnackBar.showSuccess(
                context,
                l10n.leaveApplicationSubmitted,
              );
              Navigator.pop(context);
            } else if (state is LeaveFormFailure) {
              AppSnackBar.showError(
                context,
                state.error,
              );
            }
          },
          builder: (context, state) {
            String? leaveType;
            DateTime? fromDate;
            DateTime? toDate;

            if (state is LeaveFormInitial || state is LeaveFormInvalid) {
              leaveType = state.leaveType;
              fromDate = state.fromDate;
              toDate = state.toDate;
              reasonError = state is LeaveFormInvalid ? state.errors['reason'] : null;
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.applyLeave,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.accentWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppDropdown<String>(
                            labelText: l10n.leaveType,
                            value: leaveType,
                            items: leaveTypes
                                .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<LeaveFormBloc>().add(
                                  LeaveFormLeaveTypeChanged(value),
                                );
                              }
                            },
                            validator: (value) => value == null ? l10n.leaveTypeRequired : null,
                          ),
                          const SizedBox(height: 16),
                          AppDatePicker(
                            labelText: l10n.fromDate,
                            selectedDate: fromDate,
                            onDateSelected: (date) {
                              context.read<LeaveFormBloc>().add(
                                LeaveFormFromDateChanged(date),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          AppDatePicker(
                            labelText: l10n.toDate,
                            selectedDate: toDate,
                            onDateSelected: (date) {
                              context.read<LeaveFormBloc>().add(
                                LeaveFormToDateChanged(date),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _reasonController,
                            labelText: l10n.reason,
                            maxLines: 4,
                            onChanged: (value) {
                              context.read<LeaveFormBloc>().add(
                                LeaveFormReasonChanged(value),
                              );
                            },
                            validator: (value) =>
                            value!.isEmpty ? l10n.reasonRequired : null,
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: l10n.submit,
                            onPressed: () {
                              context.read<LeaveFormBloc>().add(
                                LeaveFormSubmitted(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is LeaveFormLoading)
                  const Center(child: LoadingIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}