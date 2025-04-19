import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/location_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/View/location_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_add_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

import '../UI/Manage Custom Data/Vendor/vendor_ui/vendor_view.dart';

class CustomVendorLocationField extends StatelessWidget {
  final List<dynamic> vendorsList, locationsList;
  final TextEditingController? controller;
  final Map<int, dynamic>? selected;
  final void Function(dynamic val)? onSelected, onCleared;

  CustomVendorLocationField(
      {super.key,
      required this.vendorsList,
      required this.locationsList,
      this.selected,
      this.onSelected,
      this.onCleared,
      this.controller}) {
    _prepareData();
    _checkSelectedVData();
  }

  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  List<Map<String, dynamic>> unfilteredList = [];

  Map<String, dynamic> selectedData = {};

  void _prepareData() {
    Console.of.warning("_prepareData", name: "CustomVendorLocationField");
    unfilteredList = CustomSearchDataConverter.convertVLocation(vendors: vendorsList, locations: locationsList);
  }

  void _checkSelectedVData() async {
    Console.of.warning("_checkSelectedVData ${(selected?.containsKey(3) ?? false) && (selectedData != (selected?[3]))}", name: "CustomVendorLocationField");
    Console.of.warning("_checkSelectedVData ${selectedData} ${selectedData[3]}", name: "CustomVendorLocationField");
    if ((selected?.containsKey(3) ?? false) && (Map.from(selected?[3]).isNotEmpty) && (selectedData != (selected?[3]))) {
      selectedData = selected?[3] ?? {};
      var name = selectedData['name'];
      var controllerName = controller?.text;
      if ((name != controllerName) && (name != null)) {
        controller?.clear();
        await Future.delayed(Durations.medium3);
        controller?.text = name ?? "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showEmptyNotifier,
      builder: (context, value, child) => CustomAutoSearchField(
          controller: controller!,
          labelText: "Vendor/Location",
          onChanged: (value) => (value.isNullOrEmpty && (selected != null)) ? onCleared?.call(selected) : null,
          onSelected: _onSuggested,
          showEmptyWidget: value,
          // autoClear: true,

          onEmptyWidgetTapDown: (details) => SimplePopUpMenu.instance.show(context, position: details.globalPosition, items: ["Vendor", "Location"], onTap: (item) {
            item == "Vendor" ? context.push(VendorView()) : context.push(LocationView());
          },),
          itemAsString: (item) => item['name'].toString(),
          optionsBuilder: (textEditingValue) =>
              onSearch(textEditingValue)),
    );
  }

  Future<Iterable<Map<String, dynamic>>> onSearch(
      TextEditingValue textEditingValue) async {
    var val = textEditingValue.text.toLowerCase();
    if (val.isEmpty) {
      return [];
    }
    var omitted = (selectedData['name'] == textEditingValue.text) ? selectedData['name'] : null;
    var list =
    unfilteredList.where((element) => element['name'] != omitted).where((element) => element['name'].toString().toLowerCase().contains(val)).toList();
    Console.of.debug("Omitted ${omitted != null} ${((selectedData['name'] != textEditingValue.text))} ${((omitted != null) && ((selectedData['name'] != textEditingValue.text)))}");
    showEmptyNotifier.value = ((omitted == null) && (list.isEmpty)) ?  true : false;
    return list;
  }

  void _onSuggested(Map<String, dynamic> val) {
    var data  = val;
    selectedData = data;
    controller?.text = data['name'].toString();
    onSelected?.call(selectedData);
  }
}
