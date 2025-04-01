import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_check_in_out_completed_dialog.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/edit_todo_rework_ui.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_vehicles_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_address_change_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_completed_time_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_odometer_complete_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_change_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_pickup_car_task_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_view_vehicle_history_dialog.dart';
import 'package:fairpytasker/UI/dialog/vendor_info_dialog.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/UI/tasker/sub_pages/tasker_listing_ui.dart';
import 'package:fairpytasker/UI/tasker/task_components/tasker_header.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
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
          if (!EasyLoading.isShow) EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          switch (state) {
            case ToDoTaskerSuccessState(): Toaster.showSuccess("${state.message}"); break;
            case ToDoTaskerErrorState(): Toaster.showError("${state.message}"); break;
            case ToDoTaskerDatePickerState(): Utils.showPickerDate(context, value: context.read<ToDoTaskerBloc>().selectedDate, onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateFilterEvent(val))); break;
            case ToDoTaskerAddToDoState(): context.push(const CreateTodoUI(),fullscreenDialog: true); break;
            case ToDoTaskerMicState(): Toaster.showInfo("MIC PRESSED"); break;
            case ToDoTaskerCompleteMaintenanceCheckState(): context.push(EditTodoReworkUI(todoId: state.model?['id'].toString()),fullscreenDialog: true); break;
            case ToDoTaskerEditState(): context.push(EditTodoReworkUI(todoId: state.toDoId),fullscreenDialog: true); break;
            case ToDoTaskerTapUserFilterState(): TaskerFilterResourceDialog.show(context, selected: context.read<ToDoTaskerBloc>().selectedUsers, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerUserFilterEvent(value))); break;
            case ToDoTaskerTapVehicleFilterState(): TaskerVehicleSearchDialog.show(context); break;
            case ToDoTaskerVendorInfoState(): VendorInfoDialog.show(context, state.model); break;
            case ToDoTaskerNotesTapState(): NotesDialog.show(context, message: state.model?['notes'], onSave: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveNotesEvent(state.model, value))); break;
            case ToDoTaskerVehiclePersonTapState(): TaskerVehiclesChangeDialog.show(context, state.model, onSelected: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveVehiclesPersonsEvent(model: state.model, selected: value))); break;
            case ToDoTaskerResourceTapState(): TaskerResourceDialog.show(context, state.model, onSelected: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveResourcesEvent(state.model, value))); break;
            case ToDoTaskerAddressTapState(): TaskerAddressChangeDialog.show(context, state.model, onSelected: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveAddressEvent(state.model, value))); break;
            case ToDoTaskerPartsTapState(): TaskerPartsSuppliesDialog.show(context, state.model, isParts: true, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSavePartsSuppliesEvent(model: state.model, parts: value))); break;
            case ToDoTaskerSuppliesTapState(): TaskerPartsSuppliesDialog.show(context, state.model, isParts: false, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSavePartsSuppliesEvent(model: state.model, supplies: value))); break;
            case ToDoTaskerMoveTomorrowState(): TaskerMoveTomorrowDialog.show(context, state.model, state.models, onChanged: (models, date, time) => context.read<ToDoTaskerBloc>().add(ToDoTaskerMoveTomorrowEvent(models, date, time))); break;
            case ToDoTaskerDateChangeTapState(): Utils.showPickerDate(context, value: state.model?['todo_date'].toString().toDateTime(), onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateChangeEvent(val, state.model))); break;
            case ToDoTaskerCompletedTimeTapState(): TaskerCompletedTimeDialog.show(context, state.model, onChanged: (timeTaken, reason) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompletedTimeChangeEvent(state.model, timeTaken, reason))); break;
            case ToDoTaskerTimePickerTapState(): Utils.showPickerTime(context, value: state.model?['todo_time'].toString().toTimeOfDay(), onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTimeChangeEvent(val, state.model))); break;
            case ToDoTaskerVendorLocationTapState(): TaskerVendorLocationDialog.show(context, state.model, onSelected: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerVendorLocationUpdateEvent(state.model, val))); break;
            case ToDoTaskerCompleteOilChangeState(): TaskerOdometerCompleteDialog.show(context, state.model, onChanged: (currentOdometer, nextMileCheck, nextOdometer) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompleteOdometerEvent(state.model, currentOdometer, nextMileCheck, nextOdometer))); break;
            case ToDoTaskerCompleteCheckInState(): TaskerCheckInOutCompleteDialog.show(context, state.model, isCheckOut: false); break;
            case ToDoTaskerCompleteCheckOutState(): TaskerCheckInOutCompleteDialog.show(context, state.model, isCheckOut: true); break;
            case ToDoTaskerCompleteRentalCheckOutState(): TaskerRentalCompleteDialog.show(context, state.model, true, onCompleted: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())); break;
            case ToDoTaskerCompleteRentalPickupState(): TaskerRentalCompleteDialog.show(context, state.model, false, onCompleted: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())); break;
            case ToDoTaskerCompleteDropCarState(): TaskerPickupTaskDialog.show(context, state.model, onSelected: (date, time, notes) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompleteDropCarEvent(state.model, date, time, notes))); break;
            case ToDoTaskerTaskCompletedState(): ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("ToDo Completed"), action: SnackBarAction(label: "Undo", textColor: AppC.appColor, backgroundColor: AppC.blue50, onPressed: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerUndoCompleteEvent(state.model))))); break;
            case ToDoTaskerVehicleHistoryTapState(): TaskerViewVehicleHistoryDialog.show(context, state.model); break;
            case ToDoTaskerViewVehicleState(): Toaster.showInfo("Under Development"); break;
            case ToDoTaskerVehicleGroupTapState(): TaskerGroupVehicleDialog.show(context, state.model); break;
            case ToDoTaskerFilterTaskState(): TaskerFilterTasksDialog.show(context, toDos: context.read<ToDoTaskerBloc>().unfiltered, selected: context.read<ToDoTaskerBloc>().selectedTasks, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTaskFilterEvent(value))); break;
            case ToDOTaskerViewAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: (List<Map<String, dynamic>>.from(state.model?['todoimages']).map((e) => e['path'].toString().toAttachmentURL).toList()), title: state.model?['title']); break;
            case ToDoTaskerViewCustomLinkState(): Utils.openURL(state.model?['reference_id'].toString().toTuroReserveUrl ?? ""); break;
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
