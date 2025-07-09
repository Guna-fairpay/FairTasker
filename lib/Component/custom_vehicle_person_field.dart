import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/ui/leads_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/UI/employee_main_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef FutureCallback = Future<void> Function();

class CustomVehiclePersonField extends StatelessWidget {
  final List<dynamic> vehiclesList, personsList, groupVehicles;
  final List<Map<String, dynamic>>? selected;
  final void Function(dynamic val)? onSelected;
  final void Function(dynamic val)? onDeleted;
  final TextEditingController? controller;
  final bool updateWhileDelete;
  final String labelText;
  final FutureCallback? onEmptyAsync;
  final AutovalidateMode? autoValidateMode;
  final FormFieldValidator<List<Map<String, dynamic>>>? validator;

  CustomVehiclePersonField({
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
    this.onEmptyAsync,
    this.autoValidateMode,
    this.validator,
  }) {
    _initState();
  }

  List<Map<String, dynamic>> unfilteredList = [];
  List<Map<String, dynamic>> selectedList = [];

  void _initState() {
    _prepareData();
    _checkSelectedVData();
  }


  @override
  Widget build(BuildContext context) {
    return FormField<List<Map<String, dynamic>>>(
      validator: validator,
      autovalidateMode: autoValidateMode,
      initialValue: selected,
      builder: (field) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if ((selected != null) && (field.hasError && ((field.value == null)))) field.didChange(selected);
        });
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
                          color: const WidgetStatePropertyAll(AppC.lowGreen),
                          deleteIcon: const Icon(
                            Icons.close,
                            color: AppC.red,
                            size: 18,
                          ),
                          backgroundColor: const Color(0xffb5d2bb),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          // side: BorderSide(),
                          label: Text(model['name'] ?? '', style: context.textTheme.labelLarge?.copyWith(color: AppC.text, fontSize: 12.sp), overflow: TextOverflow.ellipsis, maxLines: 1),
                        ));
                  },
                ).toList(),
              ),
              if (controller != null)
                SearchViewField<Map<String, dynamic>>(
                    controller: controller!,
                    suggestions: unfilteredList,
                    onSelected: (value) {
                      List<Map<String, dynamic>> data = List.from(selectedList);
                      if (["person", "g_vehicles"].contains(value['type'])) {
                        data.clear();
                        data.add(value);
                      }
                      if (value['type'] == "vehicles") {
                        data.removeWhere((element) => ["person", "g_vehicles"].contains(element['type']));
                        data.add(value);
                      }
                      Console.of.warning(data);
                      selectedList = (data);
                      onSelected?.call(selectedList);
                      field.didChange(selectedList);
                      controller?.clear();
                    },
                    labelText: labelText,
                    autoClear: true,
                    showEmpty: true,
                    itemAsStringSearch: (item) => List<String>.from(item['searchBy'] ?? []).join(", "),
                    onEmptyTapDetails: (details) async {
                      SimplePopUpMenu.instance.show(
                        context,
                        position: details.globalPosition,
                        items: ["Vehicle", "Person", "Leads"],
                        onTap: (item) async {
                          if (onEmptyAsync != null) {
                            onEmptyAsync?.call();
                            await Future.delayed(Durations.short1);
                          }
                          context.push(switch(item) {
                            "Person" => const EmployeeMainPage(),
                            "Leads" => LeadsMainUI(customerName: controller?.text ?? ""),
                            _ => const VehicleMainViewUi(),
                          });
                        },
                      );
                    },
                    itemAsString: formatMapData),
              if (field.hasError)
                Row(
                  spacing: 8,
                  children: [
                    const SizedBox.shrink(),
                    CompactText(field.errorText ?? "", color: AppC.errorTextColor, fontWeight: FontWeight.w100, styleType: TextStyleType.labelMedium),
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  void _prepareData() {
    unfilteredList = CustomSearchDataConverter.convertVPerson(
        vehicles: vehiclesList,
        persons: personsList,
        groupVehicles: groupVehicles);
  }

  void _checkSelectedVData() {
    selectedList = selected ?? [];
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
    onDeleted?.call(val);
    selectedList = value;
    if (updateWhileDelete) onSelected?.call(selectedList);
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
