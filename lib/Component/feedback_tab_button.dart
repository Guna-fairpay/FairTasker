import 'package:fairpytasker/Component/badge_child.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:flutter/material.dart';

class FeedbackTabButton extends StatelessWidget {
  final String buttonText;
  final String? subText;
  final int value, selectedValue;
  final bool showBade;
  final int? badgeCount;
  final Color? overrideTextColor;
  final Function(int val)? onPressed;

  const FeedbackTabButton({super.key,
    this.onPressed,
    this.showBade = false,
    this.badgeCount,
    this.overrideTextColor,
    required this.buttonText,
    this.subText,
    required this.value,
    required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return BadgeChild(
      count: badgeCount,
      showBadge: showBade,
      child: CustomTabButton<int>(
        overrideTextColor: overrideTextColor,
        buttonText: buttonText,
        subText: subText,
        value: value,
        selectedValue: selectedValue,
        onPressed: onPressed),
    );
  }
}
