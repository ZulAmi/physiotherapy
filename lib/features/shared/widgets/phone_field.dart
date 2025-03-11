import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text_field.dart';
import '../utils/validation_utils.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final String? hint;
  final void Function(String)? onChanged;

  const PhoneField({
    super.key,
    required this.controller,
    this.label = 'Phone Number',
    this.isRequired = false,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'Enter phone number',
      icon: Icons.phone,
      isRequired: isRequired,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PhoneNumberFormatter(),
      ],
      validator: (value) => ValidationUtils.validatePhone(value),
      onChanged: onChanged,
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    var count = 0;

    for (var i = 0; i < text.length; i++) {
      if (count == 3 || count == 6) {
        buffer.write('-');
      }
      buffer.write(text[i]);
      count++;
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
