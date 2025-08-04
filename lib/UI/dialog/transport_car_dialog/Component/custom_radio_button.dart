
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final String? label;
  final ValueChanged<T?>? onChanged;
  final T value;
  final T? groupValue;
  const CustomRadioButton({super.key,this.label,this.onChanged,required this.value, this.groupValue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 2,
      borderRadius: BorderRadius.circular(Num.borderRadius),
      splashColor: AppC.trans,
      onTap: () => onChanged?.call(value),
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: null,
            activeColor: AppC.appColor,
            fillColor: const WidgetStatePropertyAll(AppC.appColor),
          ),
          Utils.getText(label??'',size: 12.sp,),
          10.sp.width,
        ],
      ),
    );
  }
}
