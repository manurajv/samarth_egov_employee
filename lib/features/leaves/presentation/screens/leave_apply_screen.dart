import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common/app_button.dart';
import '../../../../core/widgets/common/app_snackbar.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/inputs/app_dropdown.dart';
import '../../../../core/widgets/inputs/app_textfield.dart';
import '../../../../core/widgets/inputs/date_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/leave_form_bloc.dart';
import '../bloc/leave_form_event.dart';
import '../bloc/leave_form_state.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({super.key});

  @override
  _LeaveApplyScreenState createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    // Move listener logic to avoid setState during build
    _reasonController.addListener(() {
      // Update _hasUnsavedChanges without triggering setState immediately
      _hasUnsavedChanges = _reasonController.text.isNotEmpty;
      // Defer setState to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<LeaveFormBloc>();
    print('Form state before validation: ${bloc.state}'); // Debug state
    if (_formKey.currentState!.validate()) {
      // Retrieve email and organizationSlug dynamically
      final storage = sl.get<FlutterSecureStorage>();
      storage.read(key: 'user_email').then((email) {
        storage.read(key: 'org_slug').then((organizationSlug) {
          bloc.add(LeaveFormSubmitted(
            email: email ?? 'manuraj.2024@iic.ac.in',
            organizationSlug: organizationSlug ?? 'delhi-university',
          ));
        });
      });
    } else {
      // Debug which fields are invalid
      final errors = (bloc.state is LeaveFormInvalid) ? (bloc.state as LeaveFormInvalid).errors : {};
      print('Validation errors: $errors');
      AppSnackBar.showError(context, l10n.pleaseFillAllFields);
    }
  }

  void _clearForm(BuildContext context) {
    _reasonController.clear();
    context.read<LeaveFormBloc>().add(const LeaveFormReset());
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (!_hasUnsavedChanges) return true;
    final l10n = AppLocalizations.of(context)!;
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmExit),
        content: Text(l10n.unsavedChangesWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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

    return BlocProvider(
      create: (context) => sl.get<LeaveFormBloc>(),
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              l10n.applyLeave,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.accentWhite,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: AppColors.accentWhite,
                size: 20,
              ),
              onPressed: () async {
                if (await _onWillPop(context)) {
                  context.go('/dashboard/leaves/balance');
                }
              },
            ),
            actions: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.trash,
                  color: AppColors.accentWhite,
                  size: 20,
                ),
                onPressed: () => _clearForm(context),
                tooltip: l10n.clearForm,
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
              ),
            ),
            child: SafeArea(
              child: BlocConsumer<LeaveFormBloc, LeaveFormState>(
                listener: (context, state) {
                  if (state is LeaveFormSuccess) {
                    AppSnackBar.showSuccess(
                      context,
                      l10n.leaveApplicationSubmitted,
                    );
                    _clearForm(context);
                    Future.delayed(const Duration(seconds: 1), () {
                      context.go('/dashboard/leaves/balance');
                    });
                  } else if (state is LeaveFormFailure) {
                    AppSnackBar.showError(
                      context,
                      state.error,
                    );
                  } else if (state is LeaveFormInvalid) {
                    AppSnackBar.showError(
                      context,
                      l10n.pleaseFillAllFields,
                    );
                  }
                },
                builder: (context, state) {
                  // Avoid setting _reasonController.text directly in build
                  // Initialize controller text only once, or update via listener
                  if (_reasonController.text != state.reason) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _reasonController.text = state.reason;
                      }
                    });
                  }

                  // Update _hasUnsavedChanges based on form state
                  _hasUnsavedChanges = state.leaveType != null ||
                      state.fromDate != null ||
                      state.toDate != null ||
                      state.reason.isNotEmpty;

                  final errors = state is LeaveFormInvalid ? state.errors : {};

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: GlassCard(
                          blur: 12,
                          opacity: 0.2,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.applyLeave,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: AppColors.accentWhite,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AppDropdown<String>(
                                    labelText: l10n.leaveType,
                                    hintText: l10n.selectLeaveType,
                                    value: state.leaveType,
                                    items: leaveTypes
                                        .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<LeaveFormBloc>().add(
                                          LeaveFormLeaveTypeChanged(value),
                                        );
                                        // Defer setState to avoid build conflict
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              _hasUnsavedChanges = true;
                                            });
                                          }
                                        });
                                      }
                                    },
                                    errorText: errors['leaveType'],
                                    validator: (value) =>
                                    value == null || value.isEmpty ? l10n.leaveTypeRequired : null,
                                  ),
                                  const SizedBox(height: 16),
                                  AppDatePicker(
                                    labelText: l10n.fromDate,
                                    hintText: l10n.selectDate,
                                    selectedDate: state.fromDate,
                                    onDateSelected: (date) {
                                      context.read<LeaveFormBloc>().add(
                                        LeaveFormFromDateChanged(date),
                                      );
                                      // Defer setState
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          setState(() {
                                            _hasUnsavedChanges = true;
                                          });
                                        }
                                      });
                                    },
                                    errorText: errors['fromDate'],
                                    validator: (value) =>
                                    value == null ? l10n.fromDateRequired : null,
                                  ),
                                  const SizedBox(height: 16),
                                  AppDatePicker(
                                    labelText: l10n.toDate,
                                    hintText: l10n.selectDate,
                                    selectedDate: state.toDate,
                                    onDateSelected: (date) {
                                      context.read<LeaveFormBloc>().add(
                                        LeaveFormToDateChanged(date),
                                      );
                                      // Defer setState
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          setState(() {
                                            _hasUnsavedChanges = true;
                                          });
                                        }
                                      });
                                    },
                                    errorText: errors['toDate'],
                                    validator: (value) {
                                      if (value == null) return l10n.toDateRequired;
                                      if (state.fromDate != null && value.isBefore(state.fromDate!)) {
                                        return l10n.toDateBeforeFromDate;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    controller: _reasonController,
                                    labelText: l10n.reason,
                                    hintText: l10n.enterReason,
                                    maxLines: 4,
                                    onChanged: (value) {
                                      context.read<LeaveFormBloc>().add(
                                        LeaveFormReasonChanged(value),
                                      );
                                      // Defer setState
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          setState(() {
                                            _hasUnsavedChanges = value.isNotEmpty;
                                          });
                                        }
                                      });
                                    },
                                    errorText: errors['reason'],
                                    validator: (value) =>
                                    value!.trim().isEmpty ? l10n.reasonRequired : null,
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          text: l10n.cancel,
                                          backgroundColor: AppColors.grey,
                                          foregroundColor: AppColors.accentWhite,
                                          onPressed: () => _clearForm(context),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: AppButton(
                                          text: l10n.submit,
                                          backgroundColor: AppColors.primaryBlue,
                                          foregroundColor: AppColors.accentWhite,
                                          onPressed: () => _validateAndSubmit(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state is LeaveFormLoading)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(child: LoadingIndicator()),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}