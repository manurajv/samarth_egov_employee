import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDatePicker extends FormField<DateTime> {
  final String labelText;
  final String? hintText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ThemeData? datePickerTheme;
  final Widget? icon;

  AppDatePicker({
    super.key,
    required this.labelText,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.datePickerTheme,
    this.icon,
    String? errorText,
    FormFieldValidator<DateTime>? validator,
  }) : super(
    initialValue: selectedDate,
    validator: validator,
    builder: (FormFieldState<DateTime> state) {
      return _AppDatePickerWidget(
        labelText: labelText,
        hintText: hintText,
        selectedDate: state.value,
        onDateSelected: (date) {
          state.didChange(date);
          onDateSelected(date);
        },
        firstDate: firstDate,
        lastDate: lastDate,
        errorText: errorText ?? state.errorText,
        datePickerTheme: datePickerTheme,
        icon: icon,
      );
    },
  );
}

class _AppDatePickerWidget extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;
  final ThemeData? datePickerTheme;
  final Widget? icon;

  const _AppDatePickerWidget({
    required this.labelText,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.datePickerTheme,
    this.icon,
  });

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: datePickerTheme ??
              theme.copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryBlue,
                  onPrimary: AppColors.accentWhite,
                  surface: AppColors.lightGrey,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: AppColors.lightGrey,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                ),
                textTheme: const TextTheme(
                  headlineMedium: TextStyle(color: Colors.black), // Month/Year
                  bodyMedium: TextStyle(color: Colors.black), // Days
                ),
              ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mediumGrey),
          errorText: errorText,
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.mediumGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.mediumGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
          suffixIcon: icon ?? const Icon(Icons.calendar_today, color: AppColors.primaryDarkBlue),
          labelStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
          errorStyle: theme.textTheme.bodySmall?.copyWith(color: AppColors.errorRed),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : hintText ?? "Select Date",
          style: selectedDate != null
              ? theme.textTheme.bodyMedium?.copyWith(color: Colors.black)
              : theme.textTheme.bodyMedium?.copyWith(color: AppColors.mediumGrey),
        ),

      ),
    );
  }
}