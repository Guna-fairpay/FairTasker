import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class VerificationListingPage extends StatelessWidget {
  const VerificationListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
       Container(
         height: 400,
         width: 400,
         color: Colors.amber,
       ),
        const Row(
          spacing: 10,
          children: [
            SuccessButton(text: 'View', backgroundColor: AppC.appColor,),
            SuccessButton(text: 'Regenerate', backgroundColor: AppC.appColor,),
            SuccessButton(text: 'Generate', backgroundColor: AppC.appColor,),
          ],
        ),
        Row(
          spacing: 20,
          children: [
            Expanded(
                child: Utils.getTextFormField('Notes', TextEditingController(text: 'test'), minLines: 2, maxLines: 2,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckboxListTile(
                  title: Text('Force Action'),
                  value: false,
                  onChanged: (value) {},
                  padding: 0.padding,
                  useExpand: false,
                  mainAxisSize: MainAxisSize.min,
                  radius: 8,
                  borderColor: AppC.appColor,
                ),
                const Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SuccessButton(text: 'Approve',),
                    SuccessButton(text: 'Reject', backgroundColor: AppC.redAccent,),
                  ],
                ),
              ],
            ),
          ],
        ),
        const CompactText('Checklist', fontWeight: FontWeight.bold, color: AppC.lightDark,),

      ],
    );
  }
}
