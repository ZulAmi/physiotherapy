import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import '../utils/validation_utils.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final String? hint;
  final void Function(String)? onChanged;

  const EmailField({
    super.key,
    required this.controller,
    this.label = 'Email',
    this.isRequired = false,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'Enter email address',
      icon: Icons.email,
      isRequired: isRequired,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => ValidationUtils.validateEmail(value),
      onChanged: onChanged,
    );
  }
}
