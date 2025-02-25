
import 'dart:developer';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Response/create_fix_task_data.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class MaintenanceCheckListUI extends StatefulWidget {
  final List<Map<String, dynamic>> maintenance;
  final Map<String, dynamic> todoItems;
  late final Map<String, dynamic> vehicle;

  MaintenanceCheckListUI({super.key, required this.maintenance, required this.todoItems, required this.vehicle})
  {
    //log("${maintenance}", name: "MAINTENANCE_LIST");
    log("${vehicle['vehicle_number']}", name: "vehicle data is");
  }

  @override
  State<MaintenanceCheckListUI> createState() => _MaintenanceCheckListUIState();
}

class _MaintenanceCheckListUIState extends State<MaintenanceCheckListUI> {

  TodoViewBloc? todoViewBloc;
  bool isAllCheck = false;
  TextEditingController notesController = TextEditingController();
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> data = [];
  List<dynamic> maintenanceListData = [];
  Map<int, Map<int, bool>> checkboxStates = {};
  Map<dynamic, String> selectedDropdownValues = {};
  int? selectedId;
  String? maintenanceTaskId;
  String? notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isAllCheck = true;
    data.clear();
    data = widget.maintenance;
    todoViewBloc=TodoViewBloc();
    for (var maintenanceItem in data) {
      int maintenanceId = maintenanceItem['id'];
      checkboxStates.putIfAbsent(maintenanceId, () => {});
      for (var item in maintenanceItem['children'] ?? []) {
        checkboxStates[maintenanceId]![item['id']] = true;
        selectedDropdownValues[item['id']] = "Good";
      }
    }
    setState(() {});
  }
  @override
  void didUpdateWidget(covariant MaintenanceCheckListUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maintenance != widget.maintenance) {
      data = widget.maintenance;
      todoViewBloc=TodoViewBloc();
      for (var maintenanceItem in data) {
        int maintenanceId = maintenanceItem['id'];
        checkboxStates.putIfAbsent(maintenanceId, () => {});

        for (var item in maintenanceItem['children'] ?? []) {
          checkboxStates[maintenanceId]![item['id']] = true;
          selectedDropdownValues[item['id']] = "Good";
        }
      }
      isAllCheck = true;
      setState(() {});
    }
  }

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
    return Stack(
      children: [
        Padding(
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
                      value: isAllCheck,
                      onChanged: (bool? newValue) {
                        setState(() {

                          isAllCheck = newValue ?? false;
                          for (var maintenanceItem in data) {
                            int maintenanceId = maintenanceItem['id'];
                            checkboxStates.putIfAbsent(maintenanceId, () => {});
                            for (var item in maintenanceItem['children'] ?? []) {
                              checkboxStates[maintenanceId]![item['id']] = isAllCheck;
                              if (!isAllCheck) {
                                selectedDropdownValues[item['id']] = "Bad";
                              } else {
                                selectedDropdownValues[item['id']] = "Good";
                              }
                            }
                          }
                        });
                      },
                    ),
                  ),
                  Utils.getText('Is all maintenance check done',weight: FontWeight.bold),
                ],
              ),
              const SizedBox(height: 10),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  final maintenanceCheckListData = data[index];
                  var checkList = (maintenanceCheckListData['children'] as List?) ?? [];
                  List<dynamic> dropDownValue = checkList.isNotEmpty
                      ? List.from(checkList[0]['children'] ?? [])
                      : [];
                  if (!dropDownValue.any((element) => element['name'] == "Other") && maintenanceCheckListData['name'] != "Lights") {
                    dropDownValue.add({"id":99,"name": "Other",});
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Utils.getText("${maintenanceCheckListData['name'] ?? ''}".trim(),weight: FontWeight.bold),

                      for (var item in checkList) ...[
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                spacing: 10,
                                children: [
                                  checkBoxWithSingleTextAndTexBox(
                                    checkboxValue: checkboxStates[maintenanceCheckListData['id']]?[item['id']] ?? false,
                                    onCheckboxChanged: (bool? value) {
                                      setState(() {
                                        checkboxStates.putIfAbsent(maintenanceCheckListData['id'], () => {});
                                        checkboxStates[maintenanceCheckListData['id']]![item['id']] = value ?? false;
                                        if (value == true) {
                                          selectedDropdownValues[item['id']] = "Good";
                                        } else {
                                          selectedDropdownValues[item['id']] = "Bad";
                                          //selectedDropdownValues.remove(item['id']);
                                        }
                                      });
                                    },
                                    label: item['name'].trim() ?? '',
                                  ),
                                  if(item['name'] != 'Other')
                                  Expanded(
                                    child: Utils.dropdownBox(
                                      'Not Checked',
                                      dropDownValue,
                                          (value) {
                                        setState(() {
                                          selectedDropdownValues[item['id']] = value['name'];
                                          selectedId = value['id'];
                                          if (selectedDropdownValues[item['id']] == "Good") {
                                            checkboxStates[maintenanceCheckListData['id']]![item['id']] = true;
                                          } else {
                                            checkboxStates[maintenanceCheckListData['id']]![item['id']] = false;
                                          }
                                        });
                                      },
                                      labelKey: 'name',
                                      initialSelection: dropDownValue.firstWhere(
                                            (element) => element['name'] == selectedDropdownValues[item['id']],
                                        orElse: () =>{},/*dropDownValue.first*/
                                    ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:!(checkboxStates[maintenanceCheckListData['id']]?[item['id']] ?? true) || selectedDropdownValues[item['id']] != "Good" ,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Utils.getBorderedMultilineTextField(
                                        'Notes',
                                        controller,
                                      minLines: 2,
                                    ),
                                    Utils.getAddFilledButton(
                                      'Create Task',
                                          () async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        try {
                                          if (selectedId == null) {
                                            Utils.showMobileToast('Please select a valid option');
                                            return;
                                          }
                                          maintenanceTaskId = '${maintenanceCheckListData['id']}-${item['id']}-$selectedId';
                                          notes = '${maintenanceCheckListData['name']}-${item['name']}-${selectedDropdownValues[item['id']] ?? "Unknown"}';
                                          CreateFixTaskData createFixTaskData = CreateFixTaskData()
                                            ..userId = widget.todoItems['user_id']
                                            ..userGroupId = int.tryParse(widget.todoItems['user_group_id']?.toString() ?? '0') ?? 0
                                            ..title = item['id'] == 64 ? 'Oil Change' : 'Fix'
                                            ..maintenanceTaskId = maintenanceTaskId
                                            ..notes = notes
                                            ..todoTime = widget.todoItems['todo_time']
                                            ..startAt = widget.todoItems['todo_date']
                                            ..identifierId = item['id'] == 64 ? 126 : null
                                            ..vehicleList = widget.todoItems['vehicles']
                                            ..location = widget.todoItems['location']
                                            ..locationId = widget.todoItems['location_id']
                                            ..vendorId = widget.todoItems['vendor_id']
                                            ..vendorName = widget.todoItems['vendor_name']
                                            ..vehicleNumber = widget.vehicle['vehicle_number'];

                                          todoViewBloc!.add(AddFixTask(createFixTaskData: createFixTaskData));
                                          await Future.delayed(const Duration(seconds: 2));
                                          Utils.showMobileToast('Fix Task Created');

                                        } catch (e, stackTrace) {
                                          log("Error creating task: $e\n$stackTrace", name: "TASK ERROR");
                                          Utils.showMobileToast('Error creating task: $e');
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
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
                  notesController,
                  fillColor: AppC.white,
                ),
              ],
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.transparent, // Dim background
              child: Center(
                child: Utils.getProgressIndicator(context),
              ),
            ),
          ),
      ],
    );
  }



}
