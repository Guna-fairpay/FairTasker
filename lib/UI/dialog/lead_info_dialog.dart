import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeadInfoDialog {
  LeadInfoDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(
        context: context,
        builder: (context) => _LeadInfoDialogView(model: model),
        barrierDismissible: true,
        useSafeArea: true);
  }
}

class _LeadInfoDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _LeadInfoDialogView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 10.spMin.padding,
      titlePadding: 10.spMin.padding,
      insetPadding: 10.spMin.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title:
        Utils.getText("Booking Info", size: 17.spMin, weight: FontWeight.bold),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: Icon(Icons.close_rounded, size: 18.spMin),
        ),
      ),
      content: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: 10.spMin.padding,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(2),
          },
          border: TableBorder.all(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
              width: Num.borderWidthThinField,
              color: AppC.borderColor),
          children: [
            TableRow(
                children: [
                  TableCell(
                      child: Padding(
                        padding: 10.padding,
                        child: Utils.getText("Name",
                            size: 12.spMin,
                            weight: FontWeight.bold,
                            overFlow: TextOverflow.ellipsis),
                      )),
                  TableCell(
                      child: Padding(
                        padding: 10.padding,
                        child: Utils.getText(
                            model?['lead']?['customer_name'] ?? '',
                            size: 12.spMin,
                            weight: FontWeight.normal,
                            overFlow: TextOverflow.ellipsis),
                      )),
                ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Email",
                        size: 12.spMin,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        model?['lead']?['email'] ?? '',
                        size: 12.spMin,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Phone",
                        size: 12.spMin,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        model?['lead']?['contact_number'] ?? '',
                        size: 12.spMin,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
