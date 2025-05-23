
 import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utilities/Utils.dart';

class AskPermissionDialog {
  AskPermissionDialog._();

  static void show(BuildContext context,
      {String? title,
      List<String>? boldWords,
      String? description,
      String? subDescription,
      String? negativeText,
      String? positiveText,
      String?  subPositiveText,
      bool? isReasonRequired,
      void Function(String reason)? onReasonSubmitted,
      VoidCallback? onPositivePressed,
      VoidCallback? onNegativePressed,
      VoidCallback? onSaveMultiPressed,
        bool? isExpense,
        void Function(String reason)? onMultiSubmitted,
      }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AskPermissionDialogView(
        title: title,
        boldWords:boldWords,
        description: description,
        subDescription: subDescription,
        negativeText: negativeText,
        positiveText: positiveText,
        subPositiveText: subPositiveText,
        onPositivePressed: onPositivePressed,
        isReasonRequired: isReasonRequired,
        onReasonSubmitted: onReasonSubmitted,
        onSaveMultiPressed: onSaveMultiPressed,
        onMultiSubmitted: onMultiSubmitted,
        onNegativePressed: onNegativePressed,
        isExpense: isExpense,
      ),
    );
  }
}

class _AskPermissionDialogView extends StatelessWidget {
  final String? title;
  final List<String>? boldWords;
  final String? description;
  final String? subDescription;
  final String? negativeText;
  final String? positiveText;
  final String? subPositiveText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final VoidCallback? onSaveMultiPressed;
  final bool? isReasonRequired;
  final bool? isExpense;
  final void Function(String reason)? onReasonSubmitted;
  final void Function(String reason)? onMultiSubmitted;
  final TextEditingController _reasonController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AskPermissionDialogView(
      {super.key,
      this.title,
      this.boldWords,
      this.description,
      this.subDescription,
      this.negativeText,
      this.positiveText,
      this.subPositiveText,
      this.onPositivePressed,
      this.onSaveMultiPressed,
      this.isReasonRequired,
      this.onMultiSubmitted,
      this.onNegativePressed,
        this.isExpense,
      this.onReasonSubmitted});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: AppC.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: 16.padding,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: 10.sp.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_sharp,size: 40.sp,color: Colors.blue,),
              15.sp.height,
              Utils.getText(
                  title ?? 'Are you sure?',
                  size: 18.sp,
                  weight: FontWeight.bold,
                  align: TextAlign.center),
              8.height,
              Padding(
                padding: 20.sp.horizontalPadding,
                child:buildDynamicText(context, message: description??'', boldWords:boldWords),
              ),
              if (subDescription.isNotNullOrEmpty)
                ...[
                  8.height,
                  Padding(
                    padding: 20.sp.horizontalPadding,
                    child: Utils.getText(
                      subDescription ?? '',
                      size: 12.sp,
                      color: Colors.black54,
                      align: TextAlign.center,
                    ),
                  ),
                ],
              if (isReasonRequired ?? false) ...[
                8.height,
                Utils.getTextFormField(
                    'Enter a reason',
                    _reasonController,
                  validator: (value) => (value?.isEmpty ?? false) ? "Reason is required" : null,
                )
              ],
              8.height,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  ValueListenableBuilder(
                      valueListenable: _reasonController,
                      builder: (context, value, child) => SuccessButton(
                    text: positiveText??'Yes,delete it!',
                    backgroundColor: (value.text.trim().isNullOrEmpty && (isReasonRequired ?? false)) ? Colors.blue.shade100 : AppC.blue,
                    foregroundColor: AppC.white,
                    onPressed: (value.text.trim().isNullOrEmpty && (isReasonRequired ?? false)) ? null : (){
                      if (isReasonRequired ?? false) {
                        if (_formKey.currentState?.validate() ?? false) {
                          onReasonSubmitted?.call(_reasonController.text);
                          context.popDialog();
                        }
                      } else {
                        onPositivePressed?.call();
                        context.popDialog();
                      }
                    },
                  )),
                  if(subPositiveText.isNotNullOrEmpty)
                  SuccessButton(
                    text: subPositiveText ??'',
                    backgroundColor: AppC.appColor,
                    foregroundColor: AppC.white,
                    onPressed: (){
                      if ((isReasonRequired ?? false) && (isExpense ?? false)) {
                        if (_formKey.currentState?.validate() ?? false) {
                          onMultiSubmitted?.call(_reasonController.text);
                          context.popDialog();
                        }
                      } else {
                        onSaveMultiPressed?.call();
                        context.popDialog();
                      }
                      },
                  ),
                  SuccessButton(
                    text:  negativeText ??'Cancel',
                    backgroundColor: AppC.redAccent,
                    foregroundColor: AppC.white,
                    onPressed: () {
                      onNegativePressed?.call();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
/*AlertDialog(
      title: (title.isNotNullOrEmpty) ? Text(title ?? "") : null,
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
                  if (description.isNotNullOrEmpty)
                  Text(description ?? "",
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.normal)),
                  TextFormField(
                    validator: (value) => (value?.isEmpty ?? false) ? "Reason is required" : null,
                      controller: _reasonController,
                      decoration: InputDecoration(
                        hintText: "Enter reason",
                        border: border,
                        enabledBorder: border,
                      )
                  ),
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
    );*/
  Widget buildDynamicText(BuildContext context, {required String message, List<String>? boldWords}) {
    final words = message.split(' ');
    final boldChars = boldWords?.map((e) => e.split(" ")).expand((element) => element);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.textTheme.labelMedium?.copyWith(color: AppC.labelColor,fontSize: 12.sp),
        children: words.map((word) {
          final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), ''); // remove punctuation for match
          final isBold = boldChars?.contains(cleanWord) ?? false;

          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppC.black : null
            ),
          );
        }).toList(),
      ),
    );
  }

}
