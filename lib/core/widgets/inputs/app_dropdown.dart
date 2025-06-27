import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? errorText;
  final String? Function(T?)? validator;

  const AppDropdown({
    super.key,
    required this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
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
        labelStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
        errorStyle: theme.textTheme.bodySmall?.copyWith(color: AppColors.errorRed),
      ),
      dropdownColor: AppColors.lightGrey,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryDarkBlue),
      // menuStyle: MenuStyle(
      //   backgroundColor: WidgetStateProperty.all(AppColors.lightGrey),
      //   shape: WidgetStateProperty.all(
      //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //   ),
      // ),
      selectedItemBuilder: (context) => items.map((item) => Text(
        item.value.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
      )).toList(),
    );
  }
}