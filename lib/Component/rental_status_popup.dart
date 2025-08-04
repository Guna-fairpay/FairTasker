
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'success_button.dart';
import '../Utilities/Utils.dart';
import '../Utilities/appC.dart';
import '../Utilities/num.dart';

class RentalStatusPopup {
  RentalStatusPopup._();
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _RentalStatusPopupView(),
    );
  }
}

class _RentalStatusPopupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)
      ),
      backgroundColor: AppC.white,
      insetPadding: 10.padding.copyWith(top: 50),
      titlePadding: EdgeInsets.zero,
      contentPadding: 15.padding,
      title: ListTile(leading: GestureDetector(
        onTap: context.popDialog,
        child: const Icon(Icons.close),
      ),
        dense: true,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getText("Do you want to move the status to ?",weight: FontWeight.bold,size: 14.sp),
            Row(
              spacing: 10,
              children: [
                Utils.getCircleCheckWidget((){}, true, "Rental"),
                Utils.getCircleCheckWidget((){}, false, "PreSale"),
              ],
            ),
            Utils.getText("Vehicle id :",weight: FontWeight.bold,),
            Utils.getTextFormField("Vehicle id", TextEditingController()),
            const Row(
              spacing: 10,
              children: [
                SuccessButton(text: "Confirm",),
                SuccessButton(text: "Cancel", backgroundColor: AppC.red,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}