import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/relativerect_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceSelectionPopup {
  ResourceSelectionPopup._();

  static void show(BuildContext context, {required Offset offset, List<dynamic>? selectedResourceIds, void Function(List<Map<String, dynamic>> value)? onChanged}) async {
    int? branchId = Session.of.getInt(Str.branchIdPrefText);
    bool isAdmin = getIt<CommonService>().isAdmin;
    var acceptDepartmentIds = [isAdmin ? "8" : "", "7"];
    acceptDepartmentIds.removeWhere((element) => element.isNullOrEmpty);
    var resources = await getIt<CommonService>().getResources();
    var listing = List<Map<String, dynamic>>.from(resources);
    listing.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['branch_id'].toString().isNullOrEmpty) || ((element['branch_id'] != branchId) && (!acceptDepartmentIds.contains(element['department'])) && (element['id'] != 3)));
    List<Map<String, dynamic>> selected = listing.where((element) => selectedResourceIds?.contains(element['id']) ?? false).toList();
    ValueNotifier<List<Map<String, dynamic>>> selection = ValueNotifier(selected);
    await showMenu(
        context: context,
        elevation: 5,
        color: Colors.white,
        position: offset.toRelativeRect(),
        constraints: const BoxConstraints.tightFor(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        menuPadding: EdgeInsets.zero,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
        items: [
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(valueListenable: selection, builder: (context, value, child) => Column(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                            onPressed: () {
                              onChanged?.call(value);
                              context.pop();
                            },
                            icon: const Icon(Icons.save_rounded),
                            color: AppC.green),
                        const Spacer(),
                        IconButton(
                            onPressed: context.pop,
                            icon: const Icon(Icons.close_rounded),
                            color: AppC.red),
                      ],
                    ),
                  ),
                  if (listing.isNotEmpty)
                    SizedBox(
                      width: 140.sp,
                      height: 200.sp,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 5.height,
                        itemBuilder: (context, index) {
                          var model = listing[index];
                          return ListTile(
                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
                            title: Text(
                              "${model['first_name'] ?? ""} ${model['last_name'] ?? ""}",
                            ),
                            titleTextStyle: context.textTheme.labelLarge
                                ?.copyWith(color: AppC.appColor),
                            dense: true,
                            minTileHeight: 0,
                            selectedTileColor: AppC.appColor,
                            selectedColor: Colors.white,
                            selected: value.map((e) => e['id']).contains(model['id']),
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            horizontalTitleGap: 0,
                            onTap: () {
                              if (selection.value.contains(model)) {
                                selection.value.remove(model);
                              } else {
                                selection.value.add(model);
                              }
                              selection.notifyListeners();
                            },
                          );
                        },
                        itemCount: listing.length,
                      ),
                    )
                ],
              )))
        ]);
  }
}
