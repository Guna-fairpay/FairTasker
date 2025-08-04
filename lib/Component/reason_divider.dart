import 'package:flutter/material.dart';

class ReasonDivider extends StatelessWidget {
  final Widget child;
  const ReasonDivider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        SizedBox(height: 5),
        Divider(),
        SizedBox(height: 5),
      ],
    );
  }
}
