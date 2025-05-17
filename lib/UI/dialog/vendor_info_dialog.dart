import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorInfoDialog {
  VendorInfoDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(
        context: context,
        builder: (context) => _VendorInfoDialogView(model: model),
        barrierDismissible: true,
        useSafeArea: true);
  }
}

class _VendorInfoDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _VendorInfoDialogView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 10.sp.padding,
      titlePadding: 10.sp.padding,
      insetPadding: 10.sp.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title:
            Utils.getText("Vendor Info", size: 17.sp, weight: FontWeight.bold),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: Icon(Icons.close_rounded, size: 18.sp),
        ),
      ),
      content: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: 10.sp.padding,
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
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['name'] ?? ""}",
                        size: 12.sp,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Vendor Type",
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['vendor_type']?['name'] ?? ""}",
                        size: 12.sp,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Phone",
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['phone'] ?? ""}",
                        size: 12.sp,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Address",
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableRowInkWell(
                onTap: () async {
                  var value = model?['display']?['vendor']?['address'] ?? "";
                  final Uri mapsUri = Uri(
                    scheme: 'https',
                    host: 'www.google.com',
                    path: '/maps/search/$value',
                    queryParameters: {'q': value},
                  );
                  Utils.openURL(mapsUri.toString());
                },
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['address'] ?? ""}",
                        size: 12.sp,
                        color: AppC.appColor,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.ellipsis),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Expertise",
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['expertise'] ?? ""}",
                        size: 12.sp,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.visible),
                  )),
            ]),
            TableRow(children: [
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText("Description",
                        size: 12.sp,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.visible),
                  )),
              TableCell(
                  child: Padding(
                    padding: 10.padding,
                    child: Utils.getText(
                        "${model?['display']?['vendor']?['description'] ?? ""}",
                        size: 12.sp,
                        weight: FontWeight.normal,
                        overFlow: TextOverflow.visible),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
