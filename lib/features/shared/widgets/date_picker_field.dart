import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_text_field.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final bool isRequired;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final String? hint;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint ?? 'Select date',
      icon: Icons.calendar_today,
      isRequired: isRequired,
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? DateFormat('MMM d, yyyy').format(selectedDate!)
            : '',
      ),
      validator: (value) {
        if (validator != null) {
          return validator!(selectedDate);
        }
        if (isRequired && selectedDate == null) {
          return '$label is required';
        }
        return null;
      },
      onTap: () => _showDatePicker(context),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}
