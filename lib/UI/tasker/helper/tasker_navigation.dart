part of '../tasker_main_ui.dart';

void navigation(BuildContext context, ToDoTaskerState state) {
  if (state is ToDoTaskerLoadingState) {
    if (!EasyLoading.isShow) EasyLoading.show();
  } else {
    if (state is! TaskCompletedState) if (EasyLoading.isShow) EasyLoading.dismiss();
    if (state is! ToDoTaskerCommonState) Utils.dismissKeyboard(context);
    switch (state) {
      case SuccessState(): Toaster.showSuccess("${state.message}"); break;
      case ErrorState(): Toaster.showError("${state.message}"); break;
      case DatePickerState(): Utils.showPickerDate(context, value: context.read<ToDoTaskerBloc>().selectedDate, onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateFilterEvent(val))); break;
      // case AddToDoState(): context.push(CreateTodoUI(selectedDate: state.date), fullscreenDialog: true); break;
      case AddToDoState(): context.push(TaskerAddToDo(taskType: state.taskType ?? TaskType.rental, selectedDate: state.date, leadId: state.leadId), fullscreenDialog: true); break;
      case MicState(): RecordAudioDialog.show(context, onRecorded: (file) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveRecordEvent(file))); break;
      case CompleteMaintenanceCheckState(): context.push(EditTodoUI(todoId: state.model?['id'].toString(), model: state.model),fullscreenDialog: true); break;
      case EditState(): context.push(EditTodoUI(todoId: state.toDoId, model: state.model,)); break;
      case UserFilterState(): TaskerFilterResourceDialog.show(context, selected: context.read<ToDoTaskerBloc>().selectedUsers, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerUserFilterEvent(value))); break;
      case VehicleFilterState(): TaskerVehicleSearchDialog.show(context); break;
      case VendorInfoState(): VendorInfoDialog.show(context, state.model); break;
      case NotesTapState(): NotesDialog.show(context, message: state.model?['notes'], onSave: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveNotesEvent(state.model, value))); break;
      case VehiclePersonTapState(): TaskerVehiclesChangeDialog.show(context, state.model, onSelected: (mapData, value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveVehiclesPersonsEvent(model: mapData, selected: value)), onDeleted: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerRemoveVehiclePersonEvent(value))); break;
      case ResourceTapState(): TaskerResourceDialog.show(context, state.model, onSelected: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveResourcesEvent(state.model, value))); break;
      case AddressTapState(): TaskerAddressChangeDialog.show(context, state.model, onSelected: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSaveAddressEvent(state.model, value))); break;
      case PartsTapState(): TaskerPartsSuppliesDialog.show(context, state.model, isParts: true, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSavePartsSuppliesEvent(model: state.model, parts: value)), onDelete: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent(showLoading: true))); break;
      case SuppliesTapState(): TaskerPartsSuppliesDialog.show(context, state.model, isParts: false, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSavePartsSuppliesEvent(model: state.model, supplies: value)), onDelete: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent(showLoading: true))); break;
      case MoveTomorrowState(): TaskerMoveTomorrowDialog.show(context, state.model, state.models, onChanged: (models, date, time) => context.read<ToDoTaskerBloc>().add(ToDoTaskerMoveTomorrowEvent(models, date, time))); break;
      case DateChangeTapState(): Utils.showPickerDate(context, value: state.model?['todo_date'].toString().toDateTime(), onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerDateChangeEvent(val, state.model))); break;
      case CompletedTimeTapState(): TaskerCompletedTimeDialog.show(context, state.model, onChanged: (timeTaken, reason) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompletedTimeChangeEvent(state.model, timeTaken, reason))); break;
      case TimePickerTapState(): Utils.showPickerTime(context, value: state.model?['todo_time'].toString().toTimeOfDay(), onChanged: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTimeChangeEvent(val, state.model))); break;
      case VendorLocationTapState(): TaskerVendorLocationDialog.show(context, state.model, onSelected: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerVendorLocationUpdateEvent(state.model, val))); break;
      case CompleteOilChangeState(): TaskerOdometerCompleteDialog.show(context, state.model, onChanged: (currentOdometer, nextMileCheck, nextOdometer) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompleteOdometerEvent(state.model, currentOdometer, nextMileCheck, nextOdometer))); break;
      case CompleteCheckInState(): TaskerCheckInOutCompleteDialog.show(context, state.model, isCheckOut: false, onYesterday: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerYesterdayEvent(value))); break;
      case CompleteCheckOutState(): TaskerCheckInOutCompleteDialog.show(context, state.model, isCheckOut: true); break;
      case CompleteRentalCheckOutState(): TaskerRentalCompleteDialog.show(context, state.model, true, onCompleted: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())); break;
      case CompleteRentalPickupState(): TaskerRentalCompleteDialog.show(context, state.model, false, onCompleted: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())); break;
      case CompleteDropCarState(): TaskerPickupTaskDialog.show(context, state.model, onSelected: (date, time, notes) => context.read<ToDoTaskerBloc>().add(ToDoTaskerCompleteDropCarEvent(state.model, date, time, notes))); break;
      case TaskCompletedState(): ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("ToDo Completed"), action: SnackBarAction(label: "Undo", textColor: AppC.appColor, backgroundColor: AppC.blue50, onPressed: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerUndoCompleteEvent(state.model))))); break;
      case VehicleHistoryTapState(): TaskerViewVehicleHistoryDialog.show(context, state.model); break;
      case ViewVehicleState(): context.push(VehicleMainViewUi(vin: List.from(state.model?['display']?['vins']).lastOrNull), fullscreenDialog: true); break;
      case VehicleGroupTapState(): TaskerGroupVehicleDialog.show(context, state.model); break;
      case FilterTaskState(): TaskerFilterTasksDialog.show(context, toDos: context.read<ToDoTaskerBloc>().unfiltered, selected: context.read<ToDoTaskerBloc>().selectedTasks, onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTaskFilterEvent(value)), isTimeSensitive: state.isTimeSensitive, onTimeSensitive: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTimeSensitiveEvent(value))); break;
      case ViewAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: (List<Map<String, dynamic>>.from(state.model?['todoimages']).map((e) => e['path'].toString().toAttachmentURL).toList()), title: state.model?['title']); break;
      case ViewReasonAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: (List<Map<String, dynamic>>.from(state.model?['reason_images']).map((e) => e['images'].toString().toAttachmentURL).toList()), title: state.model?['title']); break;
      case ViewCustomLinkState(): Utils.openURL(state.link ?? ""); break;
      case ShowDropCheckInPopupState(): TaskerTimeChangeReasonDialog.show(context, type: state.type, onSubmitted: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTimeChangeEvent(state.selectedTime, state.model, type: state.type, reason: value))); break;
      case ViewBouncieState(): TaskerBouncieDialog.show(context, state.model); break;
      case CompleteTransportCarState(): if (kDebugMode) TaskerToDoCompleteDialog.show(context, state.model); break; // HOLD DUE TO FLOW INCOMPLETE
      case MaintenanceCheckTasksCompleteState(): TaskerMaintenanceCompleteDialog.show(context, model: state.model); break;
      case TaskerTypeState(): SimplePopUpMenu.instance.show<TaskType>(context, items: TaskType.values, position: state.offset, itemAsString: (item) => item.name,  onTap: (item) => context.read<ToDoTaskerBloc>().add(ToDoTaskerOnAddToDoEvent(taskType: item)), height: 0); break;
      case FollowupTaskState(): TaskerFollowupTaskDialog.show(context, onPositive: () => context.read<ToDoTaskerBloc>().add(FollowupTaskEvent(state.model))); break;
      case LeadChangeState(): LeadChangeDialog.show(context, model: state.model, onSelected: (value, {model}) => context.read<ToDoTaskerBloc>().add(TaskerLeadUpdateEvent(model, value))); break;
      case MeetingChangeState(): MeetingChangeDialog.show(context, state.model, onChanged: (value, {model}) => context.read<ToDoTaskerBloc>().add(MeetingUpdateEvent(model, value))); break;
      case BookingInfoState(): BookingInfoDialog.show(context, state.model); break;
      case LeadInfoState(): LeadInfoDialog.show(context, state.model); break;
      case CompletePreCheckState(): context.push(EditTodoUI(todoId: state.model?['id'].toString(), model: state.model)); break;
      case MeetingCompleteState(): TaskerMeetingDialog.show(context, model: state.model); break;
      default: break;
    }
  }
}