
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onChanged;
  final bool value;
  final bool groupValue;
  const CustomRadioButton({super.key,this.label,this.onChanged,this.value=false,this.groupValue=false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged:(value)=> onChanged,
        ),
        Utils.getText(label??'',size: 12.sp,),
      ],
    );
  }
}
