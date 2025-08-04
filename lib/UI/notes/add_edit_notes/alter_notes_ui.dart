import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/UI/dialog/multioption_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/popup/resource_selection_popup.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/alter_notes_body.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/bloc/alter_notes_bloc.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlterNotesUi extends StatelessWidget {
  final dynamic noteId;
  final DateTime selectedDate;
  const AlterNotesUi({super.key, this.noteId, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        backgroundColour: AppC.appColor,
        foregroundColour: AppC.white,
        onClose: context.pop,
        automaticallyImplyleading: false,
        titleText: (noteId.toString().isNullOrEmpty) ? "Add Notes" : "Edit Notes",
      ),
      body: BlocProvider(
        create: (context) =>
            AlterNotesBloc()..add(AlterNotesInitialEvent(noteId, selectedDate)),
        child: BlocListener<AlterNotesBloc, AlterNotesStates>(
          listener: (context, state) {
            if (state is AlterNotesLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              if (state is! AlterNotesCommonState) Utils.dismissKeyboard(context);
              switch (state){
                case PickSharingUsersState(): ResourceSelectionPopup.show(context, omitCurrentUser: true, offset: state.offset, selectedResourceIds: state.selectedUserIds ,onChanged: (value) => context.read<AlterNotesBloc>().add(PickSharingUsersEvent(state.model, selectedUsers: value))); break;
                case ViewTimePickerState(): Utils.showPickerTime(context, is24Hr: true, value: state.model?['note_time'].toString().toTimeOfDay(inputFormat: "HH:mm:ss"), onChanged: (value) => context.read<AlterNotesBloc>().add(ViewTimePickerEvent(state.model, time: value))); break;
                case AlterNotesRemovePermissionState(): NotesMultiOptionDialog.show(context, model: state.model, showTask: state.showTask, showNotes: state.showNotes, onChanged: (value) => context.read<AlterNotesBloc>().add(AlterNotesDeleteEvent(state.model, value))); break;
                case AlterNotesTapUserState(): ResourceSelectionPopup.show(context, offset: state.offset, selectedResourceIds: state.selectedUserIds ,onChanged: (value) => context.read<AlterNotesBloc>().add(AlterNotesUserSelectionEvent(state.model, value))); break;
                case AlterNotesErrorState(): Toaster.showError(state.message); break;
                case AlterNotesCloseState(): context.pop(); break;
              }
            }
          },
          child: SafeArea(minimum: 16.spMin.padding, child: const AlterNotesBody()),
        ),
      ),
    );
  }
}
