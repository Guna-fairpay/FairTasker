import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerTimeChangeReasonDialog {
  TaskerTimeChangeReasonDialog._();

  static void show(BuildContext context,
      {String type = "pickup", ValueChanged<String>? onSubmitted}) async {
    await showDialog(
        context: context,
        builder: (context) => _TaskerTimeChangeReasonDialogView(
            type: type, onSubmitted: onSubmitted));
  }
}

class _TaskerTimeChangeReasonDialogView extends StatelessWidget {
  final String type;
  final TextEditingController reasonController = TextEditingController();
  final ValueChanged<String>? onSubmitted;

  _TaskerTimeChangeReasonDialogView({this.type = "pickup", this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 10.padding,
      contentPadding: 16.spMin.horizontalPadding.copyWith(bottom: 16.spMin),
      titlePadding: EdgeInsets.zero,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        dense: true,
        // contentPadding: EdgeInsets.zero,
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      alignment: Alignment.topCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text((type == "drop") ? "CheckIn/Drop Car is later than the time specified in booking *" : "Checkout/Pickup Car is earlier than the time specified in booking *",
              style: context.textTheme.labelLarge?.copyWith(
                color: AppC.text
              )
          ),
          CompactTextField(
              hintText: "Reason for date/time change",
              controller: reasonController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value?.trim().isNullOrEmpty ?? false)
                  ? "Reason is required"
                  : null),
          Row(
            children: [
              SuccessButton(
                text: "Submit",
                onPressed: () {
                  if (reasonController.text.trim().isEmpty) return;
                  onSubmitted?.call(reasonController.text);
                  context.popDialog();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
