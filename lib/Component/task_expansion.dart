import 'package:flutter/material.dart';

import '../Utilities/Utils.dart';
import '../Utilities/appC.dart';

class TaskExpansion extends StatelessWidget {
  final String leadingText;
  final String titleText;
  final bool isInitialExpand;
  final List<Widget> children;
  const TaskExpansion({
    Key? key,
    this.isInitialExpand = false,
    required this.leadingText,
    required this.titleText,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: isInitialExpand,
      leading: Utils.getText(
        leadingText,
        color: AppC.appColor,
        weight: FontWeight.bold,
      ),
      title: Utils.getText(
        titleText,
        color: AppC.appColor,
        weight: FontWeight.bold,
        align: TextAlign.end,
      ),
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          color: AppC.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: children,
          ),
        ),
      ],
      collapsedShape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppC.black, width: 0.15),
      ),
      backgroundColor: const Color(0xFFEAF0FA),
      collapsedBackgroundColor: const Color(0xFFEAF0FA),
    );
  }
}
