import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabButton<T> extends StatelessWidget {
  final Function(T val)? onPressed;
  final EdgeInsets? padding;
  final String buttonText;
  final TextStyle? textStyle;
  final BorderRadius? tapBorderRaius;
  final T value, selectedValue;
  final Decoration? decoration;
  final Color? selectedBorderColor;
  final Color? overrideTextColor;
  final IconData? icon;

  const CustomTabButton(
      {super.key,
      this.onPressed,
      this.decoration,
      this.textStyle,
      this.padding,
      this.tapBorderRaius,
      this.icon,
      this.selectedBorderColor,
      this.overrideTextColor,
      required this.buttonText,
      required this.value,
      required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    var width = 0.5;
    return InkWell(
      borderRadius: tapBorderRaius ?? const BorderRadius.only(
              topRight: Radius.circular(5), topLeft: Radius.circular(5)),
      onTap: () => onPressed?.call(value),
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: (selectedValue != value)
            ? null
            : decoration ??
                BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(width: width, color: selectedBorderColor ?? AppC.borderColor),
                      start: BorderSide(width: width, color: selectedBorderColor ?? AppC.borderColor),
                      end: BorderSide(width: width, color: selectedBorderColor ?? AppC.borderColor),
                    ),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5))),
        child: Text.rich(TextSpan(
          children: [
            if (icon != null)
              WidgetSpan(child: Icon(icon, size: 16.spMin, color: (selectedValue != value) ? null : AppC.appColor)),
            if (icon != null)
              WidgetSpan(child: 4.width),
            TextSpan(text: buttonText)
          ]
        ),
            style: textStyle ??
                context.textTheme.labelLarge?.copyWith(
                  fontSize: 14.spMin,
                    color: overrideTextColor ?? ((selectedValue != value) ? null : AppC.appColor),
                    fontWeight: (selectedValue != value)
                        ? FontWeight.normal
                        : FontWeight.bold,
                    fontFamily: "Lato")),
      ),
    );
  }
}
