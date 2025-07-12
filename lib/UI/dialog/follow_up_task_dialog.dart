import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class TaskerFollowupTaskDialog {
  TaskerFollowupTaskDialog._();

  static void show(BuildContext context, {VoidCallback? onPositive}) async => await showDialog(context: context, builder: (context) => _FollowUpTaskDialog(onPositive: onPositive), barrierDismissible: false);
}

class _FollowUpTaskDialog extends StatelessWidget {
  final VoidCallback? onPositive;
  const _FollowUpTaskDialog({super.key, this.onPositive});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: "Follow-up Task",
      onCloseDialog: context.pop,
      content: Column(
        spacing: 10,
        children: [
          const CompactText("Do you want to create another task for the same customer?"),
          Row(
            spacing: 10,
            children: [
              SuccessButton(text: "Yes", backgroundColor: AppC.appColor, onPressed: () {
               onPositive?.call();
               context.pop();
              }),
              SuccessButton(text: "No", backgroundColor: AppC.redAccent, onPressed: context.pop),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
