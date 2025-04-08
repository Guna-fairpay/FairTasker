import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesTaskComponent extends StatelessWidget {
  final bool showComplete, showRemove;
  final Map<String, dynamic>? model;
  final GestureTapDownCallback? onTapDown;
  final void Function(Map<String, dynamic>? value)? onCreateTask, onRemoveTask;
  final ValueChanged<bool?>? onShowHideNotes;
  final void Function(bool? value, Map<String, dynamic>? data)? onCompleteTask;
  final TextEditingController? taskController, notesController;

  const NotesTaskComponent(
      {super.key,
      this.model,
      this.showComplete = false,
      this.taskController,
      this.notesController,
      this.onCreateTask,
      this.onRemoveTask,
      this.onTapDown,
      this.onCompleteTask,
      this.onShowHideNotes,
      this.showRemove = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // COMPLETE
            if (showComplete)
              Checkbox(
                  value: (model?['complete_status'] == 1),
                  onChanged: (value) => onCompleteTask?.call(value, model),
                  checkColor: AppC.white,
                  fillColor: WidgetStateProperty.resolveWith((states) =>
                      (states.contains(WidgetState.selected))
                          ? AppC.appColor
                          : null),
                  side: const BorderSide(width: Num.borderWidthThinField)),
            Expanded(
                child: Utils.getTextFormField(
              "Enter Task / Notes",
              taskController ?? TextEditingController(),
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value?.trim().isNullOrEmpty ?? false) ? "Required" : null,
            )),
            // SHOW NOTES BOX
            Checkbox(
                value: (model?['showNotes'] ?? false),
                onChanged: onShowHideNotes,
                checkColor: AppC.white,
                fillColor: WidgetStateProperty.resolveWith((states) =>
                    (states.contains(WidgetState.selected))
                        ? AppC.appColor
                        : null),
                side: const BorderSide(width: Num.borderWidthThinField)),
            // MORE THAN ONE TASK / ALREADY TASK CREATED
            if (showRemove || (model?['todo_id'] != null && model?['todo_id'] != 0 && (model?['todos'] != null)))
              IconButton(
                  onPressed: () => onRemoveTask?.call(model),
                  icon: const Icon(Icons.remove_rounded))
          ],
        ),
        if (model?['showNotes'] ?? false) ...[
          Padding(
              padding: 16.sp.leftPadding,
              child: Utils.getTextFormField(
                  "Notes", notesController ?? TextEditingController(),
                  minLines: 4,
                  maxLines: 7,
                  inputAction: TextInputAction.newline,
                  textType: TextInputType.multiline)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTapDown: onTapDown,
                child: Text( ((model?['selectedUsers'].toString().isNullOrEmpty ?? false) || (List.from(model?['selectedUsers']).isEmpty)) ? "Select User" : "${((List.from(model?['selectedUsers']).take(1).map((e) => <String>[(e['first_name'] ?? ""), (e['last_name'] ?? "")].toInitial)).join(", "))}${List.from(model?['selectedUsers']).length > 1 ? "..." : ""}",
                    style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: AppC.appColor)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              const SizedBox.shrink(),
              SuccessButton(
                  text: (((model?['todo_id'] ?? 0) != 0) && (model?['todos'] != null)) ? "Update Task" : "Create Task",
                  onPressed: () => onCreateTask?.call(model)),
            ],
          ),
        ],
      ],
    );
  }
}
