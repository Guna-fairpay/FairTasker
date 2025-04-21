import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_type_head_search_view.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employees_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employees_view_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomVehiclePersonField extends StatefulWidget {
  final List<dynamic> vehiclesList, personsList, groupVehicles;
  final List<Map<String, dynamic>>? selected;
  final void Function(dynamic val)? onSelected;
  final void Function(dynamic val)? onDeleted;
  final TextEditingController? controller;
  final bool updateWhileDelete;
  final String labelText;

  const CustomVehiclePersonField({
    super.key,
    required this.vehiclesList,
    this.selected,
    this.onSelected,
    this.onDeleted,
    this.labelText = "Vehicle/Person",
    required this.personsList,
    this.groupVehicles = const [],
    this.controller,
    this.updateWhileDelete = true,
  });

  @override
  State<CustomVehiclePersonField> createState() =>
      _CustomVehiclePersonFieldState();
}

class _CustomVehiclePersonFieldState extends State<CustomVehiclePersonField> {
  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  List<Map<String, dynamic>> unfilteredList = [];

  List<Map<String, dynamic>> selectedList = [];

  @override
  void initState() {
    _prepareData();
    _checkSelectedVData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomVehiclePersonField oldWidget) {
    if (oldWidget.selected != widget.selected) {
      _checkSelectedVData();
    }
    if ((oldWidget.vehiclesList != widget.vehiclesList) || (oldWidget.personsList != widget.personsList) ) {
      _prepareData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _prepareData() {
    unfilteredList = CustomSearchDataConverter.convertVPerson(
        vehicles: widget.vehiclesList,
        persons: widget.personsList,
        groupVehicles: widget.groupVehicles);
    setState(() {});
  }

  void _checkSelectedVData() {
    selectedList = widget.selected ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: selectedList.isEmpty
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
        spacing: selectedList.isEmpty ? 0 : 5,
        children: [
          Wrap(
            children: List<Widget>.generate(
              selectedList.length,
              (int idx) {
                var model = selectedList[idx];
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
                          Utils.getText(model['name'] ?? '', color: AppC.text),
                        ],
                      ),
                    ));
              },
            ).toList(),
          ),
          if (widget.controller != null)
            SearchViewField<Map<String, dynamic>>(
                controller: widget.controller!,
                suggestions: unfilteredList,
                onSelected: _onSuggested,
                labelText: widget.labelText,
                autoClear: true,
                showEmpty: true,
                onEmptyTapDetails: (details) => SimplePopUpMenu.instance.show(
                  context,
                  position: details.globalPosition,
                  items: ["Vehicle", "Person"],
                  onTap: (item) {
                    item == "Vehicle"
                        ? context.push(const VehicleMainViewUi())
                        : context.push(const EmployeesViewUI());
                  },
                ),
                itemAsString: formatMapData),
          /*ValueListenableBuilder(
            valueListenable: showEmptyNotifier,
            builder: (context, value, child) => TypeHeadSearchView<Map<String, dynamic>>(
                controller: widget.controller!,
                labelText: widget.labelText,
                onSelected: _onSuggested,
                showEmptyWidget: value,
                onFieldFocusCreated: (focusNode) => _focusNode = focusNode,
                itemAsString: (item) => formatMapData(item),
                onEmptyWidgetTapDown: (details) =>
                    SimplePopUpMenu.instance.show(
                      context,
                      position: details.globalPosition,
                      items: ["Vehicle", "Person"],
                      onTap: (item) {
                        item == "Vehicle"
                            ? context.push(const VehicleAddUI())
                            : context.push(const EmployeesAddUI());
                      },
                    ),
                // onEmptyWidgetTap: () => context.push(const EmployeesAddUI()),
                optionsBuilder: onSearch),
          ),*/
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> onSearch(String textEditingValue) async {
    var val = textEditingValue.toLowerCase();
    if (val.isEmpty) {
      return [];
    }
    var list =
        unfilteredList.where((element) => isExist(element, val)).toList();
    return list;
  }

  void _onDelete(Map<String, dynamic> val) {
    var value = selectedList;
    value.remove(val);
    widget.onDeleted?.call(val);
    selectedList = value;
    if (widget.updateWhileDelete) widget.onSelected?.call(selectedList);
  }

  void _onSuggested(Map<String, dynamic> val) {
    List<Map<String, dynamic>> data = List.from(selectedList);
    if (["person", "g_vehicles"].contains(val['type'])) {
      data.clear();
      data.add(val);
    }
    if (val['type'] == "vehicles") {
      data.removeWhere((element) => ["person", "g_vehicles"].contains(element['type']));
      data.add(val);
    }
    Console.of.warning(data);
    Future.microtask(() => Utils.dismissKeyboard(context));
    selectedList = (data);
    widget.onSelected?.call(selectedList);
    widget.controller?.clear();
    setState(() {});
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
