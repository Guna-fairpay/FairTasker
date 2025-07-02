
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utilities/appC.dart';

class ResourceSelection {
  static Future<void> showResourceSelection(
      BuildContext context,
      TapDownDetails? details,
      List<dynamic> resourceList,
      List<String> selectedValues,
      Function(List<String> val, List<dynamic> name) onSelectionChanged,
      ) async {
    ValueNotifier<List<String>> selectedIdsNotifier = ValueNotifier(List.from(selectedValues));
    final ScrollController _scrollController = ScrollController();
    if (details != null) {

      await showMenu(

        elevation: 5,
        color: Colors.white,
        context: context,
        constraints: const BoxConstraints.tightFor(width: 70),
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        items: [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ValueListenableBuilder<List<String>>(
                valueListenable: selectedIdsNotifier,
                builder: (context, value, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Utils.dismissKeyboard(context);
                        },
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200.spMin),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 3.spMin,
                        radius: const Radius.circular(Num.borderRadiusLarge),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: resourceList.length,
                          itemBuilder: (context, index) {
                            final user = resourceList[index];
                            final resourceId =
                            resourceList[index]['id'].toString();
                            final isSelected = value.contains(resourceId);
                            List<dynamic> name = resourceList
                                .where((element) => selectedValues.contains(element['id'].toString()))
                                .toList();
                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  // if (name.length <= 1 && value.length <= 1) {
                                  //   Toaster.showWarning("Cannot proceed without a resource selected");
                                  //   return;
                                  // }
                                  selectedIdsNotifier.value.remove(resourceId);
                                  name.remove(resourceList[index]);
                                } else {
                                  selectedIdsNotifier.value.add(resourceId);
                                  name.add(resourceList[index]);
                                }
                                selectedIdsNotifier.notifyListeners();
                                var count = selectedIdsNotifier.value.length;
                                if (count > 0) {
                                  Console.of.log("EMITTING");
                                  onSelectionChanged(
                                      selectedIdsNotifier.value, name);
                                } else {
                                  Console.of.log("NOT EMITTING");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0,right: 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppC.appColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 3.0,
                                  ),
                                  child: Utils.getText(
                                    <String>[(user?['first_name'] ?? ""), (user?['last_name'] ?? "")].toInitial,
                                    weight: FontWeight.bold,
                                    color: isSelected ? AppC.white : AppC.appColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ).whenComplete(() => Utils.dismissKeyboard(context));
      Utils.dismissKeyboard(context);
    }
  }
}
