import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseFilterPopup {
  ExpenseFilterPopup._();
  static void show(
      {
        required BuildContext context,
        TapDownDetails? details,
        List<Map<String, dynamic>>? model,
        VoidCallback? onIcon1Tap,
        VoidCallback? onIcon2Tap}) async {

    if (details != null) {
      await showMenu<dynamic>(
        elevation: 5,
        color: Colors.white,
        context: context,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        menuPadding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 140),
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        items: [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: ()=> context.pop(), icon: const Icon(Icons.close_rounded, color: AppC.redAccent,)),
                Utils.getText('All'),
                Container(
                  constraints: BoxConstraints(maxHeight: 200.sp),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                      itemBuilder: (context, index) => Text("Index $index")),
                )
                // SizedBox.fromSize(
                //   size: Size.fromHeight(60.sp),
                //   child: ListView.builder(
                //     itemCount: model?.length ?? 0,
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) => Utils.getText(model?[index]['category_name']) ),
                // )
              ],
            ),
          ),
        ],
      );
    }
  }
}
