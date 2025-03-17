
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
      create: (context) => WorkingHoursBloc()..add(const TaskComponentsInitialEvent()),
      child: DefaultTabController(
        length: 2,
          initialIndex: 0,
          child: TaskComponentsSettingView()
      ),
    );
  }
}

class TaskComponentsSettingView extends StatelessWidget {
  TaskComponentsSettingView({super.key});
  dynamic selectedBase1 = {"base": "Task based"};
  dynamic selectedBases;
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);


    return BlocListener<WorkingHoursBloc, WorkingHoursState>(
      listener: (context, state) {
        if (state.isLoading) {
          EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
        }
      },
      child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
        builder: (context, state) {
          return
            SafeArea(
            child: Scaffold(
              backgroundColor: AppC.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child:
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppC.appColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.getText("Task Components - Settings", color: AppC.white, weight: FontWeight.bold, size: 18),
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
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Utils.dropdownBox(
                      selectedBase1['base'] ?? 'Task based',
                      [
                        {"base": "Task based"},
                        {"base": "Hourly based"},
                      ],
                          (value) {
                            selectedBase1=value;
                            selectedBases=value;
                            print("selectedBases ${selectedBases}");
                        tabController.animateTo(value['base'] == "Task based" ? 0 : 1);
                      },
                      labelKey: 'base',initialSelection: selectedBase1,
                    ),
                    const SizedBox(height: 16),
                    Utils.getTextFormField('Task Name',_taskNameController),
                    const SizedBox(height: 16),
                    Utils.getTextFormField('Amount (\$)', _amountController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Utils.getAddFilledButton("Save", () {
                          // Handle save

                          if(selectedBases['base']=='Task based' && _taskNameController.text.isNotEmpty)
                            {
                              FocusScope.of(context).unfocus();
                              context.read<WorkingHoursBloc>().add(CreateTaskEvent(
                                  name: _taskNameController.text.toString(),
                                  amount: _amountController.text.toString(),
                                  task: 'task')
                              );
                            } else {
                            if (_amountController.text.isNotEmpty && selectedBases['base'] != null)
                              {
                                context.read().add(const CreateTaskEvent());
                              } else {
                              {
                                print("Error in saving");
                              }
                            }
                          }

                        }, bgColor: AppC.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
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
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TaskTabsView(
                      taskbased: state.taskBased,
                      hourlybased: state.hourlyBased,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
