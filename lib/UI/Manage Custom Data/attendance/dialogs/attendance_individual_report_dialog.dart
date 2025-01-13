import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/dialogs/attendance_dialog_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttendanceIndividualReport {

  AttendanceIndividualReport._();

  static final AttendanceIndividualReport dialog = AttendanceIndividualReport._();

  void show(BuildContext context, {bool isDaily = true, Map<String, dynamic>? data}) async {
    const String basicContent = "Your total hours were 33:18\nYour active hours were 00:00\nYour idle hours were 33:18";
    final String content = isDaily
        ? "Jan 4th 2025\n$basicContent\nPlease let me know the reason for these idle hours so I can log your active hours correctly into the HR system."
    : "Jan 4th 2025 - Jan 10th 2025\n$basicContent\nTotal number of tasks completed 8\nTasks duration individual average - (infinity)\nTasks duration team average - (infinity)";
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
            const AttendanceDialogLabelWidget(label: "Your total hours were", value: "33:18"),
            const AttendanceDialogLabelWidget(label: "Your active hours were", value: "00:00"),
            const AttendanceDialogLabelWidget(label: "Your idle hours were", value: "33:18"),
            if (isDaily)
              const AttendanceDialogLabelWidget(label: "Please let me know the reason for these idle hours so I can log your active hours correctly into the HR system.",),
            if (!isDaily)
              const AttendanceDialogLabelWidget(label: "Total number of tasks completed", value: 8,),
            if (!isDaily)
              const AttendanceDialogLabelWidget(label: "Tasks duration individual average -", value: "(infinity)",),
            if (!isDaily)
              const AttendanceDialogLabelWidget(label: "Tasks duration team average -", value: "(infinity)",),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                  },
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