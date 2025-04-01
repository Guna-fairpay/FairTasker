

import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class PrivateRentalDialog{
  PrivateRentalDialog._();
  static void show(BuildContext context,{
    VoidCallback? onCompleted,
    VoidCallback? onDelete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PrivateRentalDialogView(
        onCompleted: onCompleted,
        onDelete: onDelete,
      ),
    );
  }
}

class _PrivateRentalDialogView extends StatelessWidget {
  final VoidCallback? onCompleted;
  final VoidCallback? onDelete;
  const _PrivateRentalDialogView({this.onCompleted, this.onDelete});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      insetPadding: 10.padding.copyWith(top: 50),
      titlePadding: EdgeInsets.zero,
      contentPadding: 10.padding,
      title: ListTile(trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close)
      ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getText(
                "Task already exists, please complete or delete the task"
            ),
            ListTile(trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.getAddFilledButton("Complete", () {
                  onCompleted?.call();
                  Navigator.pop(context);
                }, bgColor: AppC.green),
                const SizedBox(width: 20,),
                Utils.getAddFilledButton("Delete", () {
                  onDelete?.call();
                  Navigator.pop(context);
                }, bgColor: AppC.red),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}