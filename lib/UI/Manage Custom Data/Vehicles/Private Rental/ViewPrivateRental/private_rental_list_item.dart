import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivateRentalListItem extends TableRow {
  final Map<String, dynamic> vehicle;
  final VoidCallback? onEdit, onDelete, onAdd;
  const PrivateRentalListItem({super.key, required this.vehicle, this.onEdit, this.onDelete, this.onAdd});

  @override
  List<Widget> get children => [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Utils.getText(vehicle['vehicle_name'] ?? '', size: 12.sp),
            )),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Utils.getText(
                  (vehicle['customer'].toString().isNotNullOrEmpty && (vehicle['customer'] is Map) )
                      ? "${vehicle['customer']?['first_name'] ?? ''} ${vehicle['customer']?['last_name'] ?? ''}"
                      : "",
                  size: 12.sp),
            )),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
          child: IntrinsicWidth(
            child: Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: (vehicle['rental'] == null)
                  ? [
                      InkWell(
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusXLarge),
                        onTap: onAdd,
                        child: Padding(
                          padding: 3.sp.padding,
                          child: const Icon(
                            Icons.add,
                            color: AppC.green,
                          ),
                        ),
                      )
                    ]
                  : [
                      InkWell(
                        onTap: onEdit,
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusXLarge),
                        child: Padding(
                          padding: 3.sp.padding,
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppC.appColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onDelete,
                        borderRadius:
                            BorderRadius.circular(Num.borderRadiusXLarge),
                        child: Padding(
                          padding: 3.sp.padding,
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppC.redAccent,
                          ),
                        ),
                      ),
                    ],
            ),
          ),
        )
      ];
}
