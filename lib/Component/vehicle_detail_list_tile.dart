import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleDetailListTile extends StatelessWidget {
  final String label;
  final String value;
  const VehicleDetailListTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      minTileHeight: 0,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      title: Utils.getText(label, size: 12.sp, weight: FontWeight.bold),
      subtitle: Utils.getText(value, size: 12.sp, weight: FontWeight.normal),
    );
  }
}
