
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final Widget  title;
  final Widget? suffix;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool isCheckboxOnRight;
  final bool useExpand;
  final double spacing;
  final EdgeInsets? padding;
  final MainAxisSize mainAxisSize;
  final Color? activeColor;
  final double radius;
  final Color borderColor;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.padding,
    this.spacing = 3,
    this.useExpand = true,
    this.borderColor = AppC.borderColor,
    this.mainAxisSize = MainAxisSize.max,
    this.isCheckboxOnRight = false,
    this.activeColor = AppC.appColor,
    this.radius = Num.subradiusButton,
  }) : super(key: key);

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!(widget.value ?? false));
      },
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          spacing: widget.spacing,
          mainAxisSize: widget.mainAxisSize,
          children: widget.isCheckboxOnRight
              ? [
            widget.title,
            SizedBox.fromSize(
              size: const Size.fromRadius(14), // Control checkbox radius here
              child: Checkbox(
                value: widget.value,
                onChanged: null,
                checkColor: AppC.white,
                tristate: true,
                fillColor: WidgetStateProperty.resolveWith((states) => (states.contains(WidgetState.selected) ? widget.activeColor : null)),
                activeColor:widget.activeColor,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
                side: BorderSide(width: 1, color: widget.borderColor),

              ),
            ),
            if (widget.suffix != null) widget.suffix ?? const SizedBox.shrink(),
          ]
              : [
            SizedBox.fromSize(
              size: const Size.fromRadius(14), // Control checkbox radius here
              child: Checkbox(
                value: widget.value,
                onChanged: null,
                checkColor: AppC.white,
                tristate: true,
                fillColor: WidgetStateProperty.resolveWith((states) => (states.contains(WidgetState.selected) ? widget.activeColor : null)),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
                side: BorderSide(width: 1, color: widget.borderColor),
              ),
            ),
            (widget.useExpand) ? Expanded(child: widget.title) : widget.title,
            if (widget.suffix != null) widget.suffix ?? const SizedBox.shrink(),// Title on the right
          ],
        ),
      ),
    );
  }
}