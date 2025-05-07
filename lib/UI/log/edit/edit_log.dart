import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLog extends StatelessWidget {
  final Map<String, dynamic>? model;
  const EditLog({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Log"),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: SafeArea(
        minimum: 16.sp.padding,
        child: Column(
          spacing: 10.sp,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompactTextField(
              minLines: 3,
              maxLines: 7,
              controller: TextEditingController(),
              hintText: "Title",
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SuccessButton(
                  text: "\u{1F4C1} Upload",
                  backgroundColor: Colors.white,
                  foregroundColor: AppC.text,
                  isOutline: true,
                ),
                SuccessButton(
                  text: "\u{1F399} Audio",
                  backgroundColor: Colors.white,
                  foregroundColor: AppC.text,
                  isOutline: true,
                ),
                SuccessButton(
                  text: "\u{1F4F9} Video",
                  backgroundColor: Colors.white,
                  foregroundColor: AppC.text,
                  isOutline: true,
                )
                ]
            ),
            const SuccessButton(
              text: "Upload",
            ),
            Expanded(child: Material(
              elevation: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                  color: Color(0xfff6f7f9)
                ),
              ),
            ))
          ],
        ),
      )
    );
  }
}
