
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class VehicleGroupingUI extends StatefulWidget {
  final List<Map<String, dynamic>> vehicleList;
  final List<Map<String, dynamic>> groupVehicleList;

  const VehicleGroupingUI({super.key, required this.vehicleList, required this.groupVehicleList});

  @override
  State<VehicleGroupingUI> createState() => _VehicleGroupingUIState();
}

class _VehicleGroupingUIState extends State<VehicleGroupingUI> {

  List<Map<String, dynamic>> selectedMultipleVehicleList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];

  TextEditingController vehicleController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  bool? isVehicleSelected = false;
  bool? isSelected = false;
  bool editShowMultipleVehicleList = false;
  dynamic selectedVehicle;
  TextEditingController dropdownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editMultipleVehicleList.addAll(widget.vehicleList);
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppC.white,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(15),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utils.getTextFormField('Group Name', groupNameController),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppC.fieldBase,
                  width: Num.borderWidthField,
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Num.subradiusButton))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: List<Widget>.generate(
                    selectedMultipleVehicleList.length,
                        (int idx) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0),
                          child: Chip(
                            onDeleted: () {
                              for (var element
                              in editMultipleVehicleList) {
                                if (element['vehicle_name'] ==
                                    selectedMultipleVehicleList[idx]
                                    ['vehicle_name']) {
                                  isVehicleSelected = false;
                                }
                              }
                              selectedMultipleVehicleList.removeAt(idx);
                              setState(() {});
                            },
                            side: const BorderSide(
                                color: AppC.trans),
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
                                    selectedMultipleVehicleList[idx]['vehicle_name'] ?? '',
                                    color: AppC.text
                                ),
                              ],
                            ),
                          ));
                    },
                  ).toList(),
                ),
                Utils.dropdownSearchBox(
                    'Select Vehicle',
                    enableFilter: true,
                    enableSearch: true,
                    requestFocusOnTap: true,
                    arrowColor: AppC.trans,
                    controller: dropdownController,
                    editMultipleVehicleList,
                        (value) {
                      setState(() {
                        selectedVehicle = value;
                        if (value != null) {
                          if (value is List) {
                            setState(() {
                            });
                            selectedMultipleVehicleList.addAll(selectedVehicle);
                          } else {
                            setState(() {});
                            selectedMultipleVehicleList.add(selectedVehicle);
                          }
                        }
                      });
                    }, labelKey: 'vehicle_name'),
              ],
            ),
          ),
          Utils.getAddFilledButton('Save', (){},bgColor: AppC.green),
          Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
              itemCount: widget.groupVehicleList.length,
              itemBuilder: (context, index){
                final group=widget.groupVehicleList[index];
                return CheckboxListTile(value: value, onChanged: onChanged)
                return Dismissible(
                  key: UniqueKey(),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 20,
                    dense: true,
                    minVerticalPadding: 0,
                    leading: Utils.getText("${index+1}",color: AppC.text),
                    title: Utils.getText(group['name'],color: AppC.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Icon(Icons.edit),
                        Icon(Icons.delete),
                      ],
                    ),
                  ),
                );
              })
          )
        ],
      ),
    );
  }
}
