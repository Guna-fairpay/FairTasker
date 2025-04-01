

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

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
  _PrivateRentalDialogView({super.key, this.onCompleted, this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AlertDialog(
        content: Column(
          children: [
            ListTile(trailing: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close,)
            ),
            ),
            Expanded(
                child: Utils.getText(
                    "Task already exists, please complete or delete the task"
                )
            ),
            ListTile(trailing: Row(
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