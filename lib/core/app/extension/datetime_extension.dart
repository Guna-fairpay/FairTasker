import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DatetimeExtension on DateTime? {

  String get findAgo {
    if (this == null) return "0s";
    var currentDate = DateTime.now().toUtc();
    var difference = currentDate.difference(this!);
    return timeago.format(this!, locale: "en_short");
  }

  String? toFormat({String format = "yyyy-MM-dd"}) {
    var input = this;
    if (input == null) return null;
    var dateFormat = DateFormat(format);
    return dateFormat.format(input);
  }

  String get formatDateWithOrdinal {
    final day = (this?.day ?? 0);
    final suffix = day.getDaySuffix;
    final month = DateFormat('MMM').format(this ?? DateTime.now()); // "Apr"
    final year = this?.year ?? 0;

    return '$month $day$suffix $year';
  }

  String get dayName {
    final day = (this ?? DateTime.now());
    final date = DateFormat.EEEE();
    return date.format(day);
  }

  DateTime subtractMonth(int duration) {
    DateTime dateTime = this ?? DateTime.now();
    int year = DateTime.now().year;
    int month = dateTime.month - (duration);

    if (month == 0) {
      month = 12;
      year -= 1;
    }

    int day = dateTime.day;
    int lastDayOfNewMonth = DateTime(year, month + 1, 0).day;

    // Adjust if the original day is too big for the new month
    if (day > lastDayOfNewMonth) {
      day = lastDayOfNewMonth;
    }

    return DateTime(year, month, day, dateTime.hour, dateTime.minute, dateTime.second);
  }

}