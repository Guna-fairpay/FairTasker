import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';

class NotesTaskAddEditDialog {
  NotesTaskAddEditDialog._();

  static void show(BuildContext context, {required Map<String, dynamic>? model, ValueChanged<String>? onChanged, bool isEdit = false}) async {
    await showDialog(
        context: context,
        builder: (context) => _NotesTaskAddEditDialogView(model: model, onChanged: onChanged, isEdit: isEdit),
        barrierDismissible: true);
  }
}

class _NotesTaskAddEditDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextEditingController _controller = TextEditingController();
  final ValueChanged<String>? onChanged;
  final bool isEdit;
  _NotesTaskAddEditDialogView({this.model, this.onChanged, required this.isEdit}) {
    if (isEdit) _controller.text = model?['title'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      title: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        trailing: IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      // contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      insetPadding: 10.padding,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getTextFormField("Notes", _controller),
            Utils.getFilledButton("Save", () {
              if (_controller.text.trim().isNotNullOrEmpty) {
                onChanged?.call(_controller.text);
                context.popDialog();
              }
            }),
          ]
        ),
      ),
    );
  }
}
