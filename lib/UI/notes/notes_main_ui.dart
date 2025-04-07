import 'package:fairpytasker/Component/date_switcher.dart';
import 'package:fairpytasker/Component/search_with_status_add_view.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/notes_task_edit_add_dialog.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_bloc.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_events.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_states.dart';
import 'package:fairpytasker/UI/notes/notes_body_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              case NotesErrorState():
                Toaster.showError(state.error);
                break;
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
              case NotesEditTaskTapState(): NotesTaskAddEditDialog.show(context, model: state.data, onChanged: (value) => context.read<NotesBloc>().add(NotesUpdateTaskEvent(state.data, value)), isEdit: true); break;
              case NotesCheckTapState(): AskPermissionDialog.show(context, description: "Are you sure want to complete the task/notes", positiveText: "Yes", negativeText: "Cancel", onPositivePressed: () => context.read<NotesBloc>().add(NotesCheckEvent(state.data, isAll: state.isAll, status: state.status))); break;
            }
          }
        },
        child: Padding(
          padding: 5.sp.padding,
          child: Column(
            spacing: 5,
            children: [
              BlocSelector<NotesBloc, NotesStates, NotesStates>(
                selector: (state) => state,
                builder: (context, state) => DateSwitcherView(
                    selectedDate: context.watch<NotesBloc>().selectedDate,
                    onCurrentDay: () =>
                        context.read<NotesBloc>().add(NotesDatePickerEvent()),
                    onNextDay: () =>
                        context.read<NotesBloc>().add(NotesNextDayEvent()),
                    onPreviousDay: () =>
                        context.read<NotesBloc>().add(NotesPreviousDayEvent())),
              ),
              BlocSelector<NotesBloc, NotesStates, NotesStates>(
                selector: (state) => state,
                builder: (context, state) => SearchWithStatusAddView(
                  controller: context.read<NotesBloc>().searchController,
                  value: context.watch<NotesBloc>().showCompletedStates,
                  onAddPressed: () =>
                      context.read<NotesBloc>().add(NotesAddNewEvent()),
                  onChanged: (value) =>
                      context.read<NotesBloc>().add(NotesFilterEvent(value)),
                  onSearchChanged: (value) =>
                      context.read<NotesBloc>().add(NotesSearchEvent(value)),
                ),
              ),
              // const EmptyWidget(),
              const NotesBodyUi(),
            ],
          ),
        ),
      ),
    );
  }
}
