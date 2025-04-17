import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor, textColor;
  const CompactTextButton({super.key, this.text = "Submit", this.onPressed, this.icon, this.iconColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(text);
    var style = ButtonStyle(
      iconColor: WidgetStatePropertyAll(iconColor),
        foregroundColor: WidgetStatePropertyAll(textColor),
        textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge
            ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold)));
    return (icon != null) ? TextButton.icon(onPressed: onPressed, label: textWidget, style: style, icon: Icon(icon)) : TextButton(
      onPressed: onPressed,
      style: style,
      child: textWidget,
    );
  }
}
