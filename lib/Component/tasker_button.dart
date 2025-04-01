import 'package:flutter/material.dart';

class TaskerButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Color? color;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  const TaskerButton({super.key, required this.child, this.onPressed, this.color, this.padding, this.borderRadius, this.border});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onPressed,
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: borderRadius
          ),
          child: child,
        ),
      ),
    );
  }
}
