import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class NotesDialog {
  NotesDialog._();

  static void show(BuildContext context,
      {required dynamic message, bool barrierDismissible = true, void Function(String? value)? onSave}) async {
    await showDialog(
        context: context,
        builder: (context) => _NotesDialogView(message: message, onSave: onSave),
        barrierDismissible: barrierDismissible);
  }
}

class _NotesDialogView extends StatelessWidget {
  final dynamic message;
  final void Function(String? value)? onSave;
  late TextEditingController _controller;
  _NotesDialogView({required this.message, this.onSave}) {
    _controller = TextEditingController(text: "${message ?? ""}");
  }

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
      content: (onSave == null) ? Text("$message") : SizedBox(
        width: context.width,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getTextFormField("Notes", _controller, textType: TextInputType.multiline, maxLines: 5, inputAction: TextInputAction.newline),
            Utils.getFilledButton("Save", () {
              onSave?.call(_controller.text);
              Navigator.pop(context);
            })
          ],
        ),
      ),
      contentTextStyle: context.textTheme.labelLarge,
    );
  }
}
