
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
  final EdgeInsets? padding;
  final MainAxisSize mainAxisSize;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.padding,
    this.useExpand = true,
    this.mainAxisSize = MainAxisSize.max,
    this.isCheckboxOnRight = false,
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
          spacing: 3,
          mainAxisSize: widget.mainAxisSize,
          children: widget.isCheckboxOnRight
              ? [
            widget.title,
            SizedBox.fromSize(
              size: const Size.fromRadius(14), // Control checkbox radius here
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                tristate: true,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.subradiusButton),
                ),
                side: const BorderSide(width: 1, color: AppC.borderColor),
              ),
            ),
            if (widget.suffix != null) widget.suffix ?? const SizedBox.shrink(),
          ]
              : [
            SizedBox.fromSize(
              size: const Size.fromRadius(14), // Control checkbox radius here
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                tristate: true,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.subradiusButton),
                ),
                side: const BorderSide(width: 1, color: AppC.borderColor),
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