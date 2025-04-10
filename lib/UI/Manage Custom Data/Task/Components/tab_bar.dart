import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_view.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskTabBarUI extends StatelessWidget {
  const TaskTabBarUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task & Category Config'),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        titleSpacing: 0,
      ),
      body: BlocProvider<TaskBloc>(
        create: (context) => TaskBloc()..add(TaskInitialEvent()),
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {},
          child: SafeArea(
            minimum: 16.sp.padding,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: Num.borderWidthThinField)),
                  ),
                  child: const Row(
                    children: [
                      CustomTabButton(
                          buttonText: 'Task', value: 0, selectedValue: 0),
                      CustomTabButton(
                          buttonText: 'Category Config',
                          value: 1,
                          selectedValue: 0),
                    ],
                  ),
                ),
                // if(selectedValue == 0)
                TaskView(),
                /*if(selectedValue == 1)
                  CategoryConfigViewUI(),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
