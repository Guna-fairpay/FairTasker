import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'task_component_form_field_page.dart';
part 'task_component_bottom_tab.dart';
part 'hourly_based_table.dart';
part 'task_based_table.dart';


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
          if (state is ErrorState) Toaster.showError(state.message);
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
