import 'package:fairpytasker/UI/Todo/add_todo/add_todo_main_form.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/dialog/reclean/reclean_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateTodoUI extends StatelessWidget {
  final bool showHeader;
  final List<Map<String, dynamic>>? selectedVPerson;
  final List<Map<String, dynamic>?>? selectedAssignedTo;
  final DateTime? selectedDate;
  final bool isNextTask;
  const CreateTodoUI({super.key, this.showHeader = true, this.selectedAssignedTo, this.selectedDate, this.isNextTask = false, this.selectedVPerson});

  @override
  Widget build(BuildContext context) {
    return showHeader ? withBody(context) : withOutBody(context);
  }

  Widget withBody(BuildContext context) {
    return BlocProvider(
      create: (context) => AddToDoBloc()..add(AddToDoInitialEvent(showHeader, selectedDate: selectedDate, isNextTask: isNextTask, selectedVPerson: selectedVPerson)),
      child: BlocListener<AddToDoBloc, AddToDoState>(
          listener: (context, state) {
            Console.of.log("RESETTING_BLOC_LISTENER");
            Utils.dismissKeyboard(context);
            if (state.isLoading) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
            if (state.redirect){
              context.pop();
            }
            if (state.showCleanTaskReassign) {
              RecleanDialog.show(context, model: state.recleanModel, isSaveEvent: state.isSaveEvent, onPressed: ({isSaveEvent, reasonFiles, reasonMessage}) {
                context.read<AddToDoBloc>().add(AddToDoReassignEvent(isSaveEvent: isSaveEvent, reasonFiles: reasonFiles, reasonMessage: reasonMessage));
                Utils.dismissKeyboard(context);
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppC.white,
            appBar: PreferredSize(preferredSize: const Size.fromHeight(60),
                child: BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => AppBar(
                elevation: 0,
                backgroundColor: AppC.appColor,
                foregroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Utils.getText('Add Todo',
                    size: 18, weight: FontWeight.w700, color: AppC.white),
                actions: [
                  IconButton(
                    onPressed: () => context.read<AddToDoBloc>().add(AddToDoAddAttachmentEvent()),
                    icon: const Icon(Icons.upload_rounded),
                    padding: EdgeInsets.zero,
                    constraints: state.attachments.isNotEmpty ? const BoxConstraints() : null,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // the '2023' part
                    ),
                  ),
                  if (state.attachments.isNotEmpty && state.attachments.length > 0)
                    IconButton(
                      onPressed: () => ShowAttachmentsDialog.of.show(context, attachments: state.attachments, title: "Add ToDo", onDeleted: (value) => context.read<AddToDoBloc>().add(AddToDoDeleteAttachment(value))),
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      padding: EdgeInsets.zero,
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // the '2023' part
                      ),
                    ),
                  GestureDetector(
                    onTap: () => context.read<AddToDoBloc>().add(AddToDoTimeSensitiveEvent()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 10,
                          child: Checkbox(
                            value: state.isTimeSensitive,
                            checkColor: AppC.white,
                            // The color of the check mark
                            shape: ContinuousRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            side: BorderSide.none,
                            fillColor: WidgetStateProperty.resolveWith<Color>((states) => (states.contains(WidgetState.selected)) ? AppC.blue : AppC.white),
                            onChanged: (value) => context.read<AddToDoBloc>().add(AddToDoTimeSensitiveEvent()),
                          ),
                        ),
                        Utils.getText('Time Sensitive',
                            color: AppC.white, weight: FontWeight.bold)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () => context.read<AddToDoBloc>().add(AddToDoSaveEvent()),
                    icon: const Icon(Icons.save),
                    padding: EdgeInsets.zero,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // the '2023' part
                    ),
                  ),
                  const CloseButton(
                    color: Colors.white,
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // the '2023' part
                    ),
                  ),
                ],
              ))),
            body: SafeArea(
              minimum: 20.padding,
              child: const AddTodoMainForm(),
            ),
          )),
    );
  }

  Widget withOutBody(BuildContext context) {
    return BlocProvider(
      create: (context) => AddToDoBloc()..add(AddToDoInitialEvent(showHeader, isNextTask: isNextTask, selectedDate: selectedDate, selectedVPerson: selectedVPerson)),
      child: BlocListener<AddToDoBloc, AddToDoState>(
          listener: (context, state) {
            Utils.dismissKeyboard(context);
            if (state.isLoading) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
            if (state.redirect){
              context.pop();
            }
          },
          child: SafeArea(
            child: AddTodoMainForm(showHeader: showHeader),
          )),
    );
  }
}
