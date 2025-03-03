import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart' show OpenFile;

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

  bool get isCustomLink => this?.toLowerCase() == "custom link";

  bool get isGetAroundReservation => this?.toLowerCase() == "Getaround ReservationID";

  bool get isTuroReservation => this?.toLowerCase() == "Turo Reservation ID";

  DateTime? toDateTime({String inputFormat = "yyyy-MM-dd"}) {
    var input = this;
    if ((input == null) || (input.isEmpty) ) return null;
    var dateFormat = DateFormat(inputFormat);
    return dateFormat.parse(input);
  }

  get open async {
    if(this?.isEmpty ?? false) return;
    await OpenFile.open((this as String));
  }

  String toTitleCase() {
    if (this?.isEmpty ?? false) return this ?? "";
    return this?.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ') ?? "";
  }

  bool get isNullOrEmpty => (this == null) || (this?.isEmpty ?? false) || (this == "null");

  TimeOfDay? toTimeOfDay({String inputFormat = "HH:mm"}) {
    var date = toDateTime(inputFormat: inputFormat);
    return (date != null) ? TimeOfDay.fromDateTime(date) : null;
  }
}