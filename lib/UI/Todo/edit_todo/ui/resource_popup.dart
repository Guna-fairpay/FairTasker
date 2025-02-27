
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:flutter/material.dart';
import '../../../../utilities/appC.dart';

class ResourceSelection {
  static Future<void> showResourceSelection(
      BuildContext context,
      TapDownDetails? details,
      List<dynamic> resourceList,
      List<String> selectedValues,
      Function(List<String> val) onSelectionChanged,
      ) async {

    ValueNotifier<List<String>> selectedIdsNotifier = ValueNotifier(selectedValues);

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
              child: SizedBox(
                width: 70,
                height: 200,
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: selectedIdsNotifier,
                  builder: (context, value, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Icon(
                                Icons.close_sharp,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: resourceList.length,
                            itemBuilder: (context, index) {
                              final user = resourceList[index];
                              final resourceId =
                              resourceList[index]['id'].toString();
                              final isSelected = value.contains(resourceId);

                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    selectedIdsNotifier.value.remove(resourceId);
                                  } else {
                                    selectedIdsNotifier.value.add(resourceId);
                                  }
                                  selectedIdsNotifier.notifyListeners();
                                  onSelectionChanged(selectedIdsNotifier.value);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Container(
                                    color: isSelected ? AppC.appColor : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 2.0,
                                    ),
                                    child: Utils.getText(
                                      '${user['first_name'][0] ?? ''}${user['last_name'][0] ?? ''}',
                                      size: 12,
                                      weight: FontWeight.bold,
                                      color: isSelected ? AppC.white : AppC.appColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
