
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/show_vehicle_grouping_dialog.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping_ui.dart';
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

  Future<void> _navigateToVehicleEditUI(int index) async {
    final updateVehicle = await Navigator.push<CreateVehicleData>(
      context,
      MaterialPageRoute(
          builder: (context) => VehicleEditUI(vehicle: filteredVehicle[index])),
    );
    if (updateVehicle != null) {
      vehicleDataBloc.add(
        AddVehicleDataEvent(createVehicleData: updateVehicle),
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
      Utils.showMobileToast('vehicle deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) =>
            vehicleDataBloc..add(const GetActiveVehicleData()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is VehicleListLoaded) {
              filteredVehicle.clear();
              filteredVehicle.addAll(state.vehicleDataList ?? []);
              List<Map<String, dynamic>> list = [];
              list.addAll(state.vehicleDataList ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              vehicleName = list;
              filteredVehicle = List.from(vehicleName);
            } else if (state is VehicleGroupDataLoaded) {
              vehicleData.addAll(state.vehicleGroupDataList ?? []);
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
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
                      () {
                        showVehicleGroupingDialog(
                          context: context,
                          vehicleName: vehicleName,
                          vehicleData: vehicleData,
                          selectedVehicleIds: selectedVehicleIds,
                        );
                      }
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
                          _navigateToVehicleEditUI(index);
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
                                                    vehicleId); // Add ID if checked
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
                                  InkWell(
                                    onTap: () {},
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
                                      )),
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
        onPressed: () {
          _navigateToVehicleAddUI();
          },
        extendedPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        elevation: 8,
        backgroundColor: AppC.appColor,
        label: Utils.getText('Add New Vehicle',
            color: AppC.white, weight: FontWeight.bold, size: 16),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
