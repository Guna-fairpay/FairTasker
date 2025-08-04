
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
  final bool useFlexible;
  final double spacing;
  final EdgeInsets? padding;
  final MainAxisSize mainAxisSize;
  final Color? activeColor;
  final double radius;
  final Color borderColor;
  final bool wrapExpand;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.padding,
    this.spacing = 3,
    this.useExpand = true,
    this.useFlexible = false,
    this.borderColor = AppC.borderColor,
    this.mainAxisSize = MainAxisSize.max,
    this.isCheckboxOnRight = false,
    this.activeColor = AppC.appColor,
    this.radius = Num.subradiusButton,
    this.wrapExpand = false,
  }) : super(key: key);

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    Widget checkBox = SizedBox.fromSize(
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
    );
    Widget title = (widget.useExpand) ? Expanded(child: widget.title) : (widget.useFlexible) ? Flexible(child: widget.title) : widget.title;
    if (widget.isCheckboxOnRight) title = widget.title;
    List<Widget> children = [];
    if (widget.isCheckboxOnRight) children.add(title);
    children.add(checkBox);
    if (!widget.isCheckboxOnRight) children.add(title);
    if (widget.suffix != null) children.add(widget.suffix ?? const SizedBox.shrink());
    EdgeInsets padding = widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
    Widget child = InkWell(
      onTap: () {
        widget.onChanged(!(widget.value ?? false));
      },
      child: Padding(
        padding: padding,
        child: Row(
          spacing: widget.spacing,
          mainAxisSize: widget.mainAxisSize,
          children: children,
        ),
      ),
    );
    if (widget.wrapExpand) child = Expanded(child: child);
    return child;
  }
}