import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAlertDialog {
  DeleteAlertDialog._();

  static void show(BuildContext context, {
    void Function()? onChanged,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeleteAlertDialog(
          onChanged: onChanged,),
    );
  }
}

class _DeleteAlertDialog extends StatelessWidget {
  final void Function()? onChanged;
  const _DeleteAlertDialog({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      backgroundColor: Colors.white,
      insetPadding: 10.spMin.padding,
      contentPadding: 10.spMin.horizontalPadding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      title: ListTile(
        dense: true,
        contentPadding: 5.spMin.padding,
        trailing: IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Are you sure want to delete the task/products", style: context.textTheme.labelLarge, textAlign: TextAlign.start,),
            Align(
              alignment: Alignment.centerRight,
              child: SuccessButton(
                text: "Products Only",
                onPressed: (){
                  onChanged?.call();
                  context.popDialog();
                },
              ),
            ),
            const SizedBox.shrink(),
            10.height,
          ],
        ),
      ),
    );
  }
}
