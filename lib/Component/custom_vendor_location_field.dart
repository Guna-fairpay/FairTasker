import 'dart:developer';

import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/location_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_add_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
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

  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  List<Map<String, dynamic>> unfilteredList = [];
  final ValueNotifier<List<Map<String, dynamic>>> commonList =
      ValueNotifier([]);

  final ValueNotifier<Map<String, dynamic>> selectedList = ValueNotifier({});

  void _prepareData() {
    unfilteredList = CustomSearchDataConverter.convertVLocation(vendors: vendorsList, locations: locationsList);
    commonList.value = unfilteredList;
  }

  void _checkSelectedVData() {
    if ((selected != null) && (selected![3] != null)) {
      selectedList.value = selected![3];
      controller?.text = "${selectedList.value['name']}";
      selectedList.notifyListeners();
      log("selectedList: ${selectedList.value['name']}", name: "checkSelectedVData");
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
      valueListenable: showEmptyNotifier,
      builder: (context, value, child) => CustomAutoSearchField(
          controller: controller!,
          labelText: "Vendor/Location",
          onSelected: _onSuggested,
          showEmptyWidget: value,
          // autoClear: true,
          onEmptyWidgetTapDown: (details) => SimplePopUpMenu.instance.show(context, position: details.globalPosition, items: ["Vendor", "Location"], onTap: (item) {
            item == "Vendor" ? context.push(const VendorAddUI()) : context.push(const LocationAddUI());
          },),
          itemAsString: (item) => item['name'].toString(),
          optionsBuilder: (textEditingValue) =>
              onSearch(textEditingValue)),
    );
    /*return ValueListenableBuilder(
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
            ));*/
  }

  Future<Iterable<Map<String, dynamic>>> onSearch(
      TextEditingValue textEditingValue) async {
    var val = textEditingValue.text.toLowerCase();
    if (val.trim().isEmpty) {
      return [];
    }
    var list =
    unfilteredList.where((element) => element['name'].toString().toLowerCase().contains(val)).toList();
    showEmptyNotifier.value = list.isEmpty;
    return list;
  }

  void _onSuggested(Map<String, dynamic> val) {
    var data  = val;
    selectedVLocations?.value = data;
    selectedList.value = data;
    controller?.text = data['name'].toString();
    selectedList.notifyListeners();
    selectedVLocations?.notifyListeners();
    onSelected?.call(selectedList.value);
  }
}
