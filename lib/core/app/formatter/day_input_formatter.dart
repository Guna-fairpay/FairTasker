import 'package:flutter/services.dart';

class DayInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? number = int.tryParse(newValue.text);
    if (number == null || number < 1 || number > 31) {
      return oldValue; // Reject invalid input
    }

    return newValue; // Accept valid input
  }
}