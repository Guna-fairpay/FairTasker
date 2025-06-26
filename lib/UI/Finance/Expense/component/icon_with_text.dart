
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color labelColor;
  final VoidCallback? onTap;

  const IconAndText({
    Key? key,
    required this.label,
    required this.icon,
    this.labelColor = AppC.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppC.text, size: 20),
          Expanded(child: InkWell(
              onTap: onTap,
              child: Utils.getText(label,color: labelColor,))),
        ],
      ),
    );
  }
}
