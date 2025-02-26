
import 'dart:developer';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/Vehicle_edit_tab_bar.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Response/create_expense_field_data.dart';
import '../../../Utilities/assets.dart';
import 'vehicle_add_ui.dart';
import 'vehicle_edit_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VehicleViewUI extends StatefulWidget {
  const VehicleViewUI({super.key});

  @override
  State<VehicleViewUI> createState() => _VehicleUIState();
}

class _VehicleUIState extends State<VehicleViewUI> {

  final FocusNode searchFocusNode = FocusNode();
  late VehicleDataBloc vehicleDataBloc;
  CreateExpenseFieldData? createExpenseFieldData;
  CreateVehicleData createVehicleData = CreateVehicleData();
  List<Map<String, dynamic>> vehicleName = [];
  List<Map<String, dynamic>> filteredVehicle = [];
  List<Map<String, dynamic>> vehicleData = [];
  List<Map<String, dynamic>> cohortsData = [];
  List<Map<String, dynamic>> categoriesData = [];
  List<Map<String, dynamic>>? vehicleGroupData = [];
  List<int> selectedVehicleIds = [];
  TextEditingController searchController = TextEditingController();
  dynamic selectedCohortsData;
  dynamic selectedCategoriesData;
  bool loading = false;
  bool isSelected = false;
  Map<int, bool> selectedVehicles = {};
  String svgString = '';
  bool isShow = EasyLoading.isShow;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetAddedVehicleListData());
    vehicleDataBloc.add(const GetVehicleGroupData());
    createVehicleData = CreateVehicleData();
  }

  @override
  void dispose() {
    vehicleDataBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filteredVehicle(String query) {
    setState(() {
      filteredVehicle = vehicleName.where((vehicle) {
        final name = vehicle['vehicle_name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToVehicleAddUI() async {
    final newVehicle = await Navigator.push<CreateVehicleData>(
      context,
      MaterialPageRoute(
          builder: (context) => const VehicleAddUI(), fullscreenDialog: true),
    );
    if (newVehicle != null) {
      vehicleDataBloc.add(
        AddVehicleDataEvent(createVehicleData: newVehicle),
      );
      vehicleDataBloc.add(const GetAddedVehicleListData());
      Utils.showMobileToast('Vehicle Added successfully');
    }
  }

  Future<void> _navigateVehicleEditTabBar(index) async {

    final updatedVehicle = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleEditTabBar(vehicle: index,),
      ),
    );
    if (updatedVehicle != null) {
      setState(() {filteredVehicle[index] = updatedVehicle;});
      vehicleDataBloc.add(
        AddVehicleDataEvent(createVehicleData: CreateVehicleData.fromJson(updatedVehicle)),
      );
      vehicleDataBloc.add(const GetAddedVehicleListData());
      Utils.showMobileToast('Vehicle updated successfully');
    }
  }

  Future<void> _navigateToVehicleEditUI(int index) async {

    final Map<String, dynamic> selectedVehicle = Map<String, dynamic>.from(filteredVehicle[index]);
    final updatedVehicle = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleEditUI(vehicle: selectedVehicle, todoItems: {}),
      ),
    );
    if (updatedVehicle != null) {
      setState(() {filteredVehicle[index] = updatedVehicle;});
      vehicleDataBloc.add(
        AddVehicleDataEvent(createVehicleData: CreateVehicleData.fromJson(updatedVehicle)),
      );
      vehicleDataBloc.add(const GetAddedVehicleListData());
      Utils.showMobileToast('Vehicle updated successfully');
    }
  }

  Future<void> _deleteVehicle(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context, 'Vehicle?');
    if (confirmed == true) {
      final vehicle = filteredVehicle[index];
      vehicleDataBloc.add(DeleteVehicleEvent(id: vehicle['id']));
    }
  }

  Future<void> _rentalVehicle(index) async {
    AskPermissionDialog.show(context, onPositivePressed: () {
      index['rental_status'] = 3;
      vehicleDataBloc.add(MoveRentalData(
        rentalData: index
      ));
      log("$index", name: "index");
    },
        title: "Are you sure?",
        description: "Do you want to change rental status?",
        negativeText: "Cancel", positiveText: "Yes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => vehicleDataBloc..add(const GetActiveVehicleData()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is VehicleListLoaded) {
              filteredVehicle.clear();
              vehicleName.clear();
              vehicleName.addAll(state.vehicleDataList ?? []);
              vehicleName.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              filteredVehicle = List.from(vehicleName);
            }else {
              vehicleDataBloc.add(const GetActiveVehicleData());
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: 15.padding,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(
                        onChange: (value) {
                          _filteredVehicle(value);
                        },
                        searchController: searchController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Utils.getAddElevatedButton(
                      () => _navigateToVehicleAddUI(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredVehicle.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      final vehicle = filteredVehicle[index];
                      final vehicleId = vehicle['id'];
                      return InkWell(
                        onTap: () {
                          _navigateVehicleEditTabBar(vehicle);
                        },
                        child: SafeArea(
                          minimum: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Transform.scale(
                                      scale: 0.8,
                                      child: Checkbox(
                                        activeColor: const Color(0xff4788ff),
                                        value: selectedVehicles[vehicleId] ??
                                            false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            selectedVehicles[vehicleId] =
                                                value ?? false;
                                            if (value == true) {
                                              if (!selectedVehicleIds
                                                  .contains(vehicleId)) {
                                                selectedVehicleIds.add(
                                                    vehicleId);
                                              }
                                            } else {
                                              selectedVehicleIds
                                                  .remove(vehicleId);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Utils.getText(
                                        vehicle['vehicle_name'] ?? '',
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if(vehicle['rental_status']==0)
                                  InkWell(
                                    onTap: () => _rentalVehicle(vehicle),
                                    child: SvgPicture.asset(
                                      Assets.rentalCar,
                                      height: 24,
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () => _deleteVehicle(index),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: AppC.redAccent,
                                      ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>VehicleGroupingUI(
          selectedVehicleIds: selectedVehicleIds,
          vehicleList: vehicleName,
        ),),),

        extendedPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        elevation: 8,
        backgroundColor: AppC.appColor,
        label: Utils.getText('Vehicle Grouping',
            color: AppC.white, weight: FontWeight.bold, size: 16),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
