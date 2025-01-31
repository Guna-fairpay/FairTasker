import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class VehicleHistoryPop {

  VehicleHistoryPop._();

  static final VehicleHistoryPop instance = VehicleHistoryPop._();

  void show  (BuildContext context,
      {required Map<String, dynamic> data,
        required TapDownDetails? details,
        required String compare,
        required String display}) async {
    List<dynamic> selectedPartsList;

    // Parse the 'parts' data
    if (data[compare] is String) {
      try {
        selectedPartsList = List<String>.from(jsonDecode(data[compare]));
      } catch (e) {
        selectedPartsList = [];
      }
    } else if (data[compare] is List) {
      selectedPartsList = data[compare];
    } else {
      selectedPartsList = [];
    }

    if (details != null) {
     await showMenu(
        elevation: 5,
        color: AppC.white,
        context: context,
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx - 65,
          details.globalPosition.dy,
        ),
        items: [
          PopupMenuItem(
            child: Wrap(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceEvenly,
              children: List<Widget>.generate(
                selectedPartsList.length,
                    (int idx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Chip(
                      side: const BorderSide(color: AppC.trans),
                      backgroundColor: AppC.green.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utils.getText(
                            "${selectedPartsList[idx]?[display]}",
                            color: AppC.text,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      );
    }
  }

}
