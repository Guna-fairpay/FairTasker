import 'package:fairpytasker/Utilities/str.dart';
import 'package:flutter/material.dart';

extension StringExtension on String? {
  DateTime? get toDate {
    if (this?.isEmpty ?? false) return null;
    return DateTime.tryParse(this ?? "");
  }

  Color get fromPriority {
    switch (this) {
      case "High":
      case "high":
        return Colors.red;
      case "Medium":
      case "medium":
        return Colors.lightBlue;
        case "Low":
        case "low":
          return Colors.grey;
      default:
        return Colors.black45;
    }
  }

  bool get isImageFile => ((this?.endsWith('.jpg') ?? false) || (this?.endsWith('.png') ?? false) || (this?.endsWith('.jpeg') ?? false));

  String get toAttachmentURL => "${Str.TODO_ATTACHMENTS_URL}$this";
}