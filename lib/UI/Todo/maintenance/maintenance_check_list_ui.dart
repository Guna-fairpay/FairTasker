import 'dart:developer';
import 'dart:math' as m;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import 'maintenance_bloc.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceCheckListUI extends StatelessWidget {
  final dynamic todoItems, vehicle;

  const MaintenanceCheckListUI(
      {super.key, required this.todoItems, required this.vehicle});

  void _showTaskPopup(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "Task already exists, please complete or delete the task",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                        context.read<MaintenanceBloc>().add(CompleteTodoItemEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppC.green,
                      ),
                      child: Text("Complete"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppC.red,
                      ),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry!);
  }


  Widget checkBoxWithSingleTextAndTexBox({
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    required String label,
  }) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(
            activeColor: AppC.blue,
            value: checkboxValue,
            onChanged: onCheckboxChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Utils.getText(label),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc()
        ..add(
          MaintenanceInitialEvent(
            todoItem: todoItems,
            vehicle: vehicle,
          ),
        ),
      child: BlocListener<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          log("${state.runtimeType}", name: "LOADING_CHECK");
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child:
        BlocBuilder<MaintenanceBloc, MaintenanceState>(
          builder: (context, state) {
            return
              SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child:
                          Checkbox(
                            activeColor: AppC.blue,
                            value: state.isAllCheck,
                            onChanged: (value) => context.read<MaintenanceBloc>().add(IsAllMaintenanceCheckEvent(value ?? false),),
                          ),
                        ),
                        Utils.getText(
                          'Is all maintenance check done',
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    //Text("DROPDOWN_VALUE ${state.dropdownValue}"),
                    const SizedBox(height: 10),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.maintenance?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final maintenanceCheckListData =
                            state.maintenance![index];
                        var checkList =
                            (maintenanceCheckListData['children'] as List?) ??
                                [];
                        log("${checkList.length}", name: "checklist length");
                        return
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Utils.getText(
                              "${maintenanceCheckListData['name'] ?? ''}"
                                  .trim(), // Fluids, Routers, etc.
                              weight: FontWeight.bold,
                            ),
                            for (var item in checkList) ...[
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        checkBoxWithSingleTextAndTexBox(
                                          checkboxValue:
                                            state.individualCheckStates[item['id'].toString()] ??
                                              !((state.dropdownValue is List ? (state.dropdownValue as List).any((element) =>
                                              element['name'].toString().toLowerCase() == "good") : false)
                                                  ||
                                                  ((state.idList?.contains(int.tryParse(item['id'].toString())) ?? false)
                                                      ||
                                                      (state.initialDropDown is List ? (state.initialDropDown as List).any((element) =>
                                                      element['name'].toString().toLowerCase() == "good") : false)
                                                        ||
                                                          (state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] == true ? false : true))),
                                              onCheckboxChanged: (bool? value) async {
                                              _showTaskPopup(context);
                                              context.read<MaintenanceBloc>().add(
                                                  IndividualCheckEvent(
                                                      item['id'].toString(),
                                                      value ?? false,
                                                    item: item
                                                  ),
                                              );
                                              state.selectedDropdownValues[item['id']] = value == true ? "Good" : "Bad";
                                              await Future.delayed(Durations.medium2);
                                              log("state.individualCheckStates ${state.individualCheckStates[item['id']]} ${state.dropdownValue}", name: "CHECKING_VALUE");
                                            },
                                          label: item['name'].trim() ?? '',
                                        ),
                                        if (item['name'] != 'Other')
                                          Expanded(
                                            child:
                                            Utils.dropdownBox(
                                              'Not Checked',
                                              List<Map<String, dynamic>>.from(
                                                  item['children'])..addAll([
                                                  {
                                                    "id": m.Random().nextInt(99),
                                                    "name": "Other"
                                                  },
                                                  {
                                                    "id": 99,
                                                    "name": "Not Checked"
                                                  }
                                                ]
                                              ),
                                              (value) {
                                                context.read<MaintenanceBloc>().add(DropDownOptionEvent(value),);
                                                state.selectedDropdownValues[item['id']] = value['name'];
                                                if (state.selectedDropdownValues[item['id']] == "Good") {
                                                  state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = true;
                                                } else {
                                                  state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = false;
                                                }
                                                log("value ${state.selectedDropdownValues}",
                                                    name: "TESTING_SELECTED");
                                                log("value ${state.initialDropDown}",
                                                    name: "INITIAL_DROP_DOWN");
                                                log("${(state.idList
                                                    ?.contains(item['id']) ??
                                                    false)} ${state.idList} ${item['id']}", name: "CHECKING_VALUE");
                                              },
                                              labelKey: 'name',
                                              initialSelection:
                                              state.dropdownValue != null && state.dropdownValue['name'] != null
                                                  ? state.dropdownValue
                                                  : (state.idList?.contains(item['id']) ?? false)
                                                  ? {
                                                "id": 99,
                                                "name": "Not Checked" }
                                                  : List.from(item['children']).firstWhere(
                                                    (element) =>
                                                state.initialDropDown?.map((e) => e['id'].toString()).contains(element['id'].toString()) ??
                                                    false,
                                                orElse: () => (List.from(item['children'])).firstWhere(
                                                      (element) => element['name'].toString().toLowerCase() == "good",
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                    !(
                                        (state.dropdownValue is List &&
                                            (state.dropdownValue as List).any((element) =>
                                                element['name'].toString().toLowerCase().trim() == "good")) ||
                                            (state.selectedDropdownValues[item['id']]?.toString().toLowerCase() == "good") ||
                                            (state.selectedDropdownValues[item['id']]?.toString().toLowerCase() == "Not Checked") ||
                                            (state.initialDropDown?.any((element) =>
                                            element['name'].toString().toLowerCase() == "good") ?? false)
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 40.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Utils.getBorderedMultilineTextField(
                                            'Notes',
                                            state.notesControllers[
                                                    item['id']]!,
                                            minLines: 2,
                                          ),
                                          Utils.getAddFilledButton(
                                            'Create Task',
                                            () async {
                                              FocusScope.of(context).unfocus();
                                              if (state.selectedDropdownValues[
                                                      item['id']] ==
                                                  null) {
                                                Utils.showMobileToast(
                                                    'Please select a valid option');
                                                return;
                                              }
                                              context.read<MaintenanceBloc>().add(
                                                    createFixTaskEvent(
                                                      maintenanceTaskId:
                                                          '${maintenanceCheckListData['id']}-${item['id']}-${item['children'].firstWhere(
                                                        (e) =>
                                                            e['name'] ==
                                                            state.selectedDropdownValues[
                                                                item['id']],
                                                      )['id']}',
                                                      notes:
                                                          '${maintenanceCheckListData['name']}-${item['name']}-${state.selectedDropdownValues[item['id']] ?? "Unknown"}',
                                                      comments: state
                                                          .notesControllers[
                                                              item['id']]!
                                                          .text,
                                                      item: item['id'],
                                                    ),
                                              );
                                            },
                                            bgColor: AppC.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                    const SizedBox(height: 10),
                    Utils.getBorderedMultilineTextField(
                      'Notes',
                      context.read<MaintenanceBloc>().notesController,
                      fillColor: AppC.white,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// TodoListRepo todoListRepo = TodoListRepo();
// final TextEditingController notesController = TextEditingController();
// final TextEditingController controller = TextEditingController();
// final List<TextEditingController> textEditingControllers = [];
// List<Map<String, dynamic>> maintenanceCheckList = [];
// bool isAllChecked = false;
// bool checkValue = false;
// dynamic todoItem, vehicle;

// class _MaintenanceCheckListUIState extends State<MaintenanceCheckListUI> {
//   TodoViewBloc? todoViewBloc;
//   bool isAllCheck = false;
//   TextEditingController notesController = TextEditingController();
//   TextEditingController controller = TextEditingController();
//   List<Map<String, dynamic>> data = [];
//   List<dynamic> maintenanceListData = [];
//   Map<int, Map<int, bool>> checkboxStates = {};
//   Map<dynamic, String> selectedDropdownValues = {};
//   int? selectedId;
//   String? maintenanceTaskId;
//   String? notes;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     isAllCheck = false;
//     data.clear();
//     data = widget.maintenance;
//     todoViewBloc=TodoViewBloc();
//     for (var maintenanceItem in data) {
//       int maintenanceId = maintenanceItem['id'];
//       checkboxStates.putIfAbsent(maintenanceId, () => {});
//       for (var item in maintenanceItem['children'] ?? []) {
//         checkboxStates[maintenanceId]![item['id']] = true;
//         selectedDropdownValues[item['id']] = "Good";
//       }
//     }
//     setState(() {});
//   }
