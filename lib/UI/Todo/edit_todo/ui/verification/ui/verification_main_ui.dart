import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class VerificationMainUI extends StatelessWidget {
  const VerificationMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Container(
          decoration:  const BoxDecoration(
              border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.borderColor))
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                CustomTabButton(
                  buttonText: 'License',
                  value: 1,
                  selectedValue: 1,
                  onPressed: (v){},
                  decoration:  BoxDecoration(
                    border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                  ),
                ),
                CustomTabButton(
                  buttonText: 'Address',
                  value: 2,
                  selectedValue: 1,
                  onPressed: (v){},
                  decoration:  BoxDecoration(
                    border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                  ),
                ),
                CustomTabButton(
                  buttonText: 'Agreement',
                  value: 2,
                  selectedValue: 1,
                  onPressed: (v){},
                  decoration:  BoxDecoration(
                    border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                  ),
                ),
                CustomTabButton(
                  buttonText: 'Payment',
                  value: 2,
                  selectedValue: 1,
                  onPressed: (v){},
                  decoration:  BoxDecoration(
                    border: Border.all(color: AppC.grey, width: Num.borderWidthButton),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                  ),
                ),
              ],
            ),
          ),
        ),
        switch(1)
        {
          1 => const Placeholder(color: Colors.brown,),
          2 => const Placeholder(color: Colors.brown,),
          3 => const Placeholder(color: Colors.brown,),
          4 => const Placeholder(color: Colors.brown,),
          _ => const Placeholder(color: Colors.brown,)
        }
      ],
    );
  }
}
