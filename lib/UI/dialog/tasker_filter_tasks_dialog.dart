import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class TaskerFilterTasksDialog {
  TaskerFilterTasksDialog._();

  static void show(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => _TaskerFilterTasksDialogView(),
    );
  }
}

class _TaskerFilterTasksDialogView extends StatelessWidget {
  const _TaskerFilterTasksDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      surfaceTintColor: Colors.transparent,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding,
      titlePadding: 10.horizontalPadding,
      backgroundColor: AppC.blue50?.withValues(alpha: 0.9),
      title: ListTile(
        dense: true,
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
            )),
      ),
      contentPadding: 10.horizontalPadding,
      content: _TaskerFilterTasksDialogContentView(),
    );
  }
}

class _TaskerFilterTasksDialogContentView extends StatelessWidget {
  const _TaskerFilterTasksDialogContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCheckboxListTile(
            title: const Text("All Todo"),
            value: false,
            onChanged: (value) {},
          ),
        ]
      ),
    );
  }
}

