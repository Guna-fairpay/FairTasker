import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/notes_item_card.dart';
import 'package:fairpytasker/Component/search_with_status_add_view.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/notes_task_edit_add_dialog.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/alter_notes_ui.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_bloc.dart';
import 'package:fairpytasker/UI/notes/component/delete_dialog.dart';
import 'package:fairpytasker/UI/notes/shared_notes/ui/shared_notes_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'notes_header.dart';
part 'notes_body_ui.dart';
part 'notes_body.dart';

class NotesMainUi extends StatelessWidget {
  const NotesMainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc()..add(NotesInitialEvent()),
      child: BlocListener<NotesBloc, NotesStates>(
        listener: (context, state) {
          if (state is NotesLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case NotesErrorState():Toaster.showError(state.error);break;
              case SuccessState(): context.pop(); break;
              case NotesDatePickerState():
                Utils.showPickerDate(context,
                    value: state.date,
                    onChanged: (value) =>
                        context.read<NotesBloc>().add(NotesDateEvent(value)));
                break;
              case NotesDeletePermissionState():
                AskPermissionDialog.show(context,
                    title: "Are you sure ?",
                    description: "Do you want to delete this task/notes?",
                    positiveText: "Yes, delete it!",
                    negativeText: "Cancel", onPositivePressed: () => context.read<NotesBloc>().add(NotesDeleteEvent(state.data)));
                break;
              case NotesAddTaskTapState(): NotesTaskAddEditDialog.show(context, model: state.data, onChanged: (value) => context.read<NotesBloc>().add(NotesAddTaskEvent(state.data, value))); break;
              case NotesEditTaskTapState(): NotesTaskAddEditDialog.show(context, model: state.data, onChanged: (value) => context.read<NotesBloc>().add(NotesUpdateTaskEvent(state.data, value)), isEdit: true, onDeletePressed: () => context.read<NotesBloc>().add(DeleteEvent(state.data)), onTimePicker: (value) => context.read<NotesBloc>().add(TimePickerEvent(value))); break;
              case NotesCheckTapState(): AskPermissionDialog.show(context, description: "Are you sure want to complete the task/notes", positiveText: "Yes", negativeText: "No", onPositivePressed: () => context.read<NotesBloc>().add(NotesCheckEvent(state.data, isAll: state.isAll, status: state.status))); break;
              case NotesAddNewState(): context.push(AlterNotesUi(noteId: state.noteId, selectedDate: state.selectedDate), fullscreenDialog: true); break;
              case TimePickerState(): Utils.showPickerTime(context, is24Hr: true, value: state.model?['note_time'].toString().toTimeOfDay(inputFormat: "HH:mm:ss"), onChanged: (value) => context.read<NotesBloc>().add(UpdateTimeEvent(state.model, value)));
              case DeleteNoteState(): DeleteDialog.show(context, onChanged: () => context.read<NotesBloc>().add(RemoveEvent(state.data)));
            }
          }
        },
        child: Padding(
          padding: 5.sp.padding,
          child: const Column(
            spacing: 5,
            children: [
              NotesHeader(),
              NotesBody(),
            ],
          ),
        ),
      ),
    );
  }
}
