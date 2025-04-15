
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utilities/appC.dart';

class PopupWithIcons {
  static Future<void> show(
      BuildContext context,
      TapDownDetails? details,
      VoidCallback onEditTap,
      VoidCallback onDeleteTap
      ) async {

    if (details != null) {
      await showMenu(
        elevation: 5,
        color: Colors.white,
        context: context,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        menuPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 60.sp),
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        items: [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.shrink(),
                GestureDetector(
                  onTap: () {
                    onEditTap();
                    Navigator.of(context).pop();
                  },
                  child:  Icon(
                    Icons.edit_outlined,
                    color: AppC.blue,
                    size: 16.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onDeleteTap();
                    Navigator.of(context).pop();
                  },
                  child:  Icon(
                    Icons.delete_outline,
                    color: AppC.redAccent,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
