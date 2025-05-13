



import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class SpareKeyTaskDialog{
  SpareKeyTaskDialog._();
  static void show(BuildContext context, {
    VoidCallback? save,
    VoidCallback? spareKeyCreate,
    VoidCallback? cancel,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SpareKeyTaskDialogView(
        save: save,
        spareKeyCreate: spareKeyCreate,
        cancel: cancel,
      ),
    );
  }
}

class _SpareKeyTaskDialogView extends StatelessWidget {
  final VoidCallback? save;
  final VoidCallback? spareKeyCreate;
  final VoidCallback? cancel;
  const _SpareKeyTaskDialogView({this.save, this.spareKeyCreate, this.cancel});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      insetPadding: 15.padding.copyWith(top: 20),
      titlePadding: EdgeInsets.zero,
      //contentPadding: 10.padding,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Utils.getText("Confirmation",size: 16),
              trailing: GestureDetector(
                onTap: ()=> context.pop(),
                  child: Icon(Icons.close, color: AppC.grey, size: 25)
              ),
              contentPadding: EdgeInsets.zero,
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utils.getAddFilledButton(
                    "Save",
                      (){
                      save?.call();
                      context.pop();
                      },
                    bgColor: AppC.appColor
                ),
                Utils.getAddFilledButton(
                    "Save with SpareKey Task",
                     (){
                      spareKeyCreate?.call(); context.pop();
                      }
                    ,bgColor: AppC.green
                ),
                Utils.getAddFilledButton(
                    "Cancel",
                    ()=> context.pop(),
                    bgColor: AppC.red
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}