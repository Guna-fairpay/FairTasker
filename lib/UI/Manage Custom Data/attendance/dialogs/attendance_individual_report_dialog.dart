import 'package:flutter/material.dart';

class AttendanceIndividualReport {

  AttendanceIndividualReport._();

  static final AttendanceIndividualReport dialog = AttendanceIndividualReport._();

  void show(BuildContext context, {bool isDaily = true, Map<String, dynamic>? data}) async {
    return showDialog(context: context, builder: (context) => AlertDialog(
      title: ListTile(
        title: Text("${isDaily ? "Daily" : "Weekly"} Report"),
        contentPadding: EdgeInsets.zero,
        trailing: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.clear_rounded),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      content: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDaily)
              Center(child: Text("Username", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center,)),
            Text(isDaily ? "Jan 4th 2025" : "Jan 4th 2025 - Jan 10th 2025", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            Text.rich(TextSpan(
              text: "Your total hours were ",
              children: [
                TextSpan(text: "33:18", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
              ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            Text.rich(TextSpan(
                text: "Your active hours were ",
                children: [
                  TextSpan(text: "00:00", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
                ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            Text.rich(TextSpan(
                text: "Your idle hours were ",
                children: [
                  TextSpan(text: "33:18", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
                ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            if (isDaily)
            Text.rich(const TextSpan(
                text: "Please let me know the reason for these idle hours so I can log your active hours correctly into the HR system.",
            ), style: Theme.of(context).textTheme.labelLarge,),
            if (!isDaily)
            Text.rich(TextSpan(
                text: "Total number of tasks completed ",
                children: [
                  TextSpan(text: "8", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
                ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            if (!isDaily)
            Text.rich(TextSpan(
                text: "Tasks duration individual average - ",
                children: [
                  TextSpan(text: "(infinity)", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
                ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            if (!isDaily)
            Text.rich(TextSpan(
                text: "Tasks duration team average - ",
                children: [
                  TextSpan(text: "(infinity)", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
                ]
            ), style: Theme.of(context).textTheme.labelLarge,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.copy_rounded),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

}