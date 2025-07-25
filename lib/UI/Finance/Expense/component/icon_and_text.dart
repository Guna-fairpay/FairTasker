
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color labelColor;
  final VoidCallback? onTap;
  final Color iconColor;
  final EdgeInsets padding;
  final bool isExpanded;
  final TextOverflow? overFlow;

  const IconAndText({
    Key? key,
    required this.label,
    required this.icon,
    this.labelColor = AppC.text,
    this.onTap,
    this.iconColor = AppC.text,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.isExpanded = true,
    this.overFlow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          isExpanded? Flexible(
              child: InkWell(
              onTap: onTap,
              child: Utils.getText(label, color: labelColor, overFlow: overFlow)
              ),
          ): InkWell(
              onTap: onTap,
              child: Utils.getText(label, color: labelColor, overFlow: overFlow)
          ),
        ],
      ),
    );
  }
}
