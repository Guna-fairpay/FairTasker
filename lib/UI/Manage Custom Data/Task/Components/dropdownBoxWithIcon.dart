
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/utils.dart';

class DropdownBoxWithIcon extends StatelessWidget {
  final List<dynamic> list;
  final String label;
  final String hindText;
  final dynamic selectedKey;
  final dynamic initialSelection;
  final VoidCallback onTap;
  final String? Function(dynamic)? validator;
  final Function(dynamic) onChanged;

  const DropdownBoxWithIcon({
    super.key,
    required this.list,
    required this.label,
    required this.hindText,
    required this.initialSelection,
     this.selectedKey,
    required this.onChanged,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Utils.dropdownBox(
            hindText,
            list,
            (selectedValue) {
              onChanged.call(selectedValue);
              Utils.dismissKeyboard(context);
            },
            labelKey: label,
            initialSelection: initialSelection,
            selectedKey: selectedKey,
            topRRadius: 0,
            bottomRRadius: 0,
            validator: validator,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
              color: AppC.blue50,
              border:  const Border(
                top: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
                bottom: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
                right: BorderSide(width: Num.borderWidthField, color: AppC.fieldBase),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.5,vertical: 5.5,),
              child: Icon(Icons.add,color: AppC.blue,),
            ),
          ),
        ),
      ],
    );
  }
}
