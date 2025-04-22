import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/UI/category_config_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_view.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskTabBarUI extends StatelessWidget {
  const TaskTabBarUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) => Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: Num.borderWidthThinField)
                )
            ),
           child:  Row(
              children: [
                CustomTabButton(
                    buttonText: 'Task', value: 0, selectedValue: context.watch<TaskBloc>().selectedTab ,onPressed:(val)=> context.read<TaskBloc>().add(TaskTabChangeEvent(tabIndex: val))),
                CustomTabButton(
                    buttonText: 'Category Config',
                    value: 1,
                    selectedValue: context.watch<TaskBloc>().selectedTab,onPressed:(val)=> context.read<TaskBloc>().add(TaskTabChangeEvent(tabIndex: val))),
              ],
            ),
          ),
          if(context.watch<TaskBloc>().selectedTab == 0)
            const TaskView(),
          if(context.watch<TaskBloc>().selectedTab == 1)
            const CategoryConfigMainPage(),
        ],
      ),
    );
  }
}
