import 'package:fairpytasker/UI/authentication_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class AskPermissionDialog {
  AskPermissionDialog._();

  static void show(BuildContext context,
      {String? title,
      String? description,
      String? negativeText,
      String? positiveText,
      VoidCallback? onPositivePressed}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AskPermissionDialogView(
        title: title,
        description: description,
        negativeText: negativeText,
        positiveText: positiveText,
        onPositivePressed: onPositivePressed,
      ),
    );
  }
}

class _AskPermissionDialogView extends StatelessWidget {
  final String? title;
  final String? description;
  final String? negativeText;
  final String? positiveText;
  final VoidCallback? onPositivePressed;

  const _AskPermissionDialogView(
      {super.key,
      this.title,
      this.description,
      this.negativeText,
      this.positiveText,
      this.onPositivePressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$title"),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      content: Text("$description"),
      contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      titleTextStyle:
          context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
      contentTextStyle:
          context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.normal),
      actions: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor:
                      WidgetStatePropertyAll(context.theme.colorScheme.error),
                  textStyle:
                      WidgetStatePropertyAll(context.textTheme.labelLarge)),
              child: Text("$negativeText"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPositivePressed?.call();
                },
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: const WidgetStatePropertyAll(AppC.appColor),
                    shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusLarge))),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                    foregroundColor: WidgetStatePropertyAll(AppC.blue50),
                    textStyle:
                        WidgetStatePropertyAll(context.textTheme.labelLarge)),
                child: Text("$positiveText")),
          ],
        ),
      ],
    );
  }
}
