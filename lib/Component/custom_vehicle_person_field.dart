import 'dart:developer';

import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVehiclePersonField extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>>? selectedVPersons;
  final List<Map<String, dynamic>> vehiclesList, personsList;

  CustomVehiclePersonField({super.key,
    this.selectedVPersons,
    required this.vehiclesList,
    required this.personsList}) {
    _prepareData();
    _checkSelectedVData();
  }

  final ValueNotifier<List<Map<String, dynamic>>> commonList =
  ValueNotifier([]);

  final ValueNotifier<List<Map<String, dynamic>>> selectedList =
  ValueNotifier([]);

  void _prepareData() {
    var persons = personsList
        .map((element) =>
    {
      "id": element['id'],
      "name": [element['first_name'], element['last_name']].join(" "),
      "type": "person",
      "partNumber": 2,
      "value": element
    })
        .toList();
    var vehicles = vehiclesList
        .map((element) =>
    {
      "id": element['id'],
      "name": element['vehicle_name'],
      "type": "vehicles",
      "partNumber": 2,
      "value": element
    })
        .toList();
    commonList.value = [...persons, ...vehicles];
  }

  void _checkSelectedVData() {
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
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppC.fieldBase,
              width: Num.borderWidthField),
            right: BorderSide(color: AppC.fieldBase,
                width: Num.borderWidthField),
            left: BorderSide(color: AppC.fieldBase,
                width: Num.borderWidthField),
          ),
          borderRadius:
          const BorderRadius.all(Radius.circular(6))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
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
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  Utils.getText(
                                      model['name'] ?? '',
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
                    suggestions: value,
                    labelText: "Vehicle/Person",
                    itemAsString: (item) => item['name'].toString(),
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
  }

  void _onSuggested(Map<String, dynamic> val) {
    if (val['type'] == "person") {
      selectedVPersons?.value = [val];
    } else if (val['type'] == "vehicles") {
      selectedVPersons?.value.removeWhere((element) => element.containsKey('type') && element['type'] == "person");
      selectedVPersons?.value = [...(selectedVPersons?.value ?? []), ...[val]];
    }
    selectedList.value = (selectedVPersons?.value ?? []);
    selectedList.notifyListeners();
    selectedVPersons?.notifyListeners();
  }
}