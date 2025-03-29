
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';


class CheckBoxWithText extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final double scale;

  const CheckBoxWithText({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.scale = 1.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: scale,
          child: SizedBox(
            height: 30,
            width: 30,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              side: const BorderSide(
                  color: AppC.appColor, width: 1),
              activeColor: const Color(0xff4788ff),
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        Utils.getText(label),
      ],
    );
  }
}
