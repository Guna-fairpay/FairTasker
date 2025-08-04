import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/core/app/extension/relativerect_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchPopupMenu {
  BranchPopupMenu._();

  static void show(BuildContext context, {Offset? offset, void Function(Map<String, dynamic> value)? onChanged}) async {
    Utils.hideKeyboard(context);
    var response = await showMenu(
        context: context,
        color: Colors.white,
        position: (offset != null) ? (offset.toRelativeRect(context: context)) : const RelativeRect.fromLTRB(10, 50, 0, 50),
        items: getIt<CommonService>()
            .branchList
            .map((e) => PopupMenuItem<Map<String, dynamic>>(
                  value: e,
                  child: Container(
                    margin:  EdgeInsets.symmetric(
                        vertical: 2.h), // Reduced vertical margin
                    decoration: BoxDecoration(
                      color:
                          (e['id'] == Session.of.getInt(Str.branchIdPrefText))
                              ? Colors.blue
                              : Colors.white,
                      borderRadius:
                          BorderRadius.circular(6), // Smaller border radius
                      boxShadow:
                          (e['id'] == Session.of.getInt(Str.branchIdPrefText))
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : [],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 4.h, horizontal: 8.w), // Reduced padding
                    child: Center(
                      child: Text(
                        "${e['city'] ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.spMin, // Smaller font size
                          color: (e['id'] ==
                                  Session.of.getInt(Str.branchIdPrefText))
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList());
    if (response != null) {
      onChanged?.call(response);
      Session.of.set(Str.branchIdPrefText, response['id']);
      Session.of.set(Str.branchNamePrefText, response['city']);
      Utils.setIntPreference(Str.branchIdPrefText, response['id']);
      getIt<CommonService>().updateBranch..value = true..notifyListeners();
      FBroadcast.instance().broadcast(Str.branchChange, value: true);
    }
    Utils.hideKeyboard(context);
  }
}
