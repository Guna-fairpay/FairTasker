import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';

class AskPermissionDialog {
  AskPermissionDialog._();

  static void show(BuildContext context,
      {String? title,
      String? description,
      String? negativeText,
      String? positiveText,
      bool? isReasonRequired,
      void Function(String reason)? onReasonSubmitted,
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
        isReasonRequired: isReasonRequired,
        onReasonSubmitted: onReasonSubmitted,
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
  final bool? isReasonRequired;
  final void Function(String reason)? onReasonSubmitted;
  final TextEditingController _reasonController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AskPermissionDialogView(
      {super.key,
      this.title,
      this.description,
      this.negativeText,
      this.positiveText,
      this.onPositivePressed,
      this.isReasonRequired,
      this.onReasonSubmitted});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
    );
    return AlertDialog(
      title: Text("$title"),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
      backgroundColor: AppC.white,
      content: (isReasonRequired ?? false)
          ? Form(
        key: _formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text("$description",
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.normal)),
                  TextFormField(
                    validator: (value) => (value?.isEmpty ?? false) ? "Reason is required" : null,
                      controller: _reasonController,
                      decoration: InputDecoration(
                        hintText: "Enter reason",
                        border: border,
                        enabledBorder: border,
                      )),
                ],
              ),
          )
          : Text("$description",
              style: context.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.normal)),
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
                  if (isReasonRequired ?? false) {
                    if (_formKey.currentState?.validate() ?? false) {
                      onReasonSubmitted?.call(_reasonController.text);
                      Navigator.pop(context);
                    }
                  } else {
                    onPositivePressed?.call();
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor:
                        const WidgetStatePropertyAll(AppC.appColor),
                    shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusLarge))),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                    foregroundColor: WidgetStatePropertyAll(AppC.white),
                    textStyle:
                        WidgetStatePropertyAll(context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700))),
                child: Text("$positiveText")),
          ],
        ),
      ],
    );
  }
}
