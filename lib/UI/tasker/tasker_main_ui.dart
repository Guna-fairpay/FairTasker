import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/UI/tasker/sub_pages/tasker_listing_ui.dart';
import 'package:fairpytasker/UI/tasker/task_components/tasker_header.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerMainUi extends StatelessWidget {
  const TaskerMainUi({super.key});

  @override
  Widget build(BuildContext _) {
    return BlocProvider<ToDoTaskerBloc>(create: (_) => ToDoTaskerBloc()..add(ToDoTaskerInitialEvent()),
      child: BlocListener<ToDoTaskerBloc, ToDoTaskerState>(listener: (context, state) {
        if (state is ToDoTaskerLoadingState) {
          EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          switch (state) {
            case ToDoTaskerSuccessState(): Toaster.showSuccess("${state.message}"); break;
            case ToDoTaskerErrorState(): Toaster.showSuccess("${state.message}"); break;
            case ToDoTaskerDatePickerState(): Utils.showPickerDate(context, value: context.read<ToDoTaskerBloc>().selectedDate, onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateFilterEvent(val))); break;
          }
        }
      },
        child: const SafeArea(
            child: Column(
              children: [
                TaskerHeader(),
                TaskerListingUi(),
              ],
            )),
      ),
    );
  }
}
