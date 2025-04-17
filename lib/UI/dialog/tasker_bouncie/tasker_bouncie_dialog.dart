import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerBouncieDialog {
  TaskerBouncieDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model, {Key? key}) async {
    await showDialog(context: context, builder: (context) => _TaskerBouncieDialogView(key: key, model: model));
  }
}

class _TaskerBouncieDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerBouncieDialogView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      insetPadding: 16.sp.padding,
      contentPadding: 16.sp.horizontalPadding.copyWith(bottom: 16.sp),
      titlePadding: EdgeInsets.zero,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        // dense: true,
        title: Text("${model?['display']?['vehicle_name']}"),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(color: AppC.appColor),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      alignment: Alignment.topCenter,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          spacing: 16.sp,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: 16.sp.horizontalPadding,
              decoration: BoxDecoration(
                color: AppC.bouncieBgColor,
                borderRadius: BorderRadius.circular(Num.borderRadius),
                border: Border.all(color: AppC.bouncieBgBorderColor)
              ),
              padding: 10.sp.padding,
              child: Text("Login to bouncie to get details", style: context.textTheme.labelLarge?.copyWith(color: AppC.bouncieFontColor)),
            ),
            const SuccessButton(
              text: "Login Bouncie",
              backgroundColor: AppC.bouncieButtonColor,
            )
          ],
        ),
      ),
    );
  }
}
