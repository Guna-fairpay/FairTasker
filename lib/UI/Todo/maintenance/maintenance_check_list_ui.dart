import 'dart:developer';
import 'dart:math' as m;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import 'maintenance_bloc.dart';
import 'maintenance_checklist_popup.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceCheckListUI extends StatelessWidget {
  final dynamic todoItems, vehicle;

  const MaintenanceCheckListUI(
      {super.key, required this.todoItems, required this.vehicle}
      );


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
            log("${vehicle}", name: "VEHICLE_DATA");
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
                        //log("${state.maintenance![index]}", name: "MAINTENANCE_CHECKLIST");
                        final maintenanceCheckListData =
                            state.maintenance![index];
                        var checkList = (maintenanceCheckListData['children'] as List?) ?? [];

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
                                              !(
                                                  (state.dropdownValue is List ? (state.dropdownValue as List).any((element) =>
                                                  element['name'].toString().toLowerCase() == "good") : false)
                                                      ||
                                                  List.from(item['children']).any(
                                                          (element) =>
                                                      state.initialDropDown?.map((e) => e['id'].toString()).contains(element['id'].toString()) ??
                                                          false) ||

                                                  ((state.idList?.contains(int.tryParse(item['id'].toString())) ?? false)
                                                  ||
                                                  (state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] == true ? false : true))

                                              ),
                                              onCheckboxChanged: (bool? value) async {
                                                if (state.middleValues.where((element) => element == item['id'].toString()).isNotEmpty) {
                                                  MaintenanceChecklistPopup.show(context,
                                                    onCompleted: ()=> context.read<MaintenanceBloc>().add(const CompleteTodoItemEvent()),
                                                    onDelete: ()=> context.read<MaintenanceBloc>().add(const DeleteTodoItemEvent())
                                                  );
                                                }
                                                context.read<MaintenanceBloc>().add(
                                                  IndividualCheckEvent(
                                                      item['id'].toString(),
                                                      value ?? false,
                                                    item: item
                                                  ),
                                                );
                                                state.selectedDropdownValues[item['id']] = value == true ? "Good" : "Bad";
                                                await Future.delayed(Durations.medium2);
                                                //log("state.individualCheckStates ${state.individualCheckStates[item['id']]} ${state.dropdownValue}", name: "CHECKING_VALUE");
                                              },
                                              label: item['name'].trim() ?? '',
                                        ),
                                        if (item['name'] != 'Other')
                                          Expanded(
                                            child:
                                            Utils.dropdownBox(
                                              'Not Checked',
                                              List<Map<String, dynamic>>.from(
                                                  item['children']
                                              )..addAll([
                                                {
                                                  "id": 99,
                                                  "name": "Other"
                                                },
                                                {
                                                  "id": m.Random().nextInt(99),
                                                  "name": "Not Checked"
                                                }
                                              ]),
                                                  (value) {
                                                context.read<MaintenanceBloc>().add(DropDownOptionEvent(value));
                                                state.selectedDropdownValues[item['id']] = value['name'];
                                                if (state.selectedDropdownValues[item['id']] == "Good") {
                                                  state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = true;
                                                } else {
                                                  state.checkboxStates[maintenanceCheckListData['id']]?[item['id']] = false;
                                                }
                                                if (state.dropdownValue.where((element) => element == item['id'].toString()).isNotEmpty) {
                                                  MaintenanceChecklistPopup.show(context,
                                                      onCompleted: () => context.read<MaintenanceBloc>().add(const CompleteTodoItemEvent()),
                                                      onDelete: () => context.read<MaintenanceBloc>().add(const DeleteTodoItemEvent())
                                                  );
                                                }

                                                log("value ${state.selectedDropdownValues}", name: "TESTING_SELECTED");
                                                log("value ${state.initialDropDown}", name: "INITIAL_DROP_DOWN");
                                                log("${(state.idList?.contains(item['id']) ?? false)} ${state.idList} ${item['id']}", name: "CHECKING_VALUE");
                                              },
                                              labelKey: 'name',
                                              initialSelection: state.dropdownValue ?? // Use the emitted dropdownValue
                                                  (List.from(item['children']).firstWhere(
                                                        (element) => element['name'].toString().toLowerCase() == "good",
                                                    orElse: () => {"id": 99, "name": "Not Checked"},
                                                  )),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                    (List.from(item['children']).any(
                                            (element) =>
                                        state.initialDropDown?.map((e) => e['id'].toString()).contains(element['id'].toString()) ??
                                            false)) ||
                                        ((state.dropdownValue is List &&
                                            (state.dropdownValue as List).any((element) =>
                                            element['name'].toString().toLowerCase().trim() != "good")) ||
                                            (state.selectedDropdownValues[item['id']]?.toString().toLowerCase() != "good")
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 40.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Utils.getBorderedMultilineTextField(
                                            'Notes',
                                            state.notesControllers?[item['id']] ?? TextEditingController(),
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
                                                      '${maintenanceCheckListData['id']}-${item['id']}-${item['children'].where(
                                                                  (e) => e['name'] == state.selectedDropdownValues[item['id']]).isEmpty
                                                          ? 0
                                                          : item['children'].firstWhere(
                                                                  (e) => e['name'] == state.selectedDropdownValues[item['id']])['id']
                                                      }',
                                                      notes:
                                                          '${maintenanceCheckListData?['name'] ?? 'Other'}-${item?['name'] ?? ''}-${state.selectedDropdownValues[item['id']] ?? "Unknown"}',
                                                      comments: state.notesControllers[item['id']]!.text,
                                                      item: item['id'],
                                                      todoId: todoItems['id'],
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
