import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'custom_date_time_picker.dart';

class TransportCarPopup {
  TransportCarPopup._();
  static void show(BuildContext context, Map<String, dynamic>? model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TransportCarPopView(),
    );
  }
}

class _TransportCarPopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        alignment: Alignment.topCenter,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
        backgroundColor: AppC.white,
        insetPadding: 10.sp.padding,
        titlePadding: EdgeInsets.zero,
        contentPadding: 5.sp.padding.copyWith(left: 20.sp, right: 20.sp, bottom: 20.sp),
        title: ListTile(
          dense: true,
          title: Utils.getText("Next Task",),
          trailing: IconButton(
              onPressed: () =>context.pop(),
              icon: const Icon(Icons.close_outlined)),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Utils.getText("Next Task",
                //         weight: FontWeight.bold, size: 14.sp),
                //     IconButton(
                //         onPressed: () =>context.pop(),
                //         icon: const Icon(Icons.close_outlined))
                //   ],
                // ),
                //MultiDropdown<models>(items: [],),
                Utils.dropdownBox("Select", [], (val) {}, labelKey: "car"),
                Utils.getTextFormField("Custom Task", TextEditingController()),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                        child: CustomDateTimePicker<DateTime>(
                      controller: TextEditingController(),
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 15, color: context.theme.hintColor),
                    )),
                    Expanded(
                        child: CustomDateTimePicker<TimeOfDay>(
                      use24HourFormat: true,
                      controller: TextEditingController(),
                      suffixIcon: Icon(Icons.access_time_rounded,
                          size: 15, color: context.theme.hintColor),
                    )),
                  ],
                ),
                Utils.dropdownBox("Select", [], (val) {}, labelKey: "person"),
                Utils.getTextFormField(
                    "Vendor / Location", TextEditingController()),
                Utils.getTextFormField("Notes", TextEditingController()),
                const Row(
                  spacing: 20,
                  children: [
                    SuccessButton(
                      text: "Save",
                    ),
                    SuccessButton(
                      text: "Ignore",
                      backgroundColor: AppC.red,

                    )
                  ],
                ),
              ]
          ),
        )
    );
  }
}
