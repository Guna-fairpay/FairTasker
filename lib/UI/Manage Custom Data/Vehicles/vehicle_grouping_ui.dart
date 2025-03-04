
import 'dart:convert';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/vehicle_data_bloc.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class VehicleGroupingUI extends StatefulWidget {

  final List<int> selectedVehicleIds;
  final List<Map<String,dynamic>> vehicleList;

  const VehicleGroupingUI({super.key, required this.selectedVehicleIds, required this.vehicleList});

  @override
  State<VehicleGroupingUI> createState() => _VehicleGroupingUIState();
}

class _VehicleGroupingUIState extends State<VehicleGroupingUI> {

  final VehicleDataBloc vehicleDataBloc = VehicleDataBloc();
  List<Map<String, dynamic>> selectedMultipleVehicleList = [];
  List<Map<String, dynamic>> editMultipleVehicleList = [];
  List<Map<String, dynamic>> vehicleGroupData = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<String> vinList = [];
  TextEditingController vehicleController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  bool? isVehicleSelected = false;
  bool isSelected = false;
  bool editShowMultipleVehicleList = false;
  dynamic selectedVehicle;
  int? id;

  @override
  void initState() {
    super.initState();
    editMultipleVehicleList= widget.vehicleList;
  }

  Future<void> _deleteVehicleGroup(index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context, 'Group?');
    if (confirmed == true) {
      final id = index['id'];
      vehicleDataBloc.add(DeleteVehicleGroupEvent(id: id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        title: const Text('Vehicle Grouping'),
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => vehicleDataBloc..add(const GetVehicleGroupData()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is VehicleGroupDataLoaded) {
              vehicleGroupData.clear();
              vehicleGroupData.addAll(state.vehicleGroupDataList ?? []);
              selectedMultipleVehicleList.clear();
              for (var vehicleId in widget.selectedVehicleIds) {
                final match = editMultipleVehicleList.firstWhere(
                      (vehicle) => vehicle['id'] == vehicleId,
                  orElse: () => {},
                );
                selectedMultipleVehicleList.add(match);
              }
            }
            else{
              vehicleDataBloc.add(const GetVehicleGroupData());
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: 10.padding,
            child: ListView(
              physics: const ScrollPhysics(),
              children: [
                const SizedBox(
                  height: 10,
                ),
                Utils.getTextFormField('Group Name', groupNameController),
                CustomMultiSelectionChipsField<Map<String, dynamic>>(
                  selectedPartsList: selectedMultipleVehicleList,
                  suggestionsList: editMultipleVehicleList,
                  itemAsString: (item) => item['vehicle_name'].toString(),
                  controller: dropdownController,
                  hintText: "Select Vehicle",
                  onChanged: (isChecked, value) {
                    if (!selectedMultipleVehicleList.contains(value)) {
                      selectedMultipleVehicleList.add(value);
                    } else {
                      selectedMultipleVehicleList.remove(value);
                    }
                    setState(() {});
                  },
                  controllerAutoClear: true,
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Utils.getElevatedButton(() {
                      vinList=selectedMultipleVehicleList.map((e) => e['vin'].toString()).toList();
                      vehicleDataBloc.add(AddVehicleGroupingData(
                          name: groupNameController.text,
                          selectedList: vinList,
                        id: id,
                      ));
                      vehicleDataBloc.add(const GetVehicleGroupData());
                    }),
                   if(isSelected)Utils.getElevatedButton((){
                     groupNameController.clear();
                     selectedMultipleVehicleList.clear();
                     isSelected=false;
                     setState(() {});
                   },
                     text: 'Cancel',
                     bgColor: AppC.redAccent
                   ),
                  ],
                ),
                const SizedBox(height: 10,),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(height: 0.5,),
                    shrinkWrap: true,
                    itemCount: vehicleGroupData.length,
                    itemBuilder: (context, index) {
                      final group = vehicleGroupData[index];
                      return InkWell(
                        onTap: () {
                          isSelected=true;
                          id=group['id'];
                          selectedMultipleVehicleList.clear();
                          setState(() {
                            groupNameController.text = group['name'];
                            if (group['vin'] is String) {
                              try {
                                vinList =
                                    List<String>.from(jsonDecode(group['vin']));
                              } catch (e) {
                                vinList = [];
                              }
                            } else if (group['vin'] is List) {
                              vinList = group['vin'];
                            } else {
                              vinList = [];
                            }
                            for (var vin in vinList) {
                              final match = editMultipleVehicleList.firstWhere(
                                (vehicle) => vehicle['vin'] == vin,
                                orElse: () => {},
                              );
                              selectedMultipleVehicleList.add(match);
                            }
                          });
                        },
                        child: SafeArea(
                          minimum:10.padding,
                          child: Row(
                            children: [
                              Utils.getText("${index + 1}", color: AppC.text),
                              const SizedBox(
                                width: 20,
                              ),
                              Utils.getText(group['name'], color: AppC.text),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _deleteVehicleGroup(group),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: AppC.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          );
        }),
      ),
    );
  }
}
