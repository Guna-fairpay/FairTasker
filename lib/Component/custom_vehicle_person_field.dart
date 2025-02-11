import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVehiclePersonField extends StatelessWidget {
  final ValueNotifier<dynamic>? selectedVPersons;
  final List<dynamic> vehiclesList, personsList;
  final List<Map<String, dynamic>>? selected;
  final void Function(dynamic val)? onSelected;
  final TextEditingController? controller;

  CustomVehiclePersonField(
      {super.key,
      this.selectedVPersons,
      required this.vehiclesList,
      this.selected,
      this.onSelected,
      required this.personsList,
      this.controller}) {
    _prepareData();
    _checkSelectedVData();
  }

  final ValueNotifier<List<Map<String, dynamic>>> commonList =
      ValueNotifier([]);

  final ValueNotifier<List<Map<String, dynamic>>> selectedList =
      ValueNotifier([]);

  void _prepareData() {
    var persons = personsList
        .map((element) => {
              "id": element['id'],
              "name": [element['first_name'], element['last_name']].join(" "),
              "type": "person",
              "partNumber": 2,
              "value": element
            })
        .toList();
    var vehicles = vehiclesList
        .map((element) => {
              "id": element['id'],
              "name": element['vehicle_name'],
              "type": "vehicles",
              "subname": "\t(${element['vehicle_number']})",
              "partNumber": 2,
              "value": element
            })
        .toList();
    commonList.value = [...vehicles, ...persons];
  }

  void _checkSelectedVData() {
    if ((selected != null) ) {
      selectedList.value = (selected as List<Map<String, dynamic>>?) ?? [];
      selectedList.notifyListeners();
    }
    if (selectedVPersons?.value.isNotEmpty ?? false) {
      selectedList.value = (selectedVPersons?.value ?? []);
    }
    selectedVPersons?.addListener(() {
      var value = selectedVPersons?.value;
      selectedList.value = (value ?? []);
      selectedList.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: selectedList.value.isEmpty ? null : const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppC.borderColor, width: Num.borderWidthThinField),
            right:
                BorderSide(color: AppC.borderColor, width: Num.borderWidthThinField),
            left:
                BorderSide(color: AppC.borderColor, width: Num.borderWidthThinField),
          ),
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: selectedList.value.isEmpty ? 0 : 5,
        children: [
          ValueListenableBuilder(
              valueListenable: selectedList,
              builder: (context, value, child) {
                return Wrap(
                  children: List<Widget>.generate(
                    value.length,
                    (int idx) {
                      var model = value[idx];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Chip(
                            onDeleted: () => _onDelete(model),
                            side: const BorderSide(color: AppC.trans),
                            deleteIcon: const Icon(
                              Icons.close,
                              color: AppC.red,
                              size: 18,
                            ),
                            backgroundColor: const Color(0xffb5d2bb),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            // side: BorderSide(),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Utils.getText(model['name'] ?? '',
                                    color: AppC.text),
                              ],
                            ),
                          ));
                    },
                  ).toList(),
                );
              }),
          ValueListenableBuilder(
              valueListenable: commonList,
              builder: (context, value, child) =>
                  CustomSearchField<Map<String, dynamic>>(
                    controller: controller,
                    suggestions: value,
                    autoControllerClear: true,
                    isDense: true,
                    style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                    labelText: "Vehicle/Person",
                    itemAsString: (item) => formatMapData(item),
                    suggestionState: Suggestion.hidden,
                    onSuggestionTap: _onSuggested,
                  )),
        ],
      ),
    );
  }

  void _onDelete(Map<String, dynamic> val) {
    selectedVPersons?.value.remove(val);
    selectedList.value = (selectedVPersons?.value ?? []);
    selectedList.notifyListeners();
    selectedVPersons?.notifyListeners();
    onSelected?.call(selectedList.value);
  }

  void _onSuggested(Map<String, dynamic> val) {
    List<Map<String, dynamic>> data = selectedVPersons?.value ?? [];
    if (val['type'] == "person") {
      data = [val];
    } else if (val['type'] == "vehicles") {
      data.removeWhere((element) =>
          element.containsKey('type') && element['type'] == "person");
      data = [
        ...(data ?? []),
        ...[val]
      ];
    }
    selectedList.value = (data);
    onSelected?.call(selectedList.value);
    selectedVPersons?.value = selectedList;
    selectedList.notifyListeners();
    selectedVPersons?.notifyListeners();
  }

  String formatMapData(Map<String, dynamic> e) {
    return (e.containsKey("subname")
        ? "${e['name']}${e['subname']}"
        : e['name'].toString());
  }

  bool isExist(Map<String, dynamic> data, String input) {
    if (data.containsKey("subname")) {
      return data['name']
              .toString()
              .toLowerCase()
              .contains(input.toLowerCase()) ||
          data['subname']
              .toString()
              .toLowerCase()
              .contains(input.toLowerCase());
    } else {
      return data['name']
          .toString()
          .toLowerCase()
          .contains(input.toLowerCase());
    }
  }
}
