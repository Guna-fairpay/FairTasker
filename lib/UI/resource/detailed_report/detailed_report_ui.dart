import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/coumn_tile.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailedReportUi extends StatelessWidget {
  const DetailedReportUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: "PERSON NAME",
        automaticallyImplyleading: false,
        onClose: () {

        },
      ),
      body: Column(
        spacing: 10.spMin,
        children: [
          Padding(
            padding: 10.spMin.padding,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnTile(
                  label: "CheckIn",
                  title: "04:17 AM",
                ),
                ColumnTile(
                  label: "CheckOut",
                  title: "04:16 AM",
                ),
                ColumnTile(
                  label: "Active Hours",
                  title: "00:30",
                ),
                ColumnTile(
                  label: "Total Hours",
                  title: "00:00",
                ),
              ],
            ),
          ),
          Padding(
            padding: 10.spMin.horizontalPadding,
            child: Container(
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(bottom: const BorderSide(color: AppC.borderColor, width: Num.borderWidthButton))
              ),
              child: const Row(
                children: [
                  CustomTabButton(buttonText: "By Task", value: 0, selectedValue: 0),
                  CustomTabButton(buttonText: "By Day", value: 1, selectedValue: 0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
