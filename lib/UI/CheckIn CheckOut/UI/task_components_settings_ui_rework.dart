import 'dart:developer';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_tabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/prefs.dart';
import '../../../Utilities/utils.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'Popups/resource_listing_dropdown.dart';


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
  dynamic selectedBases;
  dynamic resource;
  TaskComponentsSettingView({super.key});
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
          log("${state.selectedBase}");
          Utils.dismissKeyboard(context);
        }
      },
      child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (tabController.indexIsChanging) {
              final isHourly = tabController.index == 1;
              context.read<WorkingHoursBloc>().add(SwitchTabEvent(isHourly: isHourly));
            }
          });
          final isHourlyBased = state.selectedBase?['base'].toString() == 'Hour based';
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
            body:
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: KeyedSubtree(
                  key: ValueKey(state.uniqueId),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')
                        Utils.dropdownBox(
                          'Task based',
                          state.selectedBase1,
                          (value) {
                            selectedBases = value;
                            log("${selectedBases} ${state.selectedBase} selected base");
                            context.read<WorkingHoursBloc>().add(UpdateDropdownValueEvent(value));
                            tabController.animateTo(value['base'] == "Task based" ? 0 : 1);
                            formKey.currentState!.reset();
                          },
                          labelKey: 'base',
                          initialSelection:state.selectedBase,
                        ),
                        const SizedBox(height: 16),
                        if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')...[
                          if(!isHourlyBased) ...[
                            Utils.getTextFormField('Task Name',
                                context.read<WorkingHoursBloc>().taskNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Task Name required';
                                  }
                                  return null;
                                }
                            ),
                            const SizedBox(height: 16),
                              Utils.getTextFormField('Amount (\$)',
                                  context.read<WorkingHoursBloc>().amountController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Amount required';
                                    }
                                    return null;
                                  }),
                            const SizedBox(height: 16),
                          ] else...[
                            if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppC.trans),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Utils.dropdownBox(
                                  'Select User',
                                  state.userList,
                                      (value) {
                                    if (value == null) {
                                      context.read<WorkingHoursBloc>().add(const ClearResourceSelectionEvent());
                                    } else {
                                      resource = value;
                                      context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
                                        userId: value['id'],
                                        amount: context.read<WorkingHoursBloc>().hourlyAmountController.text,
                                      ));
                                    }
                                  },
                                  labelKey: 'first_name',
                                  labelKey2: 'last_name',
                                  initialSelection: state.isEditMode ? state.selectedUser is Map<String, dynamic> ? state.selectedUser : null : null,
                                  selectedKey: ValueKey('dropdown-${state.uniqueId}'),
                                ),
                              ),
                            const SizedBox(height: 16),
                              Utils.getTextFormField(
                                  'Amount per hour (\$)',
                                  context.read<WorkingHoursBloc>().hourlyAmountController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Amount required';
                                    }
                                    return null;
                                  }
                              ),
                            const SizedBox(height: 30),
                          ],
                        ],
                        if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')
                        Row(
                          children: [
                            if (!state.isEditMode)
                              Utils.getAddFilledButton("Save", () {
                                context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                                if (state.selectedBase['base'] == 'Task based' || context.read<WorkingHoursBloc>().taskNameController.text.isNotEmpty) {
                                  FocusScope.of(context).unfocus();
                                  if(formKey.currentState!.validate() && context.read<WorkingHoursBloc>().taskNameController.text.isNotEmpty && context.read<WorkingHoursBloc>().amountController.text.isNotEmpty) {
                                    context.read<WorkingHoursBloc>().add(CreateTaskEvent(
                                        taskName: context.read<WorkingHoursBloc>().taskNameController.text.toString(),
                                        amount: context.read<WorkingHoursBloc>().amountController.text.toString(),
                                        task: 'task',
                                      ));
                                    formKey.currentState!;
                                  }
                                } else {
                                  if (formKey.currentState!.validate() && context.read<WorkingHoursBloc>().hourlyAmountController.text.isNotEmpty) {
                                    context.read<WorkingHoursBloc>().add(CreateTaskEvent(
                                      taskName: '',
                                      amount: context.read<WorkingHoursBloc>().hourlyAmountController.text,
                                      task: 'hourly',
                                      userId: state.selectedUser?['id'] ?? resource['id'],
                                    ));
                                  }
                                }
                              }, bgColor: AppC.green),
                            if (state.isEditMode)
                              Utils.getAddFilledButton("Update", () {
                                FocusScope.of(context).unfocus();
                                context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                                if(state.userId == -1)
                                  {
                                    log("${context.read<WorkingHoursBloc>().taskNameController.text} ${context.read<WorkingHoursBloc>().amountController.text} update_button");
                                    context.read<WorkingHoursBloc>().add(
                                        CreateTaskEvent(
                                            id: state.taskId,
                                            taskName: context.read<WorkingHoursBloc>().taskNameController.text.toString(),
                                            amount: context.read<WorkingHoursBloc>().amountController.text.toString(),
                                            task: 'task')
                                    );
                                  } else {
                                  context.read<WorkingHoursBloc>().add(
                                      CreateTaskEvent(
                                          id: state.taskId,
                                          amount: context.read<WorkingHoursBloc>().hourlyAmountController.text.toString(),
                                          userId: resource?['id'] ?? state.userId,
                                          task: 'hourly')
                                  );
                                }
                              }, bgColor: AppC.green),
                            if (state.isEditMode) const SizedBox(width: 16),
                            if (state.isEditMode)
                              Utils.getAddFilledButton("Cancel", () {
                                FocusScope.of(context).unfocus();
                                context.read<WorkingHoursBloc>().add(const ResetAllEvent());
                                resource = null;
                                //context.read<WorkingHoursBloc>().add(ResetResourceEvent());
                                //context.read<WorkingHoursBloc>().add(ResetDropdownEvent(isTaskBased: tabController.index == 1));
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
                          Globalkey: formKey,
                          taskbased: state.taskBased,
                          hourlybased: state.hourlyBased,
                          selectedBases: selectedBases,
                          resource: state.resources,
                            loginUserId: state.loginUserId,
                            loginUserRole: state.loginUserRole,
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
    );
  }
}