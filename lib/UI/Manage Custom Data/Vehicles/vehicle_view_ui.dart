import 'package:fairpytasker/Bloc/todo_view_bloc.dart' as tvb;
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Response/create_expense_field_data.dart';
import 'vehicle_add_ui.dart';
import 'vehicle_edit_ui.dart';
import 'Private Rental/private_rental_view_ui.dart';

class VehicleUIs extends StatefulWidget {
  const VehicleUIs({super.key});

  @override
  State<VehicleUIs> createState() => _VehicleUIState();
}

class _VehicleUIState extends State<VehicleUIs> {
  final FocusNode searchFocusNode = FocusNode();
  late VehicleDataBloc vehicleDataBloc;
  late tvb.TodoViewBloc todoViewBloc;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> vehiclename = [];
  List<Map<String, dynamic>> filteredVehicle = [];
  CreateVehicleData createVehicleData = CreateVehicleData();
  List<Map<String, dynamic>>? vehicleData;
  List<Map<String, dynamic>> cohortsData = [];
  dynamic selectedCohortsData;
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedCategoriesData;
  CreateExpenseFieldData? createExpenseFieldData;
  bool loading = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    todoViewBloc = tvb.TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetAddedVehicleListData());
    createVehicleData = CreateVehicleData();
  }

  @override
  void dispose() {
    vehicleDataBloc.close();
    todoViewBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filteredVehicle(String query) {
    setState(() {
      filteredVehicle = vehiclename.where((vehicle) {
        final name = vehicle['vehicle_name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToVehicleAddUI() async {
    final newVehicle = await Navigator.push<CreateVehicleData>(
      context,
      MaterialPageRoute(builder: (context) => const VehicleAddUI()),
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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  todoViewBloc..add(const TodoViewInitialEvent()),
            ),
            BlocProvider(
              create: (context) =>
                  vehicleDataBloc..add(const GetAddedVehicleListData()),
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<tvb.TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
                  if (state is GetVehicleStatusCheckListLoaded) {
                    // todoViewBloc.add(AddVehicleCreateTodo(
                    //  checklistId: state.vehicleChecklistData?['categories']?[0].checklists?[0].checklistId,
                    // title: '${state.vehicleChecklistData?['categories']?[0].categoryName}-${state.vehicleChecklistData?['categories']?[0].checklists?[0].checklistName}',
                    // startAt: Utils.convertDateTimeToTheFormat(DateTime.now().toString()),
                    // status: 'In Progress',
                    // statusId: state.vehicleChecklistData?['categories']?[0].checklists?[0].id,
                    // todoTime: DateFormat("HH:mm:ss").format(DateTime.now()),
                    // categoryId: state.vehicleChecklistData?['categories']?[0].checklists?[0].categoryId,
                    // cohortId: createVehicleData.selectedCohort??0,
                    // userId: int.parse(userIdGlobal),
                    // vehName: '${createVehicleData.year} ${createVehicleData.make} ${createVehicleData.model}',
                    // vinNumber: state.vehicleChecklistData?['categories']?[0].checklists?[0].vin));
                  }
                },
              ),
              BlocListener<VehicleDataBloc, VehicleDataState>(
                listener: (context, state) async {
                  if (state is VehicleDataLoading) {
                    loading = true;
                  } else if (state is DropdownVehicleDataLoaded) {
                    loading = true;
                    createExpenseFieldData = state.createExpenseFieldData;
                    if (state.createExpenseFieldData != null) {
                      cohortsData =
                          state.createExpenseFieldData!.cohortsData ?? [];
                      for (Map<String, dynamic> c in cohortsData) {
                        if (c['cohort'] == 'Unassigned') {
                          selectedCohortsData = c;
                        }
                      }
                      // categoriesData = state.createExpenseFieldData!.expenseCategories ?? [];
                    }
                  } else if (state is VehicleListLoaded) {
                    loading = false;
                    filteredVehicle.clear();
                    filteredVehicle.addAll(state.vehicleDataList ?? []);
                    List<Map<String, dynamic>> list = [];
                    list.addAll(state.vehicleDataList ?? []);
                    list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                        .compareTo(DateTime.parse(a['created_at'] ?? '')));
                    vehiclename = list;
                    filteredVehicle = List.from(vehiclename);
                  } else if (state is VehicleDataLoadedV) {
                    if (state.result != null) {
                      vehicleData = state.result;
                    }
                    vehicleDataBloc.add(const GetAddedVehicleListData());
                    vehicleDataBloc
                        .add(SetDefaultVehicleConfig(vinNumber: state.vin));
                  } else if (state is DefaultVehicleConfigLoaded) {
                    todoViewBloc.add(GetVehicleStatusCheckList(
                        vinNumber: state.vin, categoryName: null));
                  } else if (state is VehicleStatusCategoryLoaded) {
                    categoriesData.addAll(state.vehicleStatusDataList ?? []);
                    isSelected = true;
                    selectedCategoriesData = categoriesData[0];
                  } else {
                    vehicleDataBloc.add(const GetAddedVehicleListData());
                    loading = true;
                  }
                },
              ),
            ],
            child: BlocBuilder<VehicleDataBloc, VehicleDataState>(
                builder: (context, state) {
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
                                      searchFocusNode,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 40,
                                  child: Utils.getAddFilledButton('Add', () {
                                    _navigateToVehicleAddUI();
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredVehicle.length,
                                itemBuilder: (context, index) {
                                  final vehicle = filteredVehicle[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) =>
                                                _deleteVehicle(index),
                                            backgroundColor: AppC.white,
                                            foregroundColor: AppC.red,
                                            icon: Icons.delete_outline,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _navigateToVehicleEditUI(index);
                                        },
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          color: AppC.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Utils.getText(
                                                      vehicle['vehicle_name'] ??
                                                          '',
                                                      weight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
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
        ),
        drawer: const DrawerView(),
      ),
    );
  }
}
