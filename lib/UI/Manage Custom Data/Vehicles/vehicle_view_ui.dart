import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Response/create_expense_field_data.dart';
import '../../../Utilities/assets.dart';
import 'vehicle_add_ui.dart';
import 'vehicle_edit_ui.dart';
import 'Private Rental/private_rental_view_ui.dart';
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
  List<Map<String, dynamic>> vehicleData=[];
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
      MaterialPageRoute(builder: (context) => const VehicleAddUI(),fullscreenDialog: true),
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
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final vehicle = filteredVehicle[index];
      vehicleDataBloc.add(DeleteVehicleEvent(id: vehicle['id']));
      Utils.showMobileToast('vehicle deleted');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              100.0), // Adjusted height for HeaderView and TabBar
          child: Column(
            children: [
              const HeaderView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    tabs: const [
                      Tab(
                        text: 'Vehicles',
                        height: 30,
                      ),
                      Tab(text: 'Private Rental', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 16),
                    labelColor: AppC.white,
                    unselectedLabelColor: AppC.appColor,
                    indicator: BoxDecoration(
                        color: AppC.appColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const []),
                    indicatorSize: TabBarIndicatorSize.tab,
                    // splashFactory: NoSplash.splashFactory, // Remove splash effect
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) =>
              vehicleDataBloc..add(const GetActiveVehicleData()),
          child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
              listener: (context, state) async {
            if (state is VehicleDataLoading) {
              loading = true;
            } else if (state is VehicleListLoaded) {
              loading = false;
              filteredVehicle.clear();
              filteredVehicle.addAll(state.vehicleDataList ?? []);
              List<Map<String, dynamic>> list = [];
              list.addAll(state.vehicleDataList ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              vehicleName = list;
              filteredVehicle = List.from(vehicleName);
            }else if(state is VehicleGroupDataLoaded){
              vehicleData.addAll(state.vehicleGroupDataList??[]);
              print('-------------------------------$vehicleData');
            }
            else {
              vehicleDataBloc.add(const GetActiveVehicleData());
              loading = true;
            }
          }, builder: (context, state) {
            return Stack(
              children: [
                TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Utils.getSearchBarUI(
                                    () {},
                                    (value) {
                                      _filteredVehicle(value);
                                    },
                                    searchController,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Utils.getAddFilledButton(
                                '+',
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: AppC.white,
                                        insetPadding: EdgeInsets.zero,
                                        alignment: Alignment.topCenter,
                                        contentPadding: EdgeInsets.zero,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        titlePadding: EdgeInsets.zero,
                                        actionsPadding: EdgeInsets.zero,
                                        title: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Utils.getText(
                                            'Vehicle Grouping',
                                            size: 18,
                                            color: AppC.appColor,
                                            weight: FontWeight.bold,
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                                Icons.close),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                          ),
                                        ),
                                        content: VehicleGroupingUI(
                                            vehicleList: vehicleName, groupVehicleList: vehicleData, selectedVehicleIds: selectedVehicleIds,),
                                      );
                                    },
                                  );
                                },
                                textSize: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredVehicle.length,
                              itemBuilder: (context, index) {
                                final vehicle = filteredVehicle[index];
                                final vehicleId = vehicle['id'];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Dismissible(
                                    key: Key(vehicle['id'].toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      setState(() {
                                        filteredVehicle.removeAt(index);
                                      });
                                      _deleteVehicle(index);
                                    },
                                    background: Container(
                                      color: AppC.white,
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Utils.getText("Delete",
                                              size: 14, color: AppC.redAccent),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.delete_outline,
                                            color: AppC.redAccent,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _navigateToVehicleEditUI(index);
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        color: AppC.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
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
                                                    activeColor:
                                                        const Color(0xff4788ff),
                                                    value: selectedVehicles[vehicleId] ?? false,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        selectedVehicles[vehicleId] = value ?? false;
                                                        if (value == true) {
                                                          if (!selectedVehicleIds.contains(vehicleId)) {
                                                            selectedVehicleIds.add(vehicleId); // Add ID if checked
                                                          }
                                                        } else {
                                                          selectedVehicleIds.remove(vehicleId); // Remove ID if unchecked
                                                        }                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Utils.getText(
                                                    vehicle['vehicle_name'] ?? '',
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTapDown:
                                                    (TapDownDetails details) {
                                                  showMenu(
                                                    context: context,
                                                    position:
                                                        RelativeRect.fromLTRB(
                                                      details.globalPosition
                                                          .dx, // X-coordinate
                                                      details.globalPosition
                                                          .dy, // Y-coordinate
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          details.globalPosition
                                                              .dx, // Right offset
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height -
                                                          details.globalPosition
                                                              .dy, // Bottom offset
                                                    ),
                                                    items: [
                                                      const PopupMenuItem(
                                                        value: 'edit',
                                                        child: Column(
                                                          children: [
                                                            //  Utils.dropdownBox('', onSelected, labelKey: labelKey)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ).then((value) {
                                                    // Handle the selected value from the popup
                                                    if (value == 'edit') {
                                                      // _navigateToEdit();
                                                    } else if (value ==
                                                        'delete') {
                                                      // _deleteVehicle();
                                                    } else if (value ==
                                                        'details') {
                                                      //  _showDetails();
                                                    }
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  Assets.rentalCar,
                                                  height: 24,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RentalViewUI(),
                    ),
                  ],
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }),
        ),
        drawer: const DrawerView(),
        floatingActionButton: SizedBox(
          width: 150,
          height: 40,
          child: FloatingActionButton(
            onPressed: () {
              _navigateToVehicleAddUI();
            },
            elevation: 8,
            backgroundColor: AppC.appColor,
            child: Utils.getText('Add New Vehicle',
                color: AppC.white, weight: FontWeight.bold, size: 16),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
