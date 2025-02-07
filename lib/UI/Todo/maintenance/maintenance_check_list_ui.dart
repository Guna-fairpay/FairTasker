
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Response/create_fix_task_data.dart';
import '../../../Response/create_todo_params.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class MaintenanceCheckListUI extends StatefulWidget {
  final List<Map<String, dynamic>> maintenance;
  final Map<String, dynamic> todoItems;

  const MaintenanceCheckListUI({super.key, required this.maintenance, required this.todoItems});

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
                          if (newValue == true) {
                            isAllCheck = true;
                            for (var maintenanceItem in data) {
                              int maintenanceId = maintenanceItem['id'];
                              checkboxStates.putIfAbsent(maintenanceId, () => {});
                              for (var item in maintenanceItem['children'] ?? []) {
                                checkboxStates[maintenanceId]![item['id']] = true;
                              }
                            }
                          } else {
                            isAllCheck = false;
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
                                        await Future.delayed(Duration.zero);
                                        try {
                                          maintenanceTaskId = '${maintenanceCheckListData['id']}-${item['id']}-$selectedId';
                                          notes = '${maintenanceCheckListData['name']}-${item['name']}-${selectedDropdownValues[item['id']]}';
                                          CreateFixTaskData createFixTaskData = CreateFixTaskData();
                                          createFixTaskData.userId=widget.todoItems['user_id'];
                                          createFixTaskData.userGroupId=int.parse(widget.todoItems['user_group_id']);
                                          createFixTaskData.title=item['id']==64?'Oil Change': 'Fix';
                                          createFixTaskData.maintenanceTaskId=maintenanceTaskId;
                                          createFixTaskData.notes=notes;
                                          createFixTaskData.todoTime=widget.todoItems['todo_time'];
                                          createFixTaskData.startAt=widget.todoItems['todo_date'];
                                          createFixTaskData.identifierId=item['id'] == 64 ? 126 : null;
                                          createFixTaskData.vehicleList=widget.todoItems['vehicles'];
                                          createFixTaskData.location=widget.todoItems['location'];
                                          createFixTaskData.locationId=widget.todoItems['location_id'];
                                          createFixTaskData.vendorId=widget.todoItems['vendor_id'];
                                          createFixTaskData.vendorName=widget.todoItems['vendor_name'];

                                          todoViewBloc!.add(AddFixTask(
                                            createFixTaskData: createFixTaskData,
                                          ));
                                          await Future.delayed(const Duration(seconds: 2));
                                          Utils.showMobileToast('Fix Task Created');
                                        } catch (e) {
                                          Utils.showMobileToast('Error creating task');
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
