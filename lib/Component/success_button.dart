import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class SuccessButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool isOutline;
  final double? elevation;
  final VoidCallback? onPressed;
  final Color? backgroundColor, foregroundColor;
  final Alignment? alignment;
  final GestureTapDownCallback? onTapDown;

  const SuccessButton(
      {super.key,
      this.text,
      this.icon,
      this.onTapDown,
      this.onPressed,
      this.elevation = 0,
      this.isOutline = false,
      this.alignment = Alignment.center,
      this.backgroundColor = AppC.green,
      this.foregroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    var style = ButtonStyle(
      alignment: alignment,
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge))),
        side: WidgetStatePropertyAll((isOutline)
            ? BorderSide(
                color: foregroundColor ?? AppC.appColor,
                width: Num.borderWidthField)
            : BorderSide.none),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp)),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        visualDensity: VisualDensity.compact,
        iconColor: WidgetStatePropertyAll(foregroundColor),
        textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge
            ?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12.sp)));
    return GestureDetector(
      onTapDown: onTapDown,
      child: (icon != null)
          ? (isOutline)
          ? OutlinedButton.icon(
          key: key,
          icon: Icon(icon),
          onPressed: onPressed,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          style: style,
          label: Text(text ?? 'Submit'))
          : ElevatedButton.icon(
        key: key,
        icon: Icon(icon),
        onPressed: onPressed,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: style,
        label: Text(text ?? 'Submit'),
      )
          : (isOutline)
          ? OutlinedButton(
          key: key,
          onPressed: onPressed,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          style: style,
          child: Text(text ?? 'Submit'))
          : ElevatedButton(
        key: key,
        onPressed: onPressed,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: style,
        child: Text(text ?? 'Submit'),
      ),
    );
  }
}
