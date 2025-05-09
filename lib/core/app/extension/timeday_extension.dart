import 'package:date_time/date_time.dart' show Time;
import 'package:flutter/material.dart';

extension TimedayExtension on TimeOfDay? {
  String? toHMS() {
    var input = this;
    if (input == null) return null;
    var hour = input.hour.toString().padLeft(2, '0');
    var min = input.minute.toString().padLeft(2, '0');
    return "$hour:$min:00";
  }

  DateTime? get toDateTime {
    var input = this;
    if (input == null) return null;
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, input.hour, input.minute);
  }
}

extension TimeExtension on Time? {
  String toHM() {
    var input = this;
    if (input == null) return "00:00";
    var hour = input.hour.toString().padLeft(2, '0');
    var min = input.minute.toString().padLeft(2, '0');
    return "$hour:$min";
  }

  String toHMS() {
    var input = this;
    if (input == null) return "00:00";
    var hour = input.hour.toString().padLeft(2, '0');
    var min = input.minute.toString().padLeft(2, '0');
    var sec = input.second.toString().padLeft(2, '0');
    return "$hour:$min:$sec";
  }
}