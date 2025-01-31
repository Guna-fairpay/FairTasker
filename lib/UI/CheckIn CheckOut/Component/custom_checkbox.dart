
import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final Widget  title;
  final dynamic value;
  final ValueChanged<bool?> onChanged;
  final bool isCheckboxOnRight;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
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
              ),
            ),
            const SizedBox(width: 4), // Spacing between checkbox and text
            Expanded(child: widget.title), // Title on the right
          ],
        ),
      ),
    );
  }
}