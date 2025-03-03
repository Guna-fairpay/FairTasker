import 'dart:developer';

import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVendorLocationField extends StatelessWidget {
  final ValueNotifier<dynamic>? selectedVLocations;
  final List<dynamic> vendorsList, locationsList;
  final TextEditingController? controller;
  final Map<int, dynamic>? selected;
  final void Function(dynamic val)? onSelected;

  CustomVendorLocationField(
      {super.key,
      this.selectedVLocations,
      required this.vendorsList,
      required this.locationsList,
      this.selected,
      this.onSelected,
      this.controller}) {
    _prepareData();
    _checkSelectedVData();
  }

  final ValueNotifier<List<Map<String, dynamic>>> commonList =
      ValueNotifier([]);

  final ValueNotifier<Map<String, dynamic>> selectedList = ValueNotifier({});

  void _prepareData() {
    var persons = locationsList
        .map((element) => {
              "id": element['id'],
              "name": element['name'],
              "type": "location",
              "partNumber": 3,
              "value": element
            })
        .toList();
    var vehicles = vendorsList
        .map((element) => {
              "id": element['id'],
              "name": element['name'],
              "type": "vendor",
              "partNumber": 3,
              "value": element
            })
        .toList();
    commonList.value = [...vehicles, ...persons];
  }

  void _checkSelectedVData() {
    if ((selected != null) && (selected![3] != null)) {
      selectedList.value = selected![3];
      controller?.text = "${selectedList.value['name']}";
      selectedList.notifyListeners();
    }
    selectedVLocations?.addListener(() {
      log("selectedVLocations: ${selectedVLocations?.value}",
          name: "checkSelectedVData");
      var value = selectedVLocations?.value;
      selectedList.value = (value ?? {});
      selectedList.notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: commonList,
        builder: (context, value, child) =>
            CustomSearchField<Map<String, dynamic>>(
              controller: controller,
              suggestions: value,
              isDense: true,
              style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
              labelText: "Vendor/Location",
              itemAsString: (item) => item['name'].toString(),
              suggestionState: Suggestion.hidden,
              onSuggestionTap: _onSuggested,
            ));
  }

  void _onSuggested(Map<String, dynamic> val) {
    var data  = val;
    selectedVLocations?.value = data;
    selectedList.value = data;
    selectedList.notifyListeners();
    selectedVLocations?.notifyListeners();
    onSelected?.call(selectedList.value);
  }
}
