import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_tab_bar.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../Bloc/task_event.dart';

class TaskMainPage extends StatelessWidget {
final String? title;
  const TaskMainPage({super.key,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task & Category Config'),
        titleTextStyle:
        context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        titleSpacing: 0,
      ),
      body: BlocProvider<TaskBloc>(
        create: (context) => TaskBloc()..add(TaskInitialEvent()),
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
            if (state is TaskCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
          },
          child: SafeArea(
            minimum: 16.sp.padding,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: const [
                TaskTabBarUI(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
