import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteDialog {
  DeleteDialog._();

  static void show(BuildContext context, {
    void Function()? onChanged,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeleteDialog(
        onChanged: onChanged,),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  final void Function()? onChanged;
  const _DeleteDialog({super.key, this.onChanged});

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
            Align(
              alignment: Alignment.centerRight,
              child: SuccessButton(
                text: "Task Only",
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
