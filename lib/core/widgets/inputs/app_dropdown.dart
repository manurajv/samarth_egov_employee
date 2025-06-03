import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const AppDropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
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
        labelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      dropdownColor: AppColors.primaryDarkBlue,
      style: Theme.of(context).textTheme.bodyMedium,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentWhite),
    );
  }
}