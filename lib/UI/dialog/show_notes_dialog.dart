import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class NotesDialog {
  NotesDialog._();

  static void show(BuildContext context,
      {required dynamic message, bool barrierDismissible = true}) async {
    await showDialog(
        context: context,
        builder: (context) => _NotesDialogView(message: message),
        barrierDismissible: barrierDismissible);
  }
}

class _NotesDialogView extends StatelessWidget {
  final dynamic message;

  const _NotesDialogView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      insetPadding: 10.horizontalPadding,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      title: ListTile(
          title: const Text("Notes"),
          titleTextStyle: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          dense: true,
          trailing: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: Text("$message"),
      contentTextStyle: context.textTheme.labelLarge,
    );
  }
}
