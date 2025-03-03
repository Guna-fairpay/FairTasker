
import 'dart:developer';
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
  const MaintenanceCheckListUI({super.key, required this.todoItems, required this.vehicle});

  Widget checkBoxWithSingleTextAndTexBox({
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    required String label,
  })
  {
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
    //print("TodoItems before event: $todoItems");
    //print("vehicle before event $vehicle");
    return BlocProvider(
      create: (context) => MaintenanceBloc()
        ..add(
          MaintenanceInitialEvent(
            todoItem: todoItems,
            vehicle: vehicle,
          ),
        ),
      child:
      BlocListener<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          log("${state.runtimeType}", name: "LOADING_CHECK");
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
          builder: (context, state) {
            log("State ${state.selectedDropdownValues}", name: "TESTING");
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Checkbox(
                          activeColor: AppC.blue,
                          value: state.isAllCheck,
                          onChanged: (value) => context.read<MaintenanceBloc>().add(
                            IsAllMaintenanceCheckEvent(value ?? false),
                          ),
                        ),
                      ),
                      Utils.getText(
                        'Is all maintenance check done',
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.maintenance?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final maintenanceCheckListData = state.maintenance![index];
                      var checkList = (maintenanceCheckListData['children'] as List?) ?? [];
                      List<dynamic> dropDownValue = checkList.isNotEmpty ? List.from(checkList[0]['children'] ?? []) : [];
                      if (!dropDownValue.any((element) => element['name'] == "Other") &&
                          maintenanceCheckListData['name'] != "Lights") {
                        dropDownValue.add({"id": 99, "name": "Other"});
                        dropDownValue.add({"id": 100, "name": "Not Checked"});
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Utils.getText(
                            "${maintenanceCheckListData['name'] ?? ''}".trim(), // Fluids, Routers, etc.
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
                                        checkboxValue: state.idList!.contains(int.parse(item['id'].toString())) ? false : true,
                                        //checkboxValue: state.individualCheckStates[item['name']] ?? false,
                                        onCheckboxChanged: (bool? value) {
                                          context.read<MaintenanceBloc>().add(
                                            IndividualCheckEvent(item['name'], value ?? false),
                                          );
                                          state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = value ?? false;
                                          if (value == true) {
                                            state.selectedDropdownValues[item['id']] = "Good";
                                          } else {
                                            state.selectedDropdownValues[item['id']] = "Bad";
                                          }
                                        },
                                        label: item['name'].trim() ?? '',
                                      ),
                                      if (item['name'] != 'Other')
                                        Expanded(
                                          child: Utils.dropdownBox(
                                            'Not Checked',
                                            dropDownValue,
                                                (value) {
                                              context.read<MaintenanceBloc>().add(
                                                DropDownOptionEvent(value),
                                              );
                                              state.selectedDropdownValues[item['id']] = value['name'];
                                              if (state.selectedDropdownValues[item['id']] == "Good") {
                                                state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = true;
                                              } else {
                                                state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = false;
                                              }
                                              log("value ${state.selectedDropdownValues}", name: "TESTING_SELECTED");
                                            },
                                            labelKey: 'name',
                                            initialSelection: dropDownValue.firstWhere(
                                                  (element) => element['name'] == state.selectedDropdownValues[item['id']],
                                              orElse: () => dropDownValue.isNotEmpty
                                                  ? dropDownValue.firstWhere(
                                                    (e) => e['name'] == 'Good',
                                                orElse: () => dropDownValue.first,
                                              ) : {"name": "Not Checked"},
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !(state.selectedDropdownValues[item['id']] == "Good"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Utils.getBorderedMultilineTextField(
                                          'Notes',
                                          state.notesControllers[item['id']] ?? TextEditingController(),
                                          minLines: 2,
                                        ),
                                        Utils.getAddFilledButton(
                                          'Create Task',
                                              () async {
                                            FocusScope.of(context).unfocus();
                                            if (state.selectedDropdownValues[item['id']] == null) {
                                              Utils.showMobileToast('Please select a valid option');
                                              return;
                                            }
                                            context.read<MaintenanceBloc>().add(
                                              createFixTaskEvent(
                                                  maintenanceTaskId: '${maintenanceCheckListData['id']}-${item['id']}-${dropDownValue.firstWhere((e) => e['name'] == state.selectedDropdownValues[item['id']],)['id']}',
                                                  notes: '${maintenanceCheckListData['name']}-${item['name']}-${state.selectedDropdownValues[item['id']] ?? "Unknown"}',
                                                  comments: state.notesControllers[item['id']]!.text,
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
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
                  const SizedBox(height: 10),
                  Utils.getBorderedMultilineTextField(
                    'Notes',
                    context.read<MaintenanceBloc>().notesController,
                    fillColor: AppC.white,
                  ),
                ],
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

