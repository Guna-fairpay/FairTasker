extension IntExtension on int {
  int get toPositive {
    return this < 0 ? 0 : this;
  }

  String get minutesToHourMinute {
    final hours = this ~/ 60;
    final minutes = this % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get getDaySuffix {
    var day = this ?? 0;
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String get minutesToHM {
    final hours = this ~/ 60;
    final minutes = this % 60;
    return '${hours}h ${minutes}m';
  }
}