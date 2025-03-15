import 'package:fairpytasker/UI/Finance/Expense/Component/add_new_subcategory_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class CategorySubcategoryDialog {
  CategorySubcategoryDialog._();

  static void show(
      BuildContext context, {
        String? vehicleName,
      }) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => _CategorySubcategoryDialog(
          vehicleName: vehicleName,
        ));
  }
}

class _CategorySubcategoryDialog extends StatelessWidget {
  final String? vehicleName;
  const _CategorySubcategoryDialog({required this.vehicleName});

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
            Utils.getText(
              vehicleName ?? '',
              weight: FontWeight.w700,
            ),
            Utils.getText('Category', weight: FontWeight.w300),
            Utils.dropdownBox('Select Category', [], (value) {},
                labelKey: 'name'),
            Utils.getText('Sub Category', weight: FontWeight.w300),
            Utils.dropdownBox('Select SubCategory', [], (value) {},
                labelKey: 'name'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () => AddNewSubcategoryDialog.show(context),
                    child: Utils.getText('+ Add New Sub Category', color: AppC.appColor)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Utils.getElevatedButton(text: 'Save', () {}),
                Utils.getElevatedButton(text: 'Cancel', () => Navigator.pop(context), bgColor: AppC.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
