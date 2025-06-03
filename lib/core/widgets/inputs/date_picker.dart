import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
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
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : "Select Date",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}