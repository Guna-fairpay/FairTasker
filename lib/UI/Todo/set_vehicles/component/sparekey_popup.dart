import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';

class SpareKeyDialog{
  SpareKeyDialog._();
  static void show(BuildContext context, {
    Function(bool value)? save,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SpareKeyDialog(
        save: save,
      ),
    );
  }
}

class _SpareKeyDialog extends StatelessWidget {
  final Function(bool value)? save;
  const _SpareKeyDialog({this.save});
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
              leading: const Text("Confirmation",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF495057)),),
              trailing: GestureDetector(
                  onTap: context.pop,
                  child: const Icon(Icons.close, color: AppC.grey, size: 25)
              ),
              contentPadding: EdgeInsets.zero,
            ),
            FittedBox(
              child: Row(
                spacing: 10,
                children: [
                  SuccessButton(
                    text: 'Save',
                    onPressed:() {
                      save?.call(false);
                      context.pop();
                    },
                    backgroundColor: AppC.appColor,
                  ),
                  SuccessButton(
                    text: 'Save with SpareKey Task',
                    onPressed:() {
                      save?.call(true);
                      context.pop();
                    },
                    backgroundColor: AppC.green,
                  ),
                  SuccessButton(
                    text: 'Cancel',
                    onPressed:context.pop,
                    backgroundColor: AppC.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}