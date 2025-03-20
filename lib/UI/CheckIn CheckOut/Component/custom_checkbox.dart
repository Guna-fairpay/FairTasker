
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final Widget  title;
  final dynamic value;
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
        widget.onChanged(!widget.value);
      },
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisSize: widget.mainAxisSize,
          children: widget.isCheckboxOnRight
              ? [
            widget.title, // Title on the left
            const SizedBox(width: 4),
            SizedBox(
              width: 24, // Control checkbox width here
              height: 24, // Control checkbox height here
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
              ),
            ),
          ]
              : [
            SizedBox(
              width: 24, // Control checkbox width here
              height: 24, // Control checkbox height here
              child: Checkbox(
                value: widget.value,
                onChanged: widget.onChanged,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.subradiusButton),
                ),
                side: BorderSide(width: 0.5, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 4), // Spacing between checkbox and text
            (widget.useExpand) ? Expanded(child: widget.title) : widget.title, // Title on the right
          ],
        ),
      ),
    );
  }
}