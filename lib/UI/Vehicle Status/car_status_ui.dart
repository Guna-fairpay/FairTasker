
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/Response/create_todo_status_response.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_notes_history_view_ui.dart';
import 'package:fairpytasker/UI/cumulative_cost_list_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config_ui.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_check_list_ui.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/create_vehicle_data.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../Response/working_history_response.dart';
import '../Todo/add_todo_ui.dart';
import '../../Utilities/assets.dart';
import '../../widget/time_picker_only.dart';

class CarStatusUI extends StatefulWidget {
  final List<Map<String, dynamic>>? resourceList;

  const CarStatusUI({Key? key, this.resourceList}) : super(key: key);

  @override
  State<CarStatusUI> createState() => _CarStatusUIState();
}

class _CarStatusUIState extends State<CarStatusUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        body: CarStatusWithoutScaffold(
          resourceList: widget.resourceList,
          vinNumber: null,
        ));
  }
}

class CarStatusWithoutScaffold extends StatefulWidget {
  final List<Map<String, dynamic>>? resourceList;
  final String? vinNumber;

  const CarStatusWithoutScaffold(
      {Key? key, required this.resourceList, required this.vinNumber})
      : super(key: key);

  @override
  State<CarStatusWithoutScaffold> createState() =>
      _CarStatusWithoutScaffoldState();
}

class _CarStatusWithoutScaffoldState extends State<CarStatusWithoutScaffold> {
  bool showSearchRow = false;
  late TodoViewBloc todoViewBloc;
  List<Map<String, dynamic>> categoryList = [];
  bool showLoader = true;
  late VehicleDataBloc vehicleDataBloc;
  TextEditingController dateController = TextEditingController();
  int? rentalId;
  int? presaleId;
  List<Map<String, dynamic>> workingHistoryDataList = [];
  WorkingHistoryResponse? workingHistoryResponse;
  dynamic selectedCategory;
  DateTime selectedDate = DateTime.now();
  DateRange? selectedDateRange;
  TextEditingController searchController = TextEditingController();
  CreateExpenseFieldData? createExpenseFieldData;
  List<Map<String, dynamic>> cohortList = [];
  dynamic selectedCohort;
  Map<String, dynamic>? selectedResource;
  Map<String, dynamic>? selectedChecklistForTodo;
  List<Map<String, dynamic>> vehicleStatusListDataList = [];
  List<Map<String, dynamic>> vehicleStatusListDataListTemp = [];
  List<Map<String, dynamic>> vehicleStatusListDataWholeList = [];
  List<Map<String, dynamic>> vehicleStatusListDataCategoryFilteredList = [];
  List<Map<String, dynamic>> vehiclesMiscellaneousList = [];
  List<Map<String, dynamic>> vehiclesMiscellaneousListTemp = [];
  bool showMiscellaneous = false;
  bool isConfigLocal = true;
  TextEditingController customTaskController = TextEditingController();
  TextEditingController vendorLocationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController todoDateController = TextEditingController();
  TodoListRepo? todoListRepo;
  CreateTodoStatusResponse? createTodoStatusResponse;
  int? selectedPresale = 1;
  int selectedRental = 1;
  TextEditingController presaleController = TextEditingController();
  bool isSelected = false;
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    todoListRepo = TodoListRepo();
    todoViewBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    todoDateController.text =
        Utils.convertDateTimeToTheFormat(selectedDate.toString());
    todoListRepo!.chosenDateTime = selectedDate;
    todoListRepo!.chosenDateTimeString =
        DateFormat("hh:mm a").format(todoListRepo!.chosenDateTime!);
    todoListRepo!.startTimeTFString =
        DateFormat("HH:mm:ss").format(todoListRepo!.chosenDateTime!);
    vehicleDataBloc.add(const VehicleStatusCategory());
    todoViewBloc.add(const GetDropdownData());
    todoViewBloc.add(const GetVendorData());
    todoViewBloc.add(const GetLocationData());
  }

  Future<Map<String, dynamic>?> getSelectedResource() async {
    for (var element in widget.resourceList!) {
      if (element['id'] == int.parse(userIdGlobal)) {
        // selectedResource = element;
        return element;
      }
    }
    for (var element in widget.resourceList!) {
      if (element['first_name']!.toLowerCase() == 'product') {
        // selectedResource = element;
        return element;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                todoViewBloc..add(const GetVehicleStatusList()),
          ),
          BlocProvider(
            create: (context) => vehicleDataBloc..add(const VehicleInitial()),
          ),
        ],
        child: MultiBlocListener(
            listeners: [
              BlocListener<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
                  if (state is VehicleStatusListLoaded) {
                    vehicleStatusListDataWholeList.clear();
                    if (widget.vinNumber != null) {
                      Map<String, dynamic> vehicleStatusListData =
                          (state.vehicleStatusListDataList ?? []).firstWhere(
                              (element) => element['vin'] == widget.vinNumber!);
                      vehicleStatusListDataWholeList.add(vehicleStatusListData);
                      vehicleStatusListDataList.clear();
                      vehicleStatusListDataList.add(vehicleStatusListData);
                      vehicleStatusListDataCategoryFilteredList.clear();
                      vehicleStatusListDataCategoryFilteredList
                          .addAll(vehicleStatusListDataList);
                      vehicleStatusListDataListTemp.clear();
                      vehicleStatusListDataListTemp
                          .addAll(vehicleStatusListDataList);

                      // await getCategoriesListCount(vehicleStatusListDataWholeList);
                      // getFilterList(vehicleStatusListDataWholeList/*state.vehicleStatusListDataList ?? []*/, isConfigLocal);
                    } else {
                      vehicleStatusListDataWholeList
                          .addAll(state.vehicleStatusListDataList ?? []);
                      await getCategoriesListCount(
                          vehicleStatusListDataWholeList);
                      getFilterList(
                          state.vehicleStatusListDataList ?? [], isConfigLocal);
                    }
                    showLoader = false;
                  } else if (state is DropdownDataLoaded) {
                    createExpenseFieldData = state.createExpenseFieldData!;
                    cohortList.clear();
                    cohortList.addAll(
                        state.createExpenseFieldData!.cohortsData ?? []);
                    cohortList.insert(0, {'id': -1, 'cohort': 'All'});
                    selectedCohort = cohortList[0];
                  } else if (state is VehicleStatusCreateTodoLoaded) {
                    todoViewBloc.add(const GetVehicleStatusList());
                    /*
                        todoViewBloc.add(
                            SetVehicleActiveStatus(vinNumber: state.vin,
                                vehicleStatus: state.vehicleStatusCategory));
    */
                  } else if (state is GetVehicleActiveStatusLoaded) {
                    todoViewBloc.add(const GetVehicleStatusList());
                  } else if (state is GetMiscellaneousVehiclesLoaded) {
                    vehiclesMiscellaneousList.clear();
                    vehiclesMiscellaneousListTemp
                        .addAll(state.vehiclesMiscellaneousList ?? []);
                    vehiclesMiscellaneousList
                        .addAll(state.vehiclesMiscellaneousList ?? []);
                    searchController.clear();
                    showMiscellaneous = true;
                    showLoader = false;
                  } else if (state is LocationLoaded) {
                    locationList = (state.resource ?? []);
                  } else if (state is GetVehicleStatusCheckListLoaded) {
                    if (state.categoryName == 'PreSale') {
                      todoViewBloc.add(const GetVehicleStatusList());
                    } else {
                      todoViewBloc.add(VehicleCreateStatusTodo(
                          categoryId: state
                              .vehicleStatusListDataList?['vehicle_status'],
                          cohortId:
                              state.vehicleStatusListDataList?['cohort_id'],
                          cohortName:
                              state.vehicleStatusListDataList?['cohort'],
                          userId: int.parse(userIdGlobal),
                          vehImage: state.vehicleStatusListDataList?[
                                          'images'] !=
                                      null &&
                                  state.vehicleStatusListDataList!['images']!
                                      .isNotEmpty
                              ? (state.vehicleStatusListDataList?['images']![0]
                                      .path ??
                                  '')
                              : '',
                          vehName:
                              state.vehicleStatusListDataList?['vehicle_name'],
                          vinNumber: state.vehicleStatusListDataList?['vin'],
                          categoryName: state.categoryName,
                          vehicleStatusListDataList:
                              state.vehicleStatusListDataList,
                          isCreate: false));
                    }
                  } else if (state is VendorLoaded) {
                    vendorList = (state.resource ?? []);
                  } else if (state is UpdateVehicleStatusLoaded) {
                    todoViewBloc.add(const GetVehicleStatusList());
                  }
                  // else if (state is VehicleCreateStatusTodoLoaded) {
                  //   if (state.todo != null) {
                  //     createTodoStatusResponse = state.todo as CreateTodoStatusResponse?;
                  //     if (state.mentionedCategory == 'Rental') {
                  //       List<Map<String,dynamic>> listRepair = [];
                  //       List<Map<String,dynamic>> listPresale = [];
                  //       for (int i = 0; i < state.createTodoStatusResponse!.statusTodo!['checklist']!.length; i++) {
                  //         if (state.createTodoStatusResponse!.statusTodo!['checklist']?[i].categoryName == 'Repair') {
                  //           listRepair = state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists ?? [];
                  //         }
                  //         if (state.createTodoStatusResponse!.statusTodo!['checklist']?[i].categoryName == 'PreSale') {
                  //           listPresale = state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists ?? [];
                  //         }
                  //       }
                  //       selectedChecklistForTodo = null;
                  //       selectedResource = await getSelectedResource();
                  //       selectedChecklistForTodo = listRepair[0];
                  //       callRentalSlide(
                  //           listRepair,
                  //           listPresale,
                  //           state.mentionedCategory ?? '',
                  //           state.vehicleStatusListDataList);
                  //     } else if (state.mentionedCategory == 'PreSale') {
                  //       todoViewBloc.add(const GetVehicleStatusList());
                  //     }
                  //     // else {
                  //     //   for (int i = 0; i <
                  //     //       state.todo!.statusTodo!['checklist']!.length; i++) {
                  //     //     if (state.todo!.statusTodo!['checklist']?[i].categoryName == 'Recon') {
                  //     //       if (state.mentionedCategory == 'Buy') {
                  //     //         selectedChecklistForTodo = null;
                  //     //         selectedResource = await getSelectedResource();
                  //     //         selectedChecklistForTodo =
                  //     //         state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists![0];
                  //     //         callBuySlide(
                  //     //             state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists ?? [],
                  //     //             state.mentionedCategory ?? '',
                  //     //             state.vehicleStatusListDataList);
                  //     //       }
                  //     //     } else if (state.createTodoStatusResponse!
                  //     //         .statusTodo!['checklist']?[i].categoryName == 'PreSale') {
                  //     //       // selectedChecklistForTodo = null;
                  //     //       // selectedResource = null;
                  //     //       if (state.mentionedCategory == 'Recon') {
                  //     //         selectedChecklistForTodo = null;
                  //     //         selectedResource = await getSelectedResource();
                  //     //         selectedChecklistForTodo =
                  //     //         state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists![0];
                  //     //         for (var element in categoryList) {
                  //     //           if (element['category_name'] == 'Rental') {
                  //     //             rentalId = element['id']!;
                  //     //           }
                  //     //           if (element['category_name'] == 'PreSale') {
                  //     //             presaleId = element['id']!;
                  //     //           }
                  //     //         }
                  //     //         presaleController.text = state.vehicleStatusListDataList!['vehicle_id'].toString();
                  //     //         callReconSlide(
                  //     //             state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists ?? [],
                  //     //             state.mentionedCategory ?? '',
                  //     //             state.vehicleStatusListDataList);
                  //     //       } else if (state.mentionedCategory == 'Repair') {
                  //     //         selectedChecklistForTodo = null;
                  //     //         selectedResource = await getSelectedResource();
                  //     //         selectedChecklistForTodo =
                  //     //         state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists![0];
                  //     //         callRepairSlide(
                  //     //             state.createTodoStatusResponse!.statusTodo!['checklist']?[i].checklists ?? [],
                  //     //             state.mentionedCategory ?? '',
                  //     //             state.vehicleStatusListDataList);
                  //     //       }
                  //     //     }
                  //     //   }
                  //     // }
                  //   }
                  // }
                },
              ),
              BlocListener<VehicleDataBloc, VehicleDataState>(
                listener: (context, state) async {
                  if (state is VehicleDataLoadedV) {
                    Navigator.of(context).pop();
                    todoViewBloc.add(SetVehicleActiveStatus(
                        vinNumber: state.vin!,
                        vehicleStatus: state.categoryId));
                  } else if (state is VehicleStatusCategoryLoaded) {
                    categoryList = state.vehicleStatusDataList ?? [];
                    //isSelected = true;
                    selectedIndex = 0; // Set default selection index
                    selectedCategory =
                        categoryList.isNotEmpty ? categoryList[0] : null;
                    //selectedCategory = categoryList![0];
                  }
                },
              )
            ],
            child: BlocBuilder<TodoViewBloc, TodoViewState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Visibility(
                            //   visible: widget.vinNumber==null,
                            //   child: AppBar(
                            //       centerTitle: true,
                            //       elevation: 0,
                            //       backgroundColor: AppC.white,
                            //       // leading: IconButton(
                            //       //     onPressed: () {
                            //       //       Navigator.of(context).pop();
                            //       //     },
                            //       //     icon: const Icon(
                            //       //       Icons.arrow_back_sharp,
                            //       //       color: AppC.black,
                            //       //     )),
                            //       actions: [
                            //
                            //       ],
                            //       title: Utils.getText('Vehicle Status',
                            //           size: 18, weight: FontWeight.w700)),
                            // ),
                            Visibility(
                              visible: showSearchRow,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppC.fieldBase,
                                            width: Num.borderWidthField,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  Num.subradiusButton))),
                                      child:
                                          DropdownButton<Map<String, dynamic>>(
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Utils.getText(
                                              'Select Resource',
                                              color: AppC.grey),
                                        ),
                                        value: selectedCohort,
                                        isExpanded: true,
                                        dropdownColor: AppC.white,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        elevation: 4,
                                        underline: Container(
                                          height: 0,
                                          color: Colors.transparent,
                                        ),
                                        onChanged: (Map<String, dynamic>?
                                            value) async {
                                          // This is called when the user selects an item.
                                          selectedCohort = value;
                                          if (selectedCohort['id']! == -1) {
                                            await getFilterList(
                                                    vehicleStatusListDataWholeList,
                                                    isConfigLocal)
                                                .then((value) async {
                                              await getCategoriesListCount(
                                                  vehicleStatusListDataWholeList);
                                            });
                                          } else {
                                            await getFilterWithCohort(
                                                    vehicleStatusListDataCategoryFilteredList)
                                                .then((value) async {
                                              await getCategoriesListCount(
                                                  vehicleStatusListDataCategoryFilteredList);
                                            });
                                          }
                                          setState(() {});
                                        },
                                        items: cohortList.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> value) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: value,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Utils.getText(
                                                  '${value['cohort']}',
                                                  overFlow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: SizedBox(
                                    height: 30,
                                    child: Utils
                                        .getTextFormField(
                                      'Search',
                                      // suffixIcon: Icon(Icons.search, color: AppC.grey),
                                      searchController,
                                      onChangeCallback: (value) {
                                        doSearch(value);
                                      },
                                    ),
                                  )
                                      /*Utils.getSearchBarUI(null, (value) {
                                    //onChange
                                    doSearch(value);
                                  }, searchController),*/
                                      ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                      onTap: () {
                                        isConfigLocal = false;
                                        showMiscellaneous = false;
                                        searchController.clear();
                                        for (int i = 0;
                                            i < categoryList.length;
                                            i++) {
                                          isSelected = false;
                                        }
                                        getFilterList(
                                            vehicleStatusListDataWholeList,
                                            isConfigLocal);
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.settings))
                                ],
                              ),
                            ),
                            Visibility(
                                visible: showSearchRow,
                                child: const SizedBox(
                                  height: 15,
                                )),
                            Visibility(
                              visible: widget.vinNumber == null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List<Widget>.generate(
                                          categoryList.length,
                                          (int idx) {
                                            bool isSelected = (selectedIndex ==
                                                idx); // Check if the current index is selected
                                            return Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 5),
                                                  child: ChoiceChip(
                                                    showCheckmark: false,
                                                    padding: EdgeInsets.zero,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    labelPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                    selectedColor: AppC()
                                                        .bottomIconColor
                                                        .withOpacity(0.9),
                                                    backgroundColor: AppC.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Num
                                                              .subradiusButton),
                                                      side: const BorderSide(
                                                        color: AppC.appColor,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    label: Utils.getText(
                                                      ' ${categoryList[idx]['category_name']} ',
                                                      color: isSelected
                                                          ? AppC.white
                                                          : AppC.text,
                                                      weight: FontWeight.bold,
                                                      size: 13,
                                                    ),
                                                    selected: isSelected,
                                                    onSelected:
                                                        (bool selected) {
                                                      setState(() {
                                                        selectedIndex =
                                                            idx; // Update selected index
                                                        selectedCategory =
                                                            categoryList[idx];
                                                        getFilterList(
                                                            vehicleStatusListDataWholeList,
                                                            true);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      Utils.getBoxDecoration(
                                                    bgColor: AppC.red,
                                                    radius: 22,
                                                    borderColor: AppC.redOpac,
                                                  ),
                                                  child: Utils.getText(
                                                    ' ${categoryList[idx]['count'] ?? '0'} ',
                                                    color: AppC.white,
                                                    weight: FontWeight.bold,
                                                    size: 10,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showSearchRow = !showSearchRow;
                                      //TODO: For Testing...
                                      // callReconSlide(0,[],'');

                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      Assets.vehicleFilterIcon,
                                      height: 24,
                                      width: 30,
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        todoViewBloc.add(
                                            const GetMiscellaneousVehicles());
                                        showLoader = true;
                                        for (var element in categoryList) {
                                          isSelected = false;
                                        }
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.keyboard_double_arrow_right,
                                        color: AppC.red,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: !showMiscellaneous,
                              replacement: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: vehiclesMiscellaneousList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: Utils.getBoxDecoration(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Utils.getText(
                                              vehiclesMiscellaneousList[index]
                                                      ['vehicle_name'] ??
                                                  ''),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.sports_basketball,
                                                color: AppC().base, size: 18),
                                            Utils.getText(
                                                ' \$${vehiclesMiscellaneousList[index]['earnings'] ?? '0'}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: vehicleStatusListDataList.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                    key: ValueKey(index),
                                    endActionPane:
                                        ((selectedCategory?['category_name'] ??
                                                        '') ==
                                                    'Recon' ||
                                                (selectedCategory?[
                                                            'category_name'] ??
                                                        '') ==
                                                    'Rental' ||
                                                (selectedCategory?[
                                                            'category_name'] ??
                                                        '') ==
                                                    'Sold')
                                            ? null
                                            : ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      if ((selectedCategory
                                                                  ?.categoryName ??
                                                              '') ==
                                                          'Repair') {
                                                        todoViewBloc.add(GetVehicleStatusCheckList(
                                                            vinNumber:
                                                                vehicleStatusListDataList[
                                                                        index]
                                                                    ['vin'],
                                                            vehicleStatusListDataList:
                                                                vehicleStatusListDataList[
                                                                    index],
                                                            categoryName:
                                                                'Repair'));
                                                        // callRentalSlide(index);
                                                      } else if ((selectedCategory
                                                                  ?.categoryName ??
                                                              '') ==
                                                          'PreSale') {
                                                        // vehicle_status_checklist_api
                                                        // callRentalSlide(index);
                                                        todoViewBloc.add(GetVehicleStatusCheckList(
                                                            vehicleStatusListDataList:
                                                                vehicleStatusListDataList[
                                                                    index],
                                                            vinNumber:
                                                                vehicleStatusListDataList[
                                                                        index]
                                                                    ['vin'],
                                                            categoryName:
                                                                'PreSale'));
                                                      } else if ((selectedCategory
                                                                  ?.categoryName ??
                                                              '') ==
                                                          'Buy') {
                                                        // vehicle_status_checklist_api
                                                        // callRentalSlide(index);
                                                        todoViewBloc.add(GetVehicleStatusCheckList(
                                                            vinNumber:
                                                                vehicleStatusListDataList[
                                                                        index]
                                                                    ['vin'],
                                                            vehicleStatusListDataList:
                                                                vehicleStatusListDataList[
                                                                    index],
                                                            categoryName:
                                                                'Buy'));
                                                      }
                                                    },
                                                    foregroundColor: AppC.red,
                                                    label: 'Previous',
                                                  ),
                                                ],
                                              ),
                                    startActionPane: ((selectedCategory?[
                                                    'category_name'] ??
                                                '') ==
                                            'Sold')
                                        ? null
                                        : ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  if ((selectedCategory
                                                              ?.categoryName ??
                                                          '') ==
                                                      'Rental') {
                                                    todoViewBloc.add(VehicleCreateStatusTodo(
                                                        categoryId: vehicleStatusListDataList[index]
                                                            ['vehicle_status'],
                                                        cohortId:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort_id'],
                                                        cohortName:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort'],
                                                        userId: int.parse(
                                                            userIdGlobal),
                                                        vehImage: vehicleStatusListDataList[index]['images'] != null &&
                                                                vehicleStatusListDataList[index]['images']!
                                                                    .isNotEmpty
                                                            ? (vehicleStatusListDataList[index]['images']![0].path ??
                                                                '')
                                                            : '',
                                                        vehName: vehicleStatusListDataList[index]
                                                            ['vehicle_name'],
                                                        vinNumber:
                                                            vehicleStatusListDataList[index]
                                                                ['vin'],
                                                        categoryName: 'Rental',
                                                        index: index,
                                                        vehicleStatusListDataList:
                                                            vehicleStatusListDataList[index],
                                                        isCreate: true));
                                                  } else if ((selectedCategory
                                                              ?.categoryName ??
                                                          '') ==
                                                      'Buy') {
                                                    todoViewBloc.add(VehicleCreateStatusTodo(
                                                        categoryId: vehicleStatusListDataList[index]
                                                            ['vehicle_status'],
                                                        cohortId:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort_id'],
                                                        cohortName:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort'],
                                                        userId: int.parse(
                                                            userIdGlobal),
                                                        vehImage: vehicleStatusListDataList[index]['images'] != null &&
                                                                vehicleStatusListDataList[index]['images']!
                                                                    .isNotEmpty
                                                            ? (vehicleStatusListDataList[index]['images']![0].path ??
                                                                '')
                                                            : '',
                                                        vehName: vehicleStatusListDataList[index]
                                                            ['vehicle_name'],
                                                        vinNumber:
                                                            vehicleStatusListDataList[index]
                                                                ['vin'],
                                                        categoryName: 'Buy',
                                                        index: index,
                                                        vehicleStatusListDataList:
                                                            vehicleStatusListDataList[index],
                                                        isCreate: true));
                                                    // callReconSlide(index, [], '');
                                                  } else if ((selectedCategory
                                                              ?.categoryName ??
                                                          '') ==
                                                      'Recon') {
                                                    todoViewBloc.add(VehicleCreateStatusTodo(
                                                        categoryId: vehicleStatusListDataList[index]
                                                            ['vehicle_status'],
                                                        cohortId:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort_id'],
                                                        cohortName:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort'],
                                                        userId: int.parse(
                                                            userIdGlobal),
                                                        vehImage: vehicleStatusListDataList[index]['images'] != null && vehicleStatusListDataList[index]['images']!.isNotEmpty
                                                            ? (vehicleStatusListDataList[index]
                                                                        ['images']?[0]
                                                                    ['path'] ??
                                                                '')
                                                            : '',
                                                        vehName: vehicleStatusListDataList[index]
                                                            ['vehicle_name'],
                                                        vinNumber:
                                                            vehicleStatusListDataList[index]
                                                                ['vin'],
                                                        categoryName: 'Recon',
                                                        index: index,
                                                        vehicleStatusListDataList:
                                                            vehicleStatusListDataList[index],
                                                        isCreate: true));
                                                    // callRentalSlide(index);
                                                  } else if ((selectedCategory
                                                              ?.categoryName ??
                                                          '') ==
                                                      'Repair') {
                                                    todoViewBloc.add(VehicleCreateStatusTodo(
                                                        categoryId: vehicleStatusListDataList[index]
                                                            ['vehicle_status'],
                                                        cohortId:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort_id'],
                                                        cohortName:
                                                            vehicleStatusListDataList[index]
                                                                ['cohort'],
                                                        userId: int.parse(
                                                            userIdGlobal),
                                                        vehImage: vehicleStatusListDataList[index]['images'] != null && vehicleStatusListDataList[index]['images']!.isNotEmpty
                                                            ? (vehicleStatusListDataList[index]
                                                                        ['images']?[0]
                                                                    ['path'] ??
                                                                '')
                                                            : '',
                                                        vehName: vehicleStatusListDataList[index]
                                                            ['vehicle_name'],
                                                        vinNumber:
                                                            vehicleStatusListDataList[index]
                                                                ['vin'],
                                                        categoryName: 'Repair',
                                                        index: index,
                                                        vehicleStatusListDataList:
                                                            vehicleStatusListDataList[index],
                                                        isCreate: true));
                                                    // callRentalSlide(index);
                                                  } else if ((selectedCategory
                                                              ?.categoryName ??
                                                          '') ==
                                                      'PreSale') {
                                                    todoViewBloc.add(
                                                        VehicleCreateStatusTodo(
                                                            categoryId: vehicleStatusListDataList[index]
                                                                [
                                                                'vehicle_status'],
                                                            cohortId: vehicleStatusListDataList[index]
                                                                ['cohort_id'],
                                                            cohortName:
                                                                vehicleStatusListDataList[index]
                                                                    ['cohort'],
                                                            userId: int.parse(
                                                                userIdGlobal),
                                                            vehImage: vehicleStatusListDataList[index]['images'] !=
                                                                        null &&
                                                                    vehicleStatusListDataList[index]['images']!
                                                                        .isNotEmpty
                                                                ? (vehicleStatusListDataList[index]['images']
                                                                            ?[0]
                                                                        .path ??
                                                                    '')
                                                                : '',
                                                            vehName:
                                                                vehicleStatusListDataList[index]
                                                                    ['vehicle_name'],
                                                            vinNumber: vehicleStatusListDataList[index]['vin'],
                                                            categoryName: 'PreSale',
                                                            index: index,
                                                            vehicleStatusListDataList: vehicleStatusListDataList[index],
                                                            isCreate: true,
                                                            soldId: categoryList.firstWhere((element) => element['category_name'] == 'Sold', orElse: () => <String, dynamic>{} // Provide a default category object
                                                                )['id']));
                                                    // callRentalSlide(index);
                                                  }
                                                },
                                                foregroundColor: AppC.red,
                                                label: 'Complete',
                                              ),
                                            ],
                                          ),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: Utils.getBoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Utils.getText(
                                                          vehicleStatusListDataList[
                                                                      index][
                                                                  'vehicle_name'] ??
                                                              ''),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (BuildContext context) => VehicleStatusChecklistUI(
                                                                        vehicleStatusListData:
                                                                            vehicleStatusListDataList[
                                                                                index],
                                                                        vehicleName:
                                                                            vehicleStatusListDataList[index]['vehicle_name'] ??
                                                                                '',
                                                                        vinNumber:
                                                                            vehicleStatusListDataList[index]['vin'] ??
                                                                                '',
                                                                        percentage:
                                                                            (vehicleStatusListDataList[index]['vehicle_status_value'] ?? 0.0).toString()),
                                                                  ),
                                                                );
                                                              },
                                                              child: Visibility(
                                                                visible: vehicleStatusListDataList[index]
                                                                            [
                                                                            'last_checklist'] ==
                                                                        null ||
                                                                    vehicleStatusListDataList[index]
                                                                            [
                                                                            'last_checklist'] ==
                                                                        '',
                                                                replacement:
                                                                    Utils.getText(
                                                                        vehicleStatusListDataList[index]['last_checklist'] ??
                                                                            ''),
                                                                child: Icon(
                                                                    Icons
                                                                        .car_repair_rounded,
                                                                    color: AppC()
                                                                        .base,
                                                                    size: 16),
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      VehicleStatusConfigUI(
                                                                    vehicleStatusListData:
                                                                        vehicleStatusListDataList[
                                                                            index],
                                                                    vehicleName:
                                                                        vehicleStatusListDataList[index]['vehicle_name'] ??
                                                                            '',
                                                                    vinNumber:
                                                                        vehicleStatusListDataList[index]['vin'] ??
                                                                            '',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Icon(
                                                                Icons.settings,
                                                                color:
                                                                    AppC().base,
                                                                size: 16),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContextcontext) =>
                                                                          VehicleNotesHistoryViewUi(
                                                                    vin: vehicleStatusListDataList[index]
                                                                            [
                                                                            'vin'] ??
                                                                        '',
                                                                    vehicleName:
                                                                        vehicleStatusListDataList[index]['vehicle_name'] ??
                                                                            '',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Icon(
                                                                Icons.edit,
                                                                color: AppC.appColor,
                                                                size: 16),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          VehicleHistoryViewUI(
                                                                    vehicleName:
                                                                        vehicleStatusListDataList[index]['vehicle_name'] ??
                                                                            '',
                                                                    vin: vehicleStatusListDataList[index]
                                                                            ['vin'] ??
                                                                        '', resourceList:[], userGroupList:[],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: AppC
                                                                    .appColor,
                                                                size: 16),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Utils.datePicker(
                                                                      context,
                                                                      '',
                                                                      initial: DateTime
                                                                          .parse(
                                                                              "1970-01-01"))
                                                                  .then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  Utils.getText(
                                                                      Utils.convertDateTimeToTheFormat(
                                                                          value
                                                                              .toString()));
                                                                }
                                                              });
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color: AppC
                                                                    .appColor,
                                                                size: 16),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      const CreateTodoUI(),
                                                                ),
                                                              );
                                                            },
                                                            child: const Icon(
                                                                Icons.add,
                                                                color: AppC
                                                                    .appColor,
                                                                size: 16),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Visibility(
                                                        visible: (selectedCategory[
                                                                    'category_name'] ??
                                                                '') !=
                                                            'Rental',
                                                        replacement:
                                                            getRentalRow(index),
                                                        child: Visibility(
                                                          visible:
                                                              (selectedCategory?[
                                                                          'category_name'] ??
                                                                      '') ==
                                                                  'Sold',
                                                          child:
                                                              getSoldRow(index),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (selectedCategory[
                                                        'category_name'] !=
                                                    'Rental')
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CumulativeCostListUI(
                                                                        vehicleStatusListData:
                                                                            vehicleStatusListDataList[
                                                                                index],
                                                                        createExpenseFieldData:
                                                                            createExpenseFieldData)),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .closed_caption_off,
                                                                color:
                                                                    AppC().base,
                                                                size: 18),
                                                            Utils.getText(
                                                                ' \$${vehicleStatusListDataList[index]['cumulative_cost']}'),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            vehicleStatusListDataList[
                                                                        index][
                                                                    'wholesale_amount'] !=
                                                                null,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .sports_basketball,
                                                                color:
                                                                    AppC().base,
                                                                size: 18),
                                                            Utils.getText(
                                                                ' \$${vehicleStatusListDataList[index]['wholesale_amount']}'),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Utils.getText(
                                                          '${vehicleStatusListDataList[index]['count_days']}'),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Visibility(
                                              visible: (selectedCategory?[
                                                              'category_name'] ??
                                                          '') !=
                                                      'Rental' &&
                                                  (selectedCategory?[
                                                              'category_name'] ??
                                                          '') !=
                                                      'Sold',
                                              child: getFAProgressBar(index),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: state is TodoListLoading || showLoader,
                        child:
                            Center(child: Utils.getProgressIndicator(context)))
                  ],
                );
              },
            )));
  }

  Widget? faProgressBar;

  Widget getFAProgressBar(int index) {
    faProgressBar = FAProgressBar(
      currentValue: double.parse(
          (vehicleStatusListDataList[index]['vehicle_status_value'] ?? 0.0)
              .toString()),
      displayText: '%',
      backgroundColor: AppC.lightGrey,
      progressColor: AppC().base,
      animatedDuration: const Duration(seconds: 1),
      size: 15,
      maxValue: 100,
    );
    return faProgressBar!;
  }

  Widget getSoldRow(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.price_check_rounded, color: AppC().base, size: 18),
            Utils.getText(
                '${(vehicleStatusListDataList[index]['purchase_price'] ?? 0.0).toStringAsFixed(2)}'),
            const SizedBox(
              width: 8,
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppC().base, size: 18),
                Utils.getText(vehicleStatusListDataList[index]['details']
                            ?['soldDate'] !=
                        null
                    ? '${vehicleStatusListDataList[index]['details']?['soldDate']}'
                    : ''),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Row(
              children: [
                const Icon(Icons.adjust_rounded, color: AppC.red, size: 18),
                Utils.getText(
                    '${(vehicleStatusListDataList[index]['details']?['totalSoldAmount'] ?? 0.0).toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined,
                    color: AppC.red, size: 18),
                Utils.getText(
                    '${(vehicleStatusListDataList[index]['details']?['totalExpenses'] ?? 0.0).toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined,
                    color: AppC.green, size: 18),
                Utils.getText(
                    '${(vehicleStatusListDataList[index]['details']?['totalEarnings'] ?? 0.0).toStringAsFixed(2)}'),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget getRentalRow(int index) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: Utils.getBoxDecoration(bgColor: AppC().base, radius: 15),
          child: Utils.getText(
              ' ${vehicleStatusListDataList[index]['details']?['reservationCount'] ?? 0} ',
              color: AppC.white),
        ),
        const SizedBox(
          width: 8,
        ),
        Row(
          children: [
            const Icon(Icons.monetization_on_outlined,
                color: AppC.red, size: 18),
            Utils.getText(
                '${(vehicleStatusListDataList[index]['details']?['totalExpenses'] ?? 0.0).toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Row(
          children: [
            const Icon(Icons.monetization_on_outlined,
                color: AppC.green, size: 18),
            Utils.getText(
                '${(vehicleStatusListDataList[index]['details']?['totalEarnings'] ?? 0.0).toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }

  Future<void> getFilterList(
      List<Map<String, dynamic>> list, bool isConfig) async {
    vehicleStatusListDataList.clear();
    vehicleStatusListDataList.addAll(list.where((element) {
      if (!isConfig) {
        if (element['isConfig'] == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        if (element['vehicle_status'] == selectedCategory['id']! &&
            element['isConfig'] == 1) {
          return true;
        } else {
          return false;
        }
      }
    }).toList());
    // await getCategoriesListCount(list);
    vehicleStatusListDataCategoryFilteredList.clear();
    vehicleStatusListDataCategoryFilteredList.addAll(vehicleStatusListDataList);
    getFilterWithCohort(vehicleStatusListDataCategoryFilteredList);
    showMiscellaneous = false;
    searchController.clear();
    setState(() {});
  }

  Future<void> getFilterWithCohort(List<Map<String, dynamic>> list) async {
    if (selectedCohort['id'] != -1) {
      showLoader = true;
      vehicleStatusListDataList.clear();
      vehicleStatusListDataList.addAll(list.where((element) {
        if (element['cohort_id'] == selectedCohort!['id']!) {
          return true;
        }
        return false;
      }).toList());
      // debugPrint('vehicleStatusListDataList.len1: ${vehicleStatusListDataList?.length ?? 0}');
      showLoader = false;
    }
    // await getCategoriesListCount(list);
    vehicleStatusListDataListTemp.addAll(vehicleStatusListDataList);
    setState(() {});
  }

  void doSearch(String search) {
    String searchString = search.toLowerCase();
    if (!showMiscellaneous) {
      vehicleStatusListDataList.clear();
      if (searchString.isEmpty) {
        vehicleStatusListDataList.addAll(vehicleStatusListDataListTemp);
      } else {
        vehicleStatusListDataList
            .addAll(vehicleStatusListDataListTemp.where((element) {
          if (((element['vehicle_name'] ?? '').toLowerCase())
                  .contains(searchString) ||
              ((element['wholesale_amount'] ?? 0.0).toString().toLowerCase())
                  .contains(searchString) ||
              ((element['cumulative_cost'] ?? 0.0).toString().toLowerCase())
                  .contains(searchString) ||
              ((element['count_days'] ?? 0).toString().toLowerCase())
                  .contains(searchString)) {
            return true;
          }
          return false;
        }).toList());
      }
    } else {
      vehiclesMiscellaneousList.clear();
      if (searchString.isEmpty) {
        vehiclesMiscellaneousList.addAll(vehiclesMiscellaneousListTemp);
      } else {
        vehiclesMiscellaneousList
            .addAll(vehiclesMiscellaneousListTemp.where((element) {
          return (((element['vehicle_name'] ?? '').toString().toLowerCase())
                  .contains(searchString) ||
              ((element['vehicle_name'] ?? '').toString().toLowerCase())
                  .contains(searchString));
        }).toList());
      }
    }
    setState(() {});
  }

  void callReconSlide(List<Map<String, dynamic>> checklistForTodo,
      String categoryTitle, Map<String, dynamic>? vehicleStatusListDataList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Utils.getText('Recon', size: 18, weight: FontWeight.w500),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                            value: 1,
                            groupValue: selectedPresale,
                            onChanged: (value) {
                              selectedPresale = value;
                              // selectedRental = false;
                              presaleController.text =
                                  vehicleStatusListDataList!['vehicle_id']
                                      .toString();
                              setState(() {});
                            },
                            title: Utils.getText('Rental'),
                          )),
                          Expanded(
                              child: RadioListTile(
                            value: 2,
                            groupValue: selectedPresale,
                            onChanged: (value) {
                              selectedPresale = value;
                              // selectedRental = true;
                              setState(() {});
                            },
                            title: Utils.getText('Pre-Sale'),
                          )),
                        ],
                      ),
                      Stack(
                        children: [
                          Visibility(
                              visible: selectedPresale == 1,
                              child: Utils
                                  .getTextFormField(
                                      'Presale', presaleController)),
                          Visibility(
                            visible: selectedPresale == 2,
                            child: Expanded(
                              child: SingleChildScrollView(
                                child: todoDialogWidget(
                                    checklistForTodo, setState),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              actions: [
                Visibility(
                  visible: selectedPresale == 1,
                  child: Utils.getFilledButton('Confirm', () {
                    CreateVehicleData createVehicleData = CreateVehicleData();
                    createVehicleData.id = vehicleStatusListDataList!['id']!;
                    createVehicleData.vin = vehicleStatusListDataList['vin']!;
                    createVehicleData.year = vehicleStatusListDataList['year']!;
                    createVehicleData.make = vehicleStatusListDataList['make']!;
                    createVehicleData.model =
                        vehicleStatusListDataList['model']!;
                    createVehicleData.vehicleId =
                        vehicleStatusListDataList['vehicle_id'].toString();
                    createVehicleData.platform = 'TaskerApp';
                    createVehicleData.purchaseDate =
                        vehicleStatusListDataList['purchase_date']!;
                    createVehicleData.purchasePrice =
                        vehicleStatusListDataList['purchase_price'].toString();
                    createVehicleData.selectedCohort =
                        vehicleStatusListDataList['cohort_id'];
                    createVehicleData.categoryId = rentalId;

                    vehicleDataBloc.add(AddVehicleDataEvent(
                        createVehicleData: createVehicleData));
                  }),
                ),
                Visibility(
                  visible: selectedPresale != 1,
                  child: Utils.getOutlinedButton('Save', () async {
                    await callCreateTodoAPI(
                        categoryTitle, vehicleStatusListDataList);
                  }, verticalPadding: 5, borderColor: AppC().base),
                ),
                Visibility(
                    visible: selectedPresale != 1,
                    child: const SizedBox(
                      height: 15,
                    )),
                Visibility(
                  visible: selectedPresale != 1,
                  child: Utils.getOutlinedButton('Ignore', () {
                    callIgnoreTodoAPI(vehicleStatusListDataList);
                  }, verticalPadding: 5, borderColor: AppC().base),
                ),
                Utils.getOutlinedButton('Close', () {
                  Navigator.of(context).pop();
                }, verticalPadding: 5, borderColor: AppC().base),
              ],
            );
          });
        });
  }

  void callRentalSlide(
      List<Map<String, dynamic>> checklistForRepair,
      List<Map<String, dynamic>> checklistForPresale,
      String categoryTitle,
      Map<String, dynamic>? vehicleStatusListDataList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Utils.getText('Recon', size: 18, weight: FontWeight.w500),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                            value: 1,
                            groupValue: selectedRental,
                            onChanged: (value) {
                              selectedRental = value!;
                              selectedChecklistForTodo = null;
                              selectedChecklistForTodo = checklistForRepair[0];
                              // selectedRental = false;
                              setState(() {});
                            },
                            title: Utils.getText('Repair'),
                          )),
                          Expanded(
                              child: RadioListTile(
                            value: 2,
                            groupValue: selectedRental,
                            onChanged: (value) {
                              selectedRental = value!;
                              selectedChecklistForTodo = null;
                              selectedChecklistForTodo = checklistForPresale[0];
                              // selectedRental = true;
                              setState(() {});
                            },
                            title: Utils.getText('Pre-Sale'),
                          )),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            child: todoDialogWidget(
                                selectedRental == 1
                                    ? checklistForRepair
                                    : checklistForPresale,
                                setState)),
                      ),
                    ],
                  )),
              actions: [
                Utils.getOutlinedButton('Save', () async {
                  await callCreateTodoAPI(
                      categoryTitle, vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Ignore', () {
                  callIgnoreTodoAPI(vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
              ],
            );
          });
        });
  }

  void callRepairSlide(List<Map<String, dynamic>> checklistForTodo,
      String categoryTitle, Map<String, dynamic>? vehicleStatusListDataList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Utils.getText('Repair', size: 18, weight: FontWeight.w500),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.2,
                  // child: todoDialogWidget(checklistForTodo)
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: todoDialogWidget(checklistForTodo, setState),
                    ),
                  )),
              actions: [
                Utils.getOutlinedButton('Save', () async {
                  await callCreateTodoAPI(
                      categoryTitle, vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Ignore', () {
                  callIgnoreTodoAPI(vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Close', () {
                  Navigator.of(context).pop();
                }, verticalPadding: 5, borderColor: AppC().base),
              ],
            );
          });
        });
  }

  void callBuySlide(List<Map<String, dynamic>> checklistForTodo,
      String categoryTitle, Map<String, dynamic>? vehicleStatusListDataList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Utils.getText(categoryTitle,
                  size: 18, weight: FontWeight.w500),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.2,
                  // child: todoDialogWidget(checklistForTodo)
                  child: Expanded(
                    child: SingleChildScrollView(
                        child: todoDialogWidget(checklistForTodo, setState)),
                  )),
              actions: [
                Utils.getOutlinedButton('Save', () async {
                  await callCreateTodoAPI(
                      categoryTitle, vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Ignore', () {
                  callIgnoreTodoAPI(vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Close', () {
                  Navigator.of(context).pop();
                }, verticalPadding: 5, borderColor: AppC().base),
              ],
            );
          });
        });
  }

  Future<void> callIgnoreTodoAPI(
      Map<String, dynamic>? vehicleStatusListDataList) async {
    if (selectedChecklistForTodo == null) {
      Utils.showMobileToast("Please select checklist");
    } else {
      CreateTodoParams createTodoParams = CreateTodoParams(
          vehicleStatusCategory: selectedChecklistForTodo!['category_id']!,
          vin: vehicleStatusListDataList!['vin']!);
      todoViewBloc.add(UpdateVehicleStatus(createTodoParams: createTodoParams));
      Navigator.of(context).pop();
    }
  }

  Future<void> callCreateTodoAPI(String categoryTitle,
      Map<String, dynamic>? vehicleStatusListDataList) async {
    if (selectedChecklistForTodo == null) {
      Utils.showMobileToast("Please select checklist");
    } else {
      CreateTodoParams createTodoParams = CreateTodoParams();
      if (categoryTitle == 'Rental') {
        createTodoParams.todoTitle =
            '${selectedChecklistForTodo!['checklist_name']}-PreSale';
      } else {
        createTodoParams.todoTitle =
            '${selectedChecklistForTodo!['checklist_name']}-Recon';
      }
      createTodoParams.todoDate = todoDateController.text.toString();
      createTodoParams.todoTime = todoListRepo!.startTimeTFString;
      createTodoParams.cohortId =
          vehicleStatusListDataList!['cohort_id'].toString();
      createTodoParams.vin = vehicleStatusListDataList['vin'];
      createTodoParams.vehicleName = vehicleStatusListDataList['vehicle_name'];
      createTodoParams.notes = notesController.text;
      createTodoParams.vehicleStatusId = selectedChecklistForTodo!['id'];
      createTodoParams.vehicleStatus =
          vehicleStatusListDataList['vehicle_status'];
      createTodoParams.userId = selectedResource!['id']!.toString();
      createTodoParams.vehicleStatusChecklist =
          selectedChecklistForTodo!['checklist_id'];
      createTodoParams.vehicleStatusCategory =
          selectedChecklistForTodo!['category_id'];
      createTodoParams.customTask = customTaskController.text;
      await getSelectedVendorLocation(createTodoParams).then((value) {
        todoViewBloc.add(VehicleStatusCreateTodo(
            createTodoParams: createTodoParams,
            isCreate: true,
            vehicleStatusListDataList: vehicleStatusListDataList));
      });
      Navigator.of(context).pop();
    }
  }

  void callPresaleSlide(int index, List<Map<String, dynamic>> checklistForTodo,
      String categoryTitle, Map<String, dynamic>? vehicleStatusListDataList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Utils.getText('Recon', size: 18, weight: FontWeight.w500),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: RadioListTile(
                            value: 1,
                            groupValue: selectedPresale,
                            onChanged: (value) {
                              selectedPresale = value;
                              // selectedRental = false;
                              setState(() {});
                            },
                            title: Utils.getText('Repair'),
                          )),
                          Expanded(
                              child: RadioListTile(
                            value: 2,
                            groupValue: selectedPresale,
                            onChanged: (value) {
                              selectedPresale = value;
                              // selectedRental = true;
                              setState(() {});
                            },
                            title: Utils.getText('Pre-Sale'),
                          )),
                        ],
                      ),
                      Visibility(
                        visible: selectedPresale == 1,
                        replacement:
                            Utils.getTextFormField(
                                'Presale', presaleController),
                        child: SingleChildScrollView(
                            child:
                                todoDialogWidget(checklistForTodo, setState)),
                      ),
                    ],
                  )),
              actions: [
                Utils.getOutlinedButton('Save', () async {
                  await callCreateTodoAPI(
                      categoryTitle, vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
                const SizedBox(
                  height: 15,
                ),
                Utils.getOutlinedButton('Ignore', () {
                  callIgnoreTodoAPI(vehicleStatusListDataList);
                }, verticalPadding: 5, borderColor: AppC().base),
              ],
            );
          });
        });
  }

  bool showVendorLocationList = false;
  List<String> vendorLocationSuggestionList = [];
  List<Map<String, dynamic>> vendorList = [];
  List<Map<String, dynamic>> locationList = [];

  Future<CreateTodoParams> getSelectedVendorLocation(
      CreateTodoParams createTodoParams) {
    for (Map<String, dynamic> res in vendorList) {
      if ('${res['name']}' == vendorLocationController.text.trim()) {
        createTodoParams.vendorName = res['name'];
        createTodoParams.vendorId = res['id']!.toString();
      }
    }
    if (createTodoParams.vendorId == '') {
      for (Map<String, dynamic> veh in locationList) {
        if (veh['name'] == vendorLocationController.text.trim()) {
          createTodoParams.location = veh['name'];
          createTodoParams.locationId = veh['id']!.toString();
          debugPrint(
              'createTodoParams.locationId: ${createTodoParams.locationId}');
        }
      }
    }
    return Future.value(createTodoParams);
  }

  Widget todoDialogWidget(List<Map<String, dynamic>> checklistForTodo,
      void Function(void Function()) setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.getText('Next Task', weight: FontWeight.bold, size: 16),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase,
                width: Num.borderWidthField,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Num.radiusButton))),
          child: DropdownButton<Map<String, dynamic>>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Utils.getText('Select Checklist', color: AppC.grey),
            ),
            value: selectedChecklistForTodo,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              // This is called when the user selects an item.
              selectedChecklistForTodo = value;
              /*if (selectedResource!.id! == -1) {
                              getFilterList(
                                  vehicleStatusListDataWholeList, isConfigLocal);
                            } else {
                              getFilterWithCohort(
                                  vehicleStatusListDataCategoryFilteredList);
                            }*/
              setState(() {});
            },
            items: checklistForTodo.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText('${value['checklist_name']}'),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Utils.getTextFormField(
            'Custom Task', customTaskController),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Utils.getTextFormField(
                  'Todo Date', todoDateController, readOnly: true,
                  onTapCallback: () {
                Utils.datePicker(context, '').then((value) {
                  selectedDate = value!;
                  todoDateController.text =
                      Utils.convertDateTimeToTheFormat(value.toString());
                });
              }, label: Utils.getText('Todo Date')),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TimePickerViewOnly(
                todoListRepo: todoListRepo,
                voidCallback: () {
                  setState(() {});
                },
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase,
                width: Num.borderWidthField,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Num.radiusButton))),
          child: DropdownButton<Map<String, dynamic>>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Utils.getText('Select Resource', color: AppC.grey),
            ),
            value: selectedResource,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              // This is called when the user selects an item.
              selectedResource = value;
              setState(() {});
            },
            items: widget.resourceList!
                .map<DropdownMenuItem<Map<String, dynamic>>>(
                    (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText(
                      '${value['first_name']} ${value['last_name']}'),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Utils.getTextFormField(
          'Vendor / Location',
          vendorLocationController,
          label: Utils.getText('Vendor / Location'),
          readOnly: false,
          onChangeCallback: (value) {
            // String textCurrentlyEditing = getTextBeforeCursor();
            // debugPrint('textCurrentlyEditing: $textCurrentlyEditing');
            vendorLocationSuggestionList.clear();
            List vendorLocationList =
                vendorList.map((e) => e['name'] ?? '').toList() +
                    locationList.map((e) => e['name'] ?? '').toList();
            vendorLocationSuggestionList.addAll(
                Utils.searchList(vendorLocationList as List<String>, value));
            showVendorLocationList = vendorLocationSuggestionList.isNotEmpty;
            setState(() {});
            // state;
          },
          /*suffixIcon: Visibility(
              // visible: !editShowVendorLocationList,
              child: InkWell(
                  onTapDown: (details) {
                    Utils.showStringPopupMenu(
                        context, ['Add Vendor', 'Add Location'], details,
                            (value) async {
                          if (value == 'Add Vendor') {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const VendorUI(),
                            ));
                          } else {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LocationUI(),
                            ));
                          }
                        });
                  },
                  child: Icon(Icons.add, color: AppC().base, size: 20)),
            )*/
        ),
        Visibility(
            visible: !showVendorLocationList,
            child: const SizedBox(
              height: 15,
            )),
        Stack(
          children: [
            const SizedBox(
              height: 15,
            ),
            Utils.getTextFormField(
                'Notes', notesController),
            Visibility(
              visible: showVendorLocationList,
              child: Utils.customAutoCompleteList(vendorLocationSuggestionList,
                  (index) async {
                showVendorLocationList = false;
                // countHyphens('');
                vendorLocationController.text =
                    vendorLocationSuggestionList[index];
                /*if (stringArr.length == 1) {
                      taskIdentifierController.text =
                      '${stringArr[0]}--${vendorLocationSuggestionList[index]}';
                    } else if (stringArr.length >= 2) {
                      taskIdentifierController.text =
                      '${stringArr[0]}-${stringArr[1]}-${vendorLocationSuggestionList[index]}';
                    }*/
                vendorLocationController.selection = TextSelection.fromPosition(
                  TextPosition(offset: (vendorLocationController.text.length)),
                );
                setState(() {});
                // state;
                vendorLocationController.selection = TextSelection.fromPosition(
                  TextPosition(offset: (vendorLocationController.text.length)),
                );
                /* if (vendorLocationController.text.isNotEmpty) {
                      await getSelectedVendorLocation(createTodoParamForVHistory)
                          .then((value) {
                        if (value.locationId != null && value.locationId!.isNotEmpty) {
                          selectedMultipleAddressId = value.locationId!;
                          //TODO: call location GetAddedLocationListData()
                          locationDataBloc!.add(const GetAddedLocationListData());
                          setState(() {});
                        } */ /*else {
                  isShowMultipleAddressField = false;
                  setState(() {});
                }
*/ /*
                        setState(() {});
                      });
                    }*/
                // state;
              }),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> getCategoriesListCount(List<Map<String, dynamic>> list) async {
    for (var element in categoryList) {
      element['count'] = 0;
    }
    for (int j = 0; j < categoryList.length; j++) {
/*
      if (selectedCategory!.id != -1 && selectedCategory!.id! == categoryList[j].id) {
        categoryList[j].count = 0;
      }
*/
      // categoryList[j].count = 0;
      for (int i = 0; i < vehicleStatusListDataWholeList.length; i++) {
        if (selectedCohort['id'] != -1) {
          if (vehicleStatusListDataWholeList[i]['vehicle_status'] ==
                  categoryList[j]['id'] &&
              vehicleStatusListDataWholeList[i]['cohort_id'] ==
                  selectedCohort!['id']!) {
            categoryList[j]['count'] = categoryList[j]['count']! + 1;
          }
        } else if (vehicleStatusListDataWholeList[i]['vehicle_status'] ==
            categoryList[j]['id']) {
          categoryList[j]['count'] = categoryList[j]['count']! + 1;
        }
      }
    }
  }

  void doSetState() {
    setState(() {});
  }
}
