import 'package:timeagoago/timeagoago.dart' as timeago;

extension DatetimeExtension on DateTime? {

  String get findAgo {
    if (this == null) return "0s";
    var currentDate = DateTime.now().toUtc();
    var difference = currentDate.difference(this!);
    return timeago.format(this!, locale: "en_short");
  }

}