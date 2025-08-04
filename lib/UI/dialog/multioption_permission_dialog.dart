import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesMultiOptionDialog {
  NotesMultiOptionDialog._();

  static void show(BuildContext context, { Map<String, dynamic>? model,  ValueChanged<String>? onChanged, bool showNotes = false, bool showTask = false}) async {
    Console.of.log("NOTE $showNotes, TASK $showTask");
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MultiOptionDialogView(onChanged: onChanged, showNotes: showNotes, showTask: showTask),
    );
  }
}

class _MultiOptionDialogView extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final bool showNotes, showTask;
  const _MultiOptionDialogView({super.key, this.onChanged, this.showNotes = false, this.showTask = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      backgroundColor: Colors.white,
      insetPadding: 10.sp.padding,
      contentPadding: 10.sp.horizontalPadding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      title: ListTile(
        dense: true,
        contentPadding: 5.sp.padding,
        trailing: IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Are you sure want to delete the task/notes", style: context.textTheme.labelLarge, textAlign: TextAlign.start,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                if (showNotes)
                SuccessButton(
                  text: "Notes Only",
                  onPressed: (){
                    onChanged?.call("notes");
                    context.popDialog();
                  },
                ),
                if (showTask)
                SuccessButton(
                  text: "Task Only",
                  backgroundColor: AppC.appColor,
                  onPressed: (){
                    onChanged?.call("task");
                    context.popDialog();
                  },
                ),
                if (showNotes && showTask)
                SuccessButton(
                  text: "Both",
                  backgroundColor: AppC.red,
                  onPressed: (){
                    onChanged?.call("both");
                    context.popDialog();
                  },
                ),
                const SizedBox.shrink()
              ],
            ),
            const SizedBox.shrink(),
            10.height,
          ],
        ),
      ),
    );
  }
}
