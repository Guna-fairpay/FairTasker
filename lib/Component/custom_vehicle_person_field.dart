import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employees_add_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVehiclePersonField extends StatelessWidget {
  final ValueNotifier<dynamic>? selectedVPersons;
  final List<dynamic> vehiclesList, personsList;
  final List<Map<String, dynamic>>? selected;
  final void Function(dynamic val)? onSelected;
  final void Function(dynamic val)? onDeleted;
  final TextEditingController? controller;

  CustomVehiclePersonField(
      {super.key,
      this.selectedVPersons,
      required this.vehiclesList,
      this.selected,
      this.onSelected,
      this.onDeleted,
      required this.personsList,
      this.controller}) {
    _prepareData();
    _checkSelectedVData();
  }

  final ValueNotifier<List<Map<String, dynamic>>> commonList =
      ValueNotifier([]);

  final ValueNotifier<List<Map<String, dynamic>>> selectedList =
      ValueNotifier([]);

  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  List<Map<String, dynamic>> unfilteredList = [];

  void _prepareData() {
    unfilteredList = CustomSearchDataConverter.convertVPerson(
        vehicles: vehiclesList, persons: personsList);
    commonList.value = unfilteredList;
  }

  void _checkSelectedVData() {
    if ((selected != null)) {
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
      decoration: selectedList.value.isEmpty
          ? null
          : const BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: AppC.borderColor, width: Num.borderWidthThinField),
                right: BorderSide(
                    color: AppC.borderColor, width: Num.borderWidthThinField),
                left: BorderSide(
                    color: AppC.borderColor, width: Num.borderWidthThinField),
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
          if (controller != null)
            ValueListenableBuilder(
              valueListenable: showEmptyNotifier,
              builder: (context, value, child) => CustomAutoSearchField(
                  controller: controller!,
                  labelText: "Vehicle/Person",
                  onSelected: _onSuggested,
                  showEmptyWidget: value,
                  autoClear: true,
                  itemAsString: (item) => formatMapData(item),
                  onEmptyWidgetTapDown: (details) => SimplePopUpMenu.instance.show(context, position: details.globalPosition, items: ["Vehicle", "Person"], onTap: (item) {
                    item == "Vehicle" ? context.push(const VehicleAddUI()) : context.push(const EmployeesAddUI());
                  },),
                  // onEmptyWidgetTap: () => context.push(const EmployeesAddUI()),
                  optionsBuilder: (textEditingValue) =>
                      onSearch(textEditingValue)),
            ),
          /*ValueListenableBuilder(
              valueListenable: commonList,
              builder: (context, value, child) =>
                  CustomSearchField<Map<String, dynamic>>(
                    controller: controller,
                    suggestions: value,
                    autoControllerClear: true,
                    isDense: true,
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontFamily: "Lato"),
                    labelText: "Vehicle/Person",
                    itemAsString: (item) => formatMapData(item),
                    suggestionState: Suggestion.hidden,
                    onSuggestionTap: _onSuggested,
                  )),*/
        ],
      ),
    );
  }

  Future<Iterable<Map<String, dynamic>>> onSearch(
      TextEditingValue textEditingValue) async {
    var val = textEditingValue.text.toLowerCase();
    if (val.isEmpty) {
      return [];
    }
    var list =
        unfilteredList.where((element) => isExist(element, val)).toList();
    showEmptyNotifier.value = list.isEmpty;
    return list;
  }

  void _onDelete(Map<String, dynamic> val) {
    var value = selectedList.value;
    value.remove(val);
    onDeleted?.call(val);
    selectedVPersons?.value.remove(val);
    selectedVPersons?.value = value;
    selectedList.value = value;
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
    controller?.clear();
  }

  String formatMapData(Map<String, dynamic> e) {
    return (e.containsKey("subname")
        ? "${e['name']}${e['subname'] ?? ""}"
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
