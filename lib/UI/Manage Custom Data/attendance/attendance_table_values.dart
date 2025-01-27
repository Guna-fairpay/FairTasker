import 'package:flutter/material.dart';

class AttendanceTableValues extends TableRow {
  final String name;
  final dynamic daily, weekly;
  final BuildContext context;
  final Function(bool val)? onTap;
  const AttendanceTableValues(this.context, {super.key, required this.name, required this.daily, required this.weekly, this.onTap});

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
  onTap: () => onTap?.call(true),
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
      onTap: () => onTap?.call(false),
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
