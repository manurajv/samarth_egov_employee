import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDatePicker extends FormField<DateTime> {
  final String labelText;
  final String? hintText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  AppDatePicker({
    super.key,
    required this.labelText,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
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

  const _AppDatePickerWidget({
    required this.labelText,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.errorText,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.accentWhite,
              surface: AppColors.primaryDarkBlue,
              onSurface: AppColors.accentWhite,
            ),
            dialogBackgroundColor: AppColors.primaryDarkBlue,
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
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          filled: true,
          fillColor: AppColors.glassWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.accentWhite),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.accentWhite.withOpacity(0.7)),
          errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.errorRed,
          ),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : hintText ?? "Select Date",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}