import 'dart:developer';

import 'package:date_time/date_time.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/Component/ask_date_range_permission_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/event/edit_todo_event.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../Utilities/appC.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../state/edit_todo_state.dart';
import 'edit_todo_body.dart';

class EditTodoUI extends StatelessWidget {
  final dynamic todoId;

  const EditTodoUI({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditToDoBloc()..add(GetEditTodoInitialEvent(todoId: "$todoId")),
      child: BlocListener<EditToDoBloc, EditTodoState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if(state.isPop) {
           Navigator.pop(context);
          }
        },
        child: BlocBuilder<EditToDoBloc, EditTodoState>(
            /*buildWhen: (previous, current) =>
                (previous.title != current.title) ||
                (previous.attachments != current.attachments) ||
                (previous.todoStatus != current.todoStatus),*/
            builder: (context, state) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: state.todoStatus
                        ? Colors.green.shade900
                        : AppC.appColor,
                    title: Text(
                      (state.title).toString().toTitleCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      maxLines: 2,
                    ),
                    foregroundColor: AppC.white,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        onPressed: () => context
                            .read<EditToDoBloc>()
                            .add(EditToDoEditAttachmentEvent()),
                        icon: const Icon(Icons.upload_rounded),
                        padding: EdgeInsets.zero,
                        constraints: state.todoAttachments.isNotEmpty
                            ? const BoxConstraints()
                            : null,
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // the '2023' part
                        ),
                      ),
                      if (state.todoAttachments.isNotEmpty)
                        IconButton(
                          onPressed: () => ShowAttachmentsDialog.of.show(
                              context,
                              attachments: state.todoAttachments,
                              onDeleted: (val)=>context.read<EditToDoBloc>().add(RemoveImageEvent(data: val)),
                              title: "Edit ToDo"),
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          padding: EdgeInsets.zero,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // the '2023' part
                          ),
                        ),
                      InkWell(
                        child: Transform.scale(
                          scale: 0.6,
                          child: SizedBox(
                            width: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Switch(
                                  trackOutlineColor:
                                      WidgetStateColor.resolveWith(
                                    (states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return AppC.green;
                                      } else {
                                        return AppC.grey;
                                      }
                                    },
                                  ),
                                  inactiveThumbColor: AppC.white,
                                  inactiveTrackColor: AppC.appColor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: AppC.white,
                                  activeTrackColor: AppC.green,
                                  // value: completeAllDay,
                                  value: state.todoStatus,
                                  onChanged: (value) {
                                    context.read<EditToDoBloc>().add(
                                        TaskStatusChangeEvent(
                                            todoStatus: value,
                                            todoId: state.apiResponse['id'].toString(),
                                            status: state.apiResponse['status']));
                                    // Future.delayed(const Duration(seconds: 1), () {
                                    //   if (value) {
                                    //     Navigator.pop(context);
                                    //   }
                                    // });
                                  }),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            AskPermissionDialog.show(
                              context,
                              title:
                              "Are you sure?",
                              description:
                              "${context.read<EditToDoBloc>().name}, are you sure you want to delete this revenue and task? Kindly enter a valid reason to confirm the deletion",
                              boldWords: [context.read<EditToDoBloc>().name??'',","],
                              positiveText:state.apiResponse['expense_id'] != null?"Yes,Delete" :"Yes, delete it!",
                              negativeText: "Cancel",
                              isReasonRequired: true,
                              isExpense: state.apiResponse['expense_id']!=null?true:false,
                              subPositiveText:state.apiResponse['expense_id']!=null?'Delete todo'
                                  : state.apiResponse['recurring_id']!=null ?'Delete multiple'
                                  : '',
                              subDescription:state.apiResponse['expense_id']!=null?'': state.apiResponse['recurring'],
                              onReasonSubmitted: (reason) {
                                  context.read<EditToDoBloc>().add(
                                      DeleteTodoEvent(
                                          todoId: todoId,
                                          reason: reason,
                                          isExpenseDelete: state.apiResponse['expense_id']!=null?true:false)
                                   );
                              },
                              onMultiSubmitted: (reason) async {

                                if(state.apiResponse['expense_id']!=null) {
                                context.read<EditToDoBloc>().add(
                                    DeleteTodoEvent(
                                        todoId: todoId,
                                        reason: reason,
                                        isExpenseDelete: true));
                              }
                            },
                            onSaveMultiPressed: () async {
                             if((state.apiResponse['recurring_id'] != null)&& (state.selectedStartDate!=null && state.selectedEndDate!=null)) {
                                await Future.delayed(Durations.short1);
                                AskDateRangePermissionDialog.show(context,
                                    isReasonRequired: true,
                                    endDate: state.selectedEndDate.toFormat(),
                                    startDate:
                                        state.selectedStartDate?.toFormat(),
                                    selectedEndDate: state.selectedEndDate,
                                    selectedStartDate: state.selectedStartDate,
                                    onStartDate: (value) => context
                                        .read<EditToDoBloc>()
                                        .add(EditToDoStartDateChangeEvent(value)),
                                    onEndDate: (value) => context
                                        .read<EditToDoBloc>()
                                        .add(
                                            EditToDoEndDateChangeEvent(value)));
                              }
                            }
                            );
                          },
                          icon: const Icon(Icons.delete)
                      ),
                      IconButton(
                          onPressed: () {
                            if(state.apiResponse['recurring_id']!=null){
                              AskPermissionDialog.show(
                                  context,
                                  title:
                                  "Do you want to Update this task only?",
                                  description:state.apiResponse['recurring'],
                                  positiveText:"Yes, Update it!",
                                  negativeText: "Cancel",
                                  isReasonRequired: false,
                                  subPositiveText:"Update multiple",
                                  onSaveMultiPressed: () async {
                                    if(state.selectedEndDate != null && state.selectedStartDate != null){
                                      await Future.delayed(Durations.short1);
                                      AskDateRangePermissionDialog.show(
                                        context,
                                        endDate: state.selectedEndDate.toFormat(),
                                        startDate: state.selectedStartDate?.toFormat(),
                                        selectedEndDate: state.selectedEndDate,
                                        selectedStartDate: state.selectedStartDate,
                                        onStartDate: (value)=>context.read<EditToDoBloc>().add(EditToDoStartDateChangeEvent(value)),
                                        onEndDate: (value)=>context.read<EditToDoBloc>().add(EditToDoEndDateChangeEvent(value)),
                                      );
                                    }

                                  },
                                  onPositivePressed: (){
                                    context.read<EditToDoBloc>().add(
                                        EditToDoSaveEvent());
                                  },
                              );

                            }else {
                              context.read<EditToDoBloc>().add(
                                  EditToDoSaveEvent());
                            }
                          },
                          icon: const Icon(Icons.save)
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)
                      ),
                    ],
                  ),
                  body: SafeArea(
                    minimum: 16.padding,
                    child: const EditTodoBody(),
                  ),
                )),
      ),
    );
  }
}
