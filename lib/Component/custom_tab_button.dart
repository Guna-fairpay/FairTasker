import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomTabButton<T> extends StatelessWidget {
  final Function(T val)? onPressed;
  final EdgeInsets? padding;
  final String buttonText;
  final TextStyle? textStyle;
  final BorderRadius? tapBorderRaius;
  final T value, selectedValue;
  final Decoration? decoration;

  const CustomTabButton(
      {super.key,
      this.onPressed,
      this.decoration,
      this.textStyle,
      this.padding,
      this.tapBorderRaius,
      required this.buttonText,
      required this.value,
      required this.selectedValue});

  @override
  Widget build(BuildContext context) {
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
                const BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(width: 0.2),
                      start: BorderSide(width: 0.2),
                      end: BorderSide(width: 0.2),
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5))),
        child: Text(buttonText,
            style: textStyle ??
                context.textTheme.labelLarge?.copyWith(
                    color: (selectedValue != value) ? null : AppC.appColor,
                    fontWeight: (selectedValue != value)
                        ? FontWeight.normal
                        : FontWeight.bold,
                    fontFamily: "Lato")),
      ),
    );
  }
}
