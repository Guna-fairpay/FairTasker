import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Location/location_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_add_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

class CustomVendorLocationField extends StatelessWidget {
  final List<dynamic> vendorsList, locationsList;
  final TextEditingController? controller;
  final Map<int, dynamic>? selected;
  final void Function(dynamic val)? onSelected;

  CustomVendorLocationField(
      {super.key,
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

  Map<String, dynamic> selectedData = {};

  void _prepareData() {
    unfilteredList = CustomSearchDataConverter.convertVLocation(vendors: vendorsList, locations: locationsList);
  }

  void _checkSelectedVData() async {
    if ((selected != null) && (selected![3] != null)) {
      selectedData = selected![3];
      var name = selectedData['name'];
      var controllerName = controller?.text;
      if (name != controllerName) {
        controller?.clear();
        await Future.delayed(Durations.medium3);
        controller?.text = name;
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
    showEmptyNotifier.value = list.isEmpty && (omitted != null) && ((selectedData['name'] != textEditingValue.text));
    return list;
  }

  void _onSuggested(Map<String, dynamic> val) {
    var data  = val;
    selectedData = data;
    controller?.text = data['name'].toString();
    onSelected?.call(selectedData);
  }
}
