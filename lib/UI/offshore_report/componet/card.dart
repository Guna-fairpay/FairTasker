import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final Clip clipBehavior;
  final EdgeInsetsGeometry? margin;
  final bool borderOnForeground;
  final bool semanticContainer;
  final Color? shadowColor;
  final Color? surfaceTintColor;

  const CustomCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(10),
    this.elevation = 2,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.clipBehavior = Clip.antiAlias,
    this.borderOnForeground = true,
    this.margin,
    this.semanticContainer = false,
    this.shadowColor,
    this.surfaceTintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: clipBehavior,
      margin: margin,
      borderOnForeground: borderOnForeground,
      semanticContainer: semanticContainer,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        width: double.maxFinite,
        margin: 3.spMin.leftPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(3.spMin)),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
