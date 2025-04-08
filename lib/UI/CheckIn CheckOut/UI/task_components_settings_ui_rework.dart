import 'dart:developer';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_tabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';

class TaskComponentsSettingsUI extends StatelessWidget {
  const TaskComponentsSettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkingHoursBloc()..add(const TaskComponentsInitialEvent()),
      child: DefaultTabController(
          length: 2, initialIndex: 0, child: TaskComponentsSettingView()),
    );
  }
}

class TaskComponentsSettingView extends StatelessWidget {
  TaskComponentsSettingView({super.key});
  dynamic selectedBases;
  dynamic resource;
  TextEditingController taskNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController hourlyAmountController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    return BlocListener<WorkingHoursBloc, WorkingHoursState>(
      listener: (context, state) {
        if (state.isLoading) {
          EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          taskNameController.clear();
          amountController.clear();
          taskNameController.text = state.taskNameController?.text ?? '';
          amountController.text = state.amountController?.text ?? '';
          FocusScope.of(context).unfocus();
        }
      },
      child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
        builder: (context, state) {
         // log("${state.selectedResource}", name: 'TEST1');
          return Scaffold(
            backgroundColor: AppC.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppC.appColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Utils.getText("Task Components - Settings",
                        color: AppC.white, weight: FontWeight.bold, size: 18),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close_sharp, color: AppC.white),
                    )
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Utils.dropdownBox(
                        'Task based',
                        state.selectedBase1,
                        (value) {
                          selectedBases = value;
                          context.read<WorkingHoursBloc>().add(UpdateDropdownValueEvent(value));
                          tabController.animateTo(value['base'] == "Task based" ? 0 : 1);
                        },
                        labelKey: 'base',
                        initialSelection: state.selectedBase,
                      ),
                      const SizedBox(height: 16),
                      if ((selectedBases != null && selectedBases['base'] == 'Task based') ||
                          (state.selectedBase != null &&
                              state.selectedBase['base'] == 'Task based')) ...[
                        Utils.getTextFormField('Task Name',
                            taskNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Task Name required';
                            }
                            return null;
                          }
                        ),
                        const SizedBox(height: 16),
                        Utils.getTextFormField('Amount (\$)',
                          amountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Amount required';
                              }
                              return null;
                            }),
                        const SizedBox(height: 16),
                      ] else...[
                        Utils.dropdownBox(
                          'Select User',
                          state.userList,
                          (value) {
                            resource = value;
                            //print("Selected Resource: $resource");
                          },
                          labelKey: 'first_name',
                          labelKey2: 'last_name',
                          //selectedKey: state.selectedResource,
                          initialSelection: state.selectedUser,
                        ),
                        const SizedBox(height: 16),
                        Utils.getTextFormField(
                            'Amount per hour (\$)',
                            hourlyAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Amount required';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 30),
                      ],
                      Row(
                        children: [
                          if (!state.isEditMode)
                            Utils.getAddFilledButton("Save", () {
                              if (state.selectedBase['base'] == 'Task based' || selectedBases['base'] == 'Task based' ||
                                  taskNameController.text.isNotEmpty) {
                                FocusScope.of(context).unfocus();
                                if(formKey.currentState!.validate() && taskNameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                                  context.read<WorkingHoursBloc>().add(CreateTaskEvent(
                                      taskName: taskNameController.text.toString(),
                                      amount: amountController.text.toString(),
                                      task: 'task',
                                    ));
                                } else {
                                  Utils.showMobileToast("Please fill all required fields");
                                }
                              } else {
                                if (formKey.currentState!.validate() && hourlyAmountController.text.isNotEmpty &&
                                    resource != null) {
                                  context.read<WorkingHoursBloc>().add(CreateTaskEvent(
                                    taskName: '',
                                    amount: hourlyAmountController.text,
                                    task: 'hourly',
                                    userId: resource['id'] ?? state.selectedUser['id'],
                                  ));
                                } else {
                                  Utils.showMobileToast("Please fill all required fields");
                                }
                              }
                            }, bgColor: AppC.green),
                          if (state.isEditMode)
                            Utils.getAddFilledButton("Update", () {
                              FocusScope.of(context).unfocus();
                              context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                              if(state.userId == null)
                                {
                                  context.read<WorkingHoursBloc>().add(
                                      CreateTaskEvent(
                                          id: state.taskId,
                                          taskName: taskNameController.text.toString(),
                                          amount: amountController.text.toString(),
                                          task: 'task')
                                  );
                                } else {
                                context.read<WorkingHoursBloc>().add(
                                    CreateTaskEvent(
                                        id: state.taskId,
                                        amount: amountController.text.toString(),
                                        userId: resource['id'],
                                        task: 'hourly')
                                );
                              }
                            }, bgColor: AppC.green),
                          if (state.isEditMode) const SizedBox(width: 16),
                          if (state.isEditMode)
                            Utils.getAddFilledButton("Cancel", () {
                              //context.read<WorkingHoursBloc>().add(ResetResourceEvent());
                              //context.read<WorkingHoursBloc>().add(ResetDropdownEvent(isTaskBased: tabController.index == 0));
                              context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                            }, bgColor: AppC.red),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black26, width: 0.5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10 * 9, 0),
                          child: TabBar(
                            controller: tabController,
                            tabs: const [
                              Tab(text: 'Task Based', height: 30),
                              Tab(text: 'Hourly Based', height: 30),
                            ],
                            dividerColor: AppC.trans,
                            labelStyle: const TextStyle(fontSize: 12),
                            labelColor: AppC.appColor,
                            unselectedLabelColor: AppC.black,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1, color: AppC.appColor),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TaskTabsView(
                        taskbased: state.taskBased,
                        hourlybased: state.hourlyBased,
                        selectedBases: selectedBases,
                        resource: state.resources,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
