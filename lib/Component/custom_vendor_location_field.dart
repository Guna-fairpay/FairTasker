import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVendorLocationField extends StatelessWidget {
  final ValueNotifier<Map<String, dynamic>>? selectedVLocations;
  final List<Map<String, dynamic>> vendorsList, locationsList;
  CustomVendorLocationField({super.key, this.selectedVLocations, required this.vendorsList, required this.locationsList}) {
    _prepareData();
    _checkSelectedVData();
  }
  final ValueNotifier<List<Map<String, dynamic>>> commonList =
  ValueNotifier([]);

  final ValueNotifier<Map<String, dynamic>> selectedList =
  ValueNotifier({});

  void _prepareData() {
    var persons = locationsList
        .map((element) =>
    {
      "id": element['id'],
      "name": element['name'],
      "type": "location",
      "partNumber": 3,
      "value": element
    })
        .toList();
    var vehicles = vendorsList
        .map((element) =>
    {
      "id": element['id'],
      "name": element['name'],
      "type": "vendor",
      "partNumber": 3,
      "value": element
    })
        .toList();
    commonList.value = [...persons, ...vehicles];
  }

  void _checkSelectedVData() {
    selectedVLocations?.addListener(() {
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
              suggestions: value,
              labelText: "Vendor/Location",
              itemAsString: (item) => item['name'].toString(),
              suggestionState: Suggestion.hidden,
              onSuggestionTap: _onSuggested,
            ));
  }

  void _onSuggested(Map<String, dynamic> val) {
    selectedVLocations?.value = val;
    selectedList.value = (selectedVLocations?.value ?? {});
    selectedList.notifyListeners();
    selectedVLocations?.notifyListeners();
  }
}
