import 'dart:convert';

import 'package:date_time/date_time.dart' show Time;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
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

  bool get isImageFile => ((this?.endsWith('.jpg') ?? false) || (this?.endsWith('.png') ?? false) || (this?.endsWith('.jpeg') ?? false) || (this?.endsWith('.svg') ?? false));

  bool get isPdf => ((this?.endsWith('.pdf') ?? false));

  bool get isAudio => ((this?.endsWith('.m4a') ?? false) || (this?.endsWith('.mp3') ?? false) || (this?.endsWith('.wav') ?? false) || (this?.endsWith('.aac') ?? false) || (this?.endsWith('.webm') ?? false));

  bool get isVideo => ((this?.endsWith('.mp4') ?? false) || (this?.endsWith('.3gp') ?? false) || (this?.endsWith('.mkv') ?? false) || (this?.endsWith('.bin') ?? false) || (this?.endsWith('.mov') ?? false) );

  String get toAttachmentURL => "${Str.TODO_ATTACHMENTS_URL}$this";

  String get toStorageURL => "${Str.STORAGE_BASE_URL}$this";

  String get toTaskerStorageURL => "${Str.TASKER_STORAGE_BASE_URL}$this";

  String get removeTaskerStorageUrl => this?.replaceAll(Str.TASKER_STORAGE_BASE_URL, "") ?? "";

  String get removeStorageUrl => this?.replaceAll(Str.STORAGE_BASE_URL, "") ?? "";

  String get removeAttachmentURL => this?.replaceAll(Str.TODO_ATTACHMENTS_URL, "") ?? "";

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

  bool get isGetAroundReservation => this?.toLowerCase() == "Getaround ReservationID".toLowerCase();

  bool get isTuroReservation => this?.toLowerCase() == "Turo Reservation ID".toLowerCase();

  DateTime? toDateTime({String inputFormat = "yyyy-MM-dd"}) {
    try {
      var input = this;
      if ((input == null) || (input.isEmpty) || (isNullOrEmpty) || (input.contains("0000"))) return null;
      var dateFormat = DateFormat(inputFormat);
      return dateFormat.parse(input);
    } catch (e) {
      return null;
    }
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


  String toSentenceCase() {
    if (this?.isEmpty ?? false) return this ?? '';
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }



bool get isNullOrEmpty => (this == null) || (this?.isEmpty ?? false) || (this == "null");
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  TimeOfDay? toTimeOfDay({String inputFormat = "HH:mm"}) {
    var date = toDateTime(inputFormat: inputFormat);
    return (date != null) ? TimeOfDay.fromDateTime(date) : null;
  }

  int get getOnlyNumeric => int.parse((this ?? "").replaceAll(RegExp('[^0-9]'), ''));

  String getInitials() {
    RegExp regExp = RegExp(r"\b\w");
    Iterable<Match> matches = regExp.allMatches(this!.trim().toUpperCase());

    return matches.map((m) => m.group(0)!).take(2).join();
  }

  bool get isValidCompletedTime {
    if (isNullOrEmpty) return false;
    var value = this;
    var time = Time.fromStr(value);
    var result = (time != null) && (time.inMins <= Time.minutesInDay);
    Console.of.log("$time $result");
    return result;
  }

  String get notValidCompletedTimeMessage {
    if (isNullOrEmpty) return "Please select time taken";
    var value = this;
    var time = Time.fromStr(value);
    var result = time != null;
    return result ? "" : (this?.contains(":") == false) ? "Please enter time in the format of 01:00" : "Please enter valid time taken";
  }

  String get toDoubleDigit {
    if (isNullOrEmpty) return "0";
    var doubleValue = double.tryParse(this ?? "0");
    var numberFormat = NumberFormat("0.00");
    return numberFormat.format(doubleValue);
  }

  num get toNumeric => num.tryParse(this ?? "") ?? 0;

  int get parseDurationToMinutes {
    final parts = this?.split(':').map(int.tryParse).toList();

    if (parts?.contains(null) ?? false) return 0; // Invalid input

    int hours = 0, minutes = 0, seconds = 0;

    switch (parts?.length) {
      case 3:
        hours = parts?[0] ?? 0;
        minutes = parts?[1] ?? 0;
        seconds = parts?[2] ?? 0;
        break;
      case 2:
        hours = parts?[0] ?? 0;
        minutes = parts?[1] ?? 0;
        break;
      case 1:
        minutes = parts?[0] ?? 0;
        break;
      default:
        return 0;
    }

    return hours * 60 + minutes + (seconds / 60).round();
  }

  String get removeNextLines {
    if (isNullOrEmpty) return "";
    return this?.replaceAll(RegExp(r'[\r\n]+'), "") ?? "";
  }

  int? get getExpenseId {
    if (isNullOrEmpty) return null;
    var output = jsonDecode(this ?? "");
    if (output is List<dynamic>) return output.firstOrNull;
    else return output;
  }
}