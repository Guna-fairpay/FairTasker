
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/Component/page_keep_aliver.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/ui/parts_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/UI/supplies_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/leads/ui/leads_main_ui.dart';
import 'package:fairpytasker/UI/Todo/Odometer/odometer_view.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/Component/ask_date_range_permission_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/Component/resource_popup.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_ui.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/ui/precheck_main_ui.dart';
import 'package:fairpytasker/UI/Todo/private_rental/UI/private_rental_check_list_page.dart';
import 'package:fairpytasker/UI/Todo/set_vehicles/ui/set_vehicles_main_ui.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/ui/edit_todo_expense.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_check_pickup_reason_dialog.dart';
import 'package:fairpytasker/UI/tasker_todo/tasker_create_todo.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/warning_helper.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'edit_todo_body.dart';
part 'edit_todo_more_form.dart';
part 'edit_todo_update_button.dart';
part 'edit_todo_bottom_tabs.dart';


class EditTodoUI extends StatelessWidget {
  final dynamic todoId;
  final dynamic model;

  const EditTodoUI({super.key, required this.todoId,this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditToDoBloc()..add(GetEditTodoInitialEvent(todoId: "$todoId", model: model)),
      child: BlocListener<EditToDoBloc, EditTodoState>(
        listener: (context, state) {
          if (state.isPop) {
            context.pop();
          }
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if (state.isTimeChange) {
            TaskerTimeChangeReasonDialog.show(
              context,
              type: context.read<EditToDoBloc>().timeChangePopupType ?? '',
              onSubmitted: (value) {
                context.read<EditToDoBloc>().add(EditTodoTimeChangeReasonEvent(
                      reason: value,
                    ));
              },
            );
          }
        },
        child: BlocBuilder<EditToDoBloc, EditTodoState>(
            builder: (context, state) => Scaffold(
                  //resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: state.todoStatus
                        ? Colors.green.shade900
                        : AppC.appColor,
                    title: Hero(
                      tag: todoId.toString(),
                      child: Text(
                        ((model?['title']) ?? (state.title)).toString().toTitleCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                        maxLines: 2,
                      ),
                    ),
                    foregroundColor: AppC.white,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        onPressed: () => context
                            .read<EditToDoBloc>()
                            .add(EditToDoEditAttachmentEvent()),
                        icon: const Icon(Icons.upload_outlined,color: AppC.green,),
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
                              onDeleted: (val) => context
                                    .read<EditToDoBloc>()
                                    .add(RemoveImageEvent(data: val)),
                              title: "Edit ToDo"),
                          icon: const Icon(Icons.remove_red_eye_outlined,color: AppC.green,),
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
                                      if (states
                                          .contains(WidgetState.selected)) {
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
                                            todoId: state.apiResponse['id']
                                                .toString(),
                                            status:
                                                state.apiResponse['status']));
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
                            Console.of.log('CLICKED>>>>');
                            AskPermissionDialog.show(context,
                                title: "Are you sure?",
                                description: "${context.read<EditToDoBloc>().name}, are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
                                boldWords: [context.read<EditToDoBloc>().name ?? '', ","],
                                positiveText: state.apiResponse['expense_id'] != null ? "Yes,Delete" : "Yes, delete it!",
                                negativeText: "Cancel",
                                isReasonRequired: true,
                                isExpense: state.apiResponse['expense_id'] != null ? true : false,
                                subPositiveText: state.apiResponse['expense_id'] != null ? 'Delete todo' : state.apiResponse['recurring_id'] != null? 'Delete multiple' : '',
                                subDescription: state.apiResponse['expense_id'] != null ? '' : state.apiResponse['recurring'],
                                onReasonSubmitted: (reason)async {
                                  context.read<EditToDoBloc>().add(DeleteTodoEvent(
                                    todoId: todoId,
                                    reason: reason,
                                    isRecurring: false,
                                    isExpenseDelete:
                                        state.apiResponse['expense_id'] != null
                                            ? true
                                            : false,
                                    data: state.apiResponse,
                                  ));},
                                onMultiSubmitted: (reason) async {
                                  if (state.apiResponse['expense_id'] != null) {
                                    context.read<EditToDoBloc>().add(DeleteTodoEvent(
                                      todoId: todoId,
                                      reason: reason,
                                      isRecurring: false,
                                      isExpenseDelete: false,
                                      data: state.apiResponse,
                                    ));
                                  }},
                                onSaveMultiPressed: () async {
                              if ((state.apiResponse['recurring_id'] != null) &&
                                  (state.selectedStartDate != null &&
                                      state.selectedEndDate != null)) {
                                await Future.delayed(Durations.short1);
                                AskDateRangePermissionDialog.show(context,
                                    isReasonRequired: true,
                                    endDate: state.selectedEndDate.toFormat(),
                                    startDate: context.read<EditToDoBloc>().recurringStartDate?.toFormat(),
                                    selectedEndDate: state.selectedEndDate,
                                    selectedStartDate: state.selectedStartDate,
                                    positiveText: 'Delete',
                                    onStartDate: (value) => context
                                        .read<EditToDoBloc>()
                                        .add(EditToDoStartDateChangeEvent(
                                            value)),
                                    onEndDate: (value) => context
                                        .read<EditToDoBloc>()
                                        .add(EditToDoEndDateChangeEvent(value)),
                                    onReasonSubmitted: (reason) {
                                      context
                                          .read<EditToDoBloc>()
                                          .add(DeleteTodoEvent(
                                            todoId: todoId,
                                            reason: reason,
                                            isExpenseDelete: false,
                                            isRecurring: true,
                                            data: state.apiResponse,
                                          ));
                                    });
                              }
                            });
                            },
                          icon: const Icon(Icons.delete_outline,color: AppC.redAccent,)),
                      IconButton(
                          onPressed: () {
                            var currentOdometer = num.tryParse(context.read<EditToDoBloc>().odometerController.text);
                            bool showOdometerPop = (currentOdometer != null && state.showOdometer && (int.tryParse(state.previousOdometer) != 0)
                                && (double.tryParse(currentOdometer.toString()) ?? 0) <
                                    (double.tryParse(state.previousOdometer) ?? 0));
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
                                    AskDateRangePermissionDialog.show(context,
                                        endDate: state.selectedEndDate?.toFormat(format: 'yyyy-MM-dd'),
                                        startDate: context.read<EditToDoBloc>().recurringStartDate?.toFormat(format: 'yyyy-MM-dd'),
                                        selectedEndDate: state.selectedEndDate,
                                        selectedStartDate: state.selectedStartDate,
                                        onStartDate: (value)=>context.read<EditToDoBloc>().add(EditToDoStartDateChangeEvent(value)),
                                        onEndDate: (value)=>context.read<EditToDoBloc>().add(EditToDoEndDateChangeEvent(value)),
                                        onPositivePressed: (){
                                          if(showOdometerPop){
                                            WarningHelper.odometerWarning(context,
                                                onPositive: () => context.read<EditToDoBloc>().add(
                                                    EditToDoSaveEvent()));
                                          } else {
                                            context.read<EditToDoBloc>().add(
                                                EditToDoSaveEvent());
                                          }
                                        }
                                    );
                                  }
                                },
                                onPositivePressed: (){
                                  if(showOdometerPop){
                                    WarningHelper.odometerWarning(context,
                                        onPositive: () => context.read<EditToDoBloc>().add(
                                            EditToDoSaveEvent()));
                                  } else {
                                    context.read<EditToDoBloc>().add(
                                        EditToDoSaveEvent());
                                  }
                                },
                              );
                            }else {
                              if(showOdometerPop){
                                WarningHelper.odometerWarning(context,
                                    onPositive: () => context.read<EditToDoBloc>().add(
                                        EditToDoSaveEvent()));
                              } else {
                                context.read<EditToDoBloc>().add(
                                    EditToDoSaveEvent());
                              }
                            }
                          },
                          icon: const Icon(Icons.save,color: AppC.green,)),
                      IconButton(
                          onPressed: () =>context.pop(),
                          icon: const Icon(Icons.close)),
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
