import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text_field.dart';

class NumericField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final String? hint;
  final int? minValue;
  final int? maxValue;
  final void Function(String)? onChanged;

  const NumericField({
    super.key,
    required this.controller,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.minValue,
    this.maxValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'Enter number',
      icon: Icons.numbers,
      isRequired: isRequired,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isRequired ? '$label is required' : null;
        }
        final number = int.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }
        if (minValue != null && number < minValue!) {
          return '$label must be at least $minValue';
        }
        if (maxValue != null && number > maxValue!) {
          return '$label must be at most $maxValue';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
