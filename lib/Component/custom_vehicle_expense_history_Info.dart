
import 'package:flutter/material.dart';

import '../Utilities/Utils.dart';
import '../Utilities/appC.dart';

class InfoWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoWidget({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.textColor = AppC.appColor,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, color:iconColor ?? Colors.blueAccent[100], size: 20),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getText(label, weight: FontWeight.bold, size: 12),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTap,
                  child: Utils.getText(
                    value,
                    color: textColor,
                    weight: FontWeight.bold,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
