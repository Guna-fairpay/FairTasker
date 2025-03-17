import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/edit_todo_rework_ui.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_dialog.dart';
import 'package:fairpytasker/UI/dialog/vendor_info_dialog.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/UI/tasker/sub_pages/tasker_listing_ui.dart';
import 'package:fairpytasker/UI/tasker/task_components/tasker_header.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popover/popover.dart';

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
            case ToDoTaskerErrorState(): Toaster.showError("${state.message}"); break;
            case ToDoTaskerDatePickerState(): Utils.showPickerDate(context, value: context.read<ToDoTaskerBloc>().selectedDate, onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateFilterEvent(val))); break;
            case ToDoTaskerAddToDoState(): context.push(const CreateTodoUI(),fullscreenDialog: true); break;
            case ToDoTaskerMicState(): Toaster.showInfo("MIC PRESSED"); break;
            case ToDoTaskerEditState(): context.push(EditTodoReworkUI(todoId: state.toDoId),fullscreenDialog: true); break;
            case ToDoTaskerTapUserFilterState(): break;
            case ToDoTaskerTapVehicleFilterState(): TaskerVehicleSearchDialog.show(context); break;
            case ToDoTaskerVendorInfoState(): VendorInfoDialog.show(context, state.model); break;
            case ToDoTaskerNotesTapState(): NotesDialog.show(context, message: state.model?['notes']); break;
            default: break;
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
