import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utilities/appC.dart';

class PopupWithIcons {
  PopupWithIcons._();
  static void show(
      BuildContext context,
      TapDownDetails? details,
      {IconData icon1 = Icons.edit_outlined,
        IconData icon2 = Icons.delete_outline,
        Color color1 = AppC.blue,
        Color color2 = AppC.redAccent,
        VoidCallback? onIcon1Tap,
        VoidCallback? onIcon2Tap}) async {

    if (details != null) {
      await showMenu<dynamic>(
        elevation: 5,
        color: Colors.white,
        context: context,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        menuPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 70.sp),
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
                // IconButton(onPressed: onEditTap, icon: Icon(Icons.edit_outlined,color: AppC.blue,size: 16.sp,)),
                GestureDetector(
                  onTap: () {
                    onIcon1Tap?.call();
                    Navigator.of(context).pop();
                  },
                  child:   Icon(
                    icon1,
                    color: color1,
                    //size: 16.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onIcon2Tap?.call();
                  },
                  child:  Icon(
                    icon2,
                    color: color2,
                    //size: 16.sp,
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
