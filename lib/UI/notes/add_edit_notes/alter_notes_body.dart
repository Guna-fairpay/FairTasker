import 'package:fairpytasker/Component/notes_task_component.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/bloc/alter_notes_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlterNotesBody extends StatelessWidget {
  const AlterNotesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlterNotesBloc, AlterNotesStates>(
      builder: (context, state) => Form(
        key: context.read<AlterNotesBloc>().formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getTextFormField(
                "Note Title", context.read<AlterNotesBloc>().titleController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    (value?.trim().isNullOrEmpty ?? false) ? "Required" : null),
            Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => 10.sp.height,
                      itemBuilder: (context, index) {
                        var model = context.watch<AlterNotesBloc>().noteItems[index];
                        return NotesTaskComponent(
                          model: model,
                          taskController: (model['title'] as TextEditingController),
                          notesController: (model['description'] as TextEditingController),
                          showComplete: context.watch<AlterNotesBloc>().editModel != null,
                          showRemove: context.watch<AlterNotesBloc>().noteItems.length > 1,
                          onCompleteTask: (value, data) => context.read<AlterNotesBloc>().add(AlterNotesCompleteEvent(data, value)),
                          onCreateTask: (value) => context.read<AlterNotesBloc>().add(AlterNotesCreateUpdateTaskEvent(value)),
                          onRemoveTask: (value) => context.read<AlterNotesBloc>().add(AlterNotesRemoveEvent(value)),
                          onShowHideNotes: (value) => context.read<AlterNotesBloc>().add(AlterNotesShowHideNotesEvent(model, value)),
                          onTapDown: (details) => context.read<AlterNotesBloc>().add(AlterNotesTapUserEvent(model, details.globalPosition)),
                          onTimePicker: () => context.read<AlterNotesBloc>().add(ViewTimePickerEvent(model)),
                          onShareTapDown: (details) => context.read<AlterNotesBloc>().add(PickSharingUsersEvent(model, offset: details.globalPosition)),
                        );
                      },
                      itemCount: context.watch<AlterNotesBloc>().noteItems.length,
                      shrinkWrap: true),
                  IconButton(
                      onPressed: () => context.read<AlterNotesBloc>().add(AlterNotesAddEvent()),
                      icon: const Icon(Icons.add_rounded),
                      color: AppC.appColor),
                  SuccessButton(text: "Save Notes", onPressed: () => context.read<AlterNotesBloc>().add(AlterNotesSaveEvent()))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
