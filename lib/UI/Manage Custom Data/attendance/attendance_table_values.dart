import 'package:flutter/material.dart';

class AttendanceTableValues extends TableRow {
  final String name;
  final dynamic daily, weekly;
  final BuildContext context;
  final VoidCallback? onDaily, onWeekly;
  const AttendanceTableValues(this.context, {super.key, required this.name, required this.daily, required this.weekly, this.onDaily, this.onWeekly});

  @override
  List<Widget> get children => [
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelLarge,
        textAlign: TextAlign.center,
      ),
    ),
    GestureDetector(
  onTap: (daily.toString() == '00:00') ? null : onDaily,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "${daily ?? ""}",
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.center,
        ),
      ),
    ),
    GestureDetector(
      onTap: (weekly.toString() == '00:00') ? null : onWeekly,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "${weekly ?? ""}",
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ];
}
