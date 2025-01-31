
import 'package:flutter/material.dart';

import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class RoundedBorderListTile extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final VoidCallback? onTap; // Add an optional onTap callback

  const RoundedBorderListTile({
    Key? key,
    required this.leadingText,
    required this.trailingText,
    this.onTap, // Initialize the onTap parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Wrap with InkWell for tap functionality
      onTap: onTap, // Assign the onTap callback
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border(
            bottom: BorderSide(color: AppC.black, width: 0.10),
            left: BorderSide(color: AppC.black, width: 0.15),
            right: BorderSide(color: AppC.black, width: 0.15),
          ),
        ),
        child: ListTile(
          leading: Utils.getText(leadingText), // Use the passed-in text
          trailing: Utils.getText(trailingText), // Use the passed-in text
        ),
      ),
    );
  }
}