
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class VehicleGroupingUI extends StatefulWidget {
  final List<Map<String, dynamic>> vehicleList;
  final List<Map<String, dynamic>> groupVehicleList;
  final List<int> selectedVehicleIds;

  const VehicleGroupingUI({super.key, required this.vehicleList, required this.groupVehicleList, required this.selectedVehicleIds});

  @override
  State<VehicleGroupingUI> createState() => _VehicleGroupingUIState();
}

class _VehicleGroupingUIState extends State<VehicleGroupingUI> {

  List<Map<String, dynamic>> selectedMultipleVehicleList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<dynamic> editMultipleVehicleSuggestionList = [];

  TextEditingController vehicleController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  bool? isVehicleSelected = false;
  bool? isSelected = false;
  bool editShowMultipleVehicleList = false;
  dynamic selectedVehicle;
  List<dynamic>?vinList=[];


  @override
  void initState() {
    super.initState();
    selectedMultipleVehicleList.clear();
    editMultipleVehicleList.addAll(widget.vehicleList);
    for (var vehicleId in widget.selectedVehicleIds) {
      final match = widget.vehicleList.firstWhere(
            (vehicle) => vehicle['id'] == vehicleId,
        orElse: () => {},
      );
      selectedMultipleVehicleList.add(match);
        }
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
      child: Column(
        spacing: 10,
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
                    selectedMultipleVehicleList.length, (int idx) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Chip(
                            padding: EdgeInsets.zero,
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
                            labelPadding: const EdgeInsets.only(left: 4),
                            side: const BorderSide(color: AppC.trans),
                            deleteIcon: const Icon(
                              Icons.close,
                              color: AppC.red,
                              size: 18,
                            ),
                            backgroundColor: const Color(0xffb5d2bb),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Utils.getText(selectedMultipleVehicleList[idx]['vehicle_name'] ?? '', color: AppC.text),
                              ],
                            ),
                          )
                      );
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
          Utils.getElevatedButton((){}),
          Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  bottom:60),
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
              itemCount: widget.groupVehicleList.length,
              itemBuilder: (context, index){
                final group=widget.groupVehicleList[index];
                return GestureDetector(
                  onTap: (){
                    selectedMultipleVehicleList.clear();
                    setState(() {
                      groupNameController.text=group['name'];
                      if (group['vin'] is String) {
                        try {
                          vinList = List<String>.from(jsonDecode(group['vin']));
                        } catch (e) {
                          vinList = [];
                        }
                      } else if (group['vin'] is List) {
                        vinList = group['vin'];
                      } else {
                        vinList = [];
                      }
                      for (var vin in vinList!) {
                        final match = widget.vehicleList.firstWhere(
                              (vehicle) => vehicle['vin'] == vin,
                          orElse: () => {},
                        );
                        selectedMultipleVehicleList.add(match);
                      }
                    });},
                  child: SafeArea(
                    minimum: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Utils.getText("${index+1}",color: AppC.text),
                        const SizedBox(width: 20,),
                        Utils.getText(group['name'],color: AppC.text),
                        const Spacer(),
                        GestureDetector(
                            onTap: (){},
                            child: const Icon(Icons.delete_outline,color: AppC.redAccent,)),
                      ]
                      ),
                    ),
                  );
              }
              )
          )
        ],
      ),
    );
  }
}
