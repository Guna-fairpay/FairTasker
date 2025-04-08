import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class SuccessButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final double? elevation;
  final VoidCallback? onPressed;
  final Color? backgroundColor, foregroundColor;

  const SuccessButton(
      {super.key,
      this.text,
      this.icon,
      this.onPressed,
      this.elevation = 0,
      this.backgroundColor = AppC.green,
      this.foregroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    var style = ButtonStyle(
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge))),
        side: const WidgetStatePropertyAll(BorderSide.none),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp)),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)));
    return (icon != null)
        ? ElevatedButton.icon(
            key: key,
            icon: Icon(icon),
            onPressed: onPressed,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: style,
            label: Text(text ?? 'Submit'),
          )
        : ElevatedButton(
            key: key,
            onPressed: onPressed,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: style,
            child: Text(text ?? 'Submit'),
          );
  }
}
