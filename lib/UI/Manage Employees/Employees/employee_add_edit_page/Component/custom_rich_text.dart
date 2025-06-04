import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRichText extends StatelessWidget {
  final String text;
  const CustomRichText({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style:  TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              color: const Color(0xff212529)
            ),
            children: [
              TextSpan(
                text: text,
              ),
              const TextSpan(
                text: ' * ',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
