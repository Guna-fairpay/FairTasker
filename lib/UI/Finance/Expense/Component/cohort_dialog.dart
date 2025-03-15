import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class CohortDialog {
  CohortDialog._();

  static void show(
    BuildContext context, {
    String? vehicleName,
  }) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => _CohortDialog(
              vehicleName: vehicleName,
            ));
  }
}

class _CohortDialog extends StatelessWidget {
  final String? vehicleName;
  const _CohortDialog({required this.vehicleName});

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
            Utils.getText('Cohort', weight: FontWeight.w300),
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
                    bgColor: AppC.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
