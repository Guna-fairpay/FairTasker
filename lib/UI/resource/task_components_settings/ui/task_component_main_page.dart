
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_bloc.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_event.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_state.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/ui/task_component_bottom_tab.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/ui/task_component_form_field_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskComponentsMainPage extends StatelessWidget {
  const TaskComponentsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Component - Settings',),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: AppC.white),
        automaticallyImplyLeading: false,
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        actions: [
          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)),
        ],
      ),
      body: BlocProvider(create: (context)=>TaskComponentBloc()..add(TaskComponentInitialEvent()),
      child: BlocListener<TaskComponentBloc, TaskComponentState>(
        listener: (context, state) {
          if (state is TaskComponentLoadingState) EasyLoading.show();
          if (state is TaskComponentCommentState) EasyLoading.dismiss();
        },
          child: SafeArea(
            minimum: 16.padding,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children:  [
                if(getIt<CommonService>().isAdmin)...[
                const TaskComponentFormFieldPage(),
                20.height,],
                const TaskComponentBottomTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
