import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OTPField({
    super.key,
    required this.controller,
    this.autoFocus = false,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: AppColors.accentWhite,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.glassWhite.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accentBlue),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
            onChanged?.call(value);
          }
        },
        onSaved: (value) {
          if (value?.length == 1) {
            onCompleted?.call(value!);
          }
        },
      ),
    );
  }
}