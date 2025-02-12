import 'package:flutter/material.dart';

extension TimedayExtension on TimeOfDay? {
  String? toHMS() {
    var input = this;
    if (input == null) return null;
    var hour = input.hour.toString().padLeft(2, '0');
    var min = input.minute.toString().padLeft(2, '0');
    return "$hour:$min:00";
  }
}