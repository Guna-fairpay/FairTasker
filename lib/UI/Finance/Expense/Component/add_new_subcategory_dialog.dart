import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class AddNewSubcategoryDialog {
  AddNewSubcategoryDialog._();

  static void show(
      BuildContext context, {
        String? vehicleName,
      }) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => _AddNewSubcategoryDialog());
  }
}

class _AddNewSubcategoryDialog extends StatelessWidget {
  const _AddNewSubcategoryDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppC.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.height,
              Utils.getText(
                'Add New SubCategory',
                weight: FontWeight.bold,
              ),
            Utils.getTextFormField('Name', TextEditingController()),
            Utils.dropdownBox('Select Cohort', [], (value) {},
                labelKey: 'name'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Utils.getElevatedButton(text: 'Save', () {}),
                Utils.getElevatedButton(
                    text: 'Cancel',
                        () => Navigator.pop(context),
                  bgColor: AppC.redAccent
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
