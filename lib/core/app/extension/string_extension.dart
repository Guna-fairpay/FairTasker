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

  String get toStorageURL => "${Str.STORAGE_BASE_URL}$this";

  String get removeStorageUrl => this?.replaceAll(Str.STORAGE_BASE_URL, "") ?? "";

  bool get isNetworkURL => ((this?.startsWith('http') ?? false) || (this?.startsWith('https') ?? false));

  String get toTuroReserveUrl => "${Str.TURO_RESERV_URL}$this";

  String get toGetAroundReserveUrl => "${Str.GETAROUND_RESERV_URL}$this";

  String get toBearer => "Bearer ${this ?? ""}";

  bool get isFairReturns => this?.startsWith(Str.LIST_BASE_URL) ?? false;

  bool get isDoesNotRepeat => this?.toLowerCase() == "doesn't repeat";

  bool get isWeekly => this?.toLowerCase() == "weekly";

  bool get isDaily => this?.toLowerCase() == "daily";

  bool get isMonthly => this?.toLowerCase() == "monthly";

  bool get isYearly => this?.toLowerCase() == "yearly";

  bool get isDailyOrWeekly => isDaily || isWeekly;

  bool get isMonthlyOrYearly => isMonthly || isYearly;
}