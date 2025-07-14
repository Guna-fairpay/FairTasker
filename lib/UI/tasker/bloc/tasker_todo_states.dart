part of 'tasker_todo_bloc.dart';

abstract class ToDoTaskerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToDoTaskerLoadingState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class ToDoTaskerCommonState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ToDoTaskerState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class SuccessState extends ToDoTaskerState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class DatePickerState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddToDoState extends ToDoTaskerState {
  final DateTime? date;
  final TaskType? taskType;
  final dynamic leadId;
  AddToDoState(this.date, {this.taskType, this.leadId});
  @override
  List<Object?> get props => [date, taskType, leadId, Random().nextDouble()];
}
class MicState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditState extends ToDoTaskerState {
  final dynamic toDoId;
  final dynamic model;
  EditState(this.toDoId, {this.model});
  @override
  List<Object?> get props => [toDoId, model, Random().nextDouble()];
}

class UserFilterState extends ToDoTaskerState {
  final TapDownDetails? details;
  UserFilterState(this.details);
  @override
  List<Object?> get props => [details];
}

class VehicleFilterState extends ToDoTaskerState {
  final TapDownDetails? details;

  VehicleFilterState(this.details);

  @override
  List<Object?> get props => [details];
}

class VendorInfoState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  VendorInfoState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class NotesTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  NotesTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class VehiclePersonTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  VehiclePersonTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ResourceTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ResourceTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class AddressTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  AddressTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class PartsTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  PartsTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class SuppliesTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  SuppliesTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class TaskCompletedState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  TaskCompletedState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class MoveTomorrowState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? models;
  MoveTomorrowState(this.model, this.models);
  @override
  List<Object?> get props => [model, models, Random().nextDouble()];
}

class DateChangeTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  DateChangeTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompletedTimeTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompletedTimeTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class TimePickerTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  TimePickerTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class VendorLocationTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  VendorLocationTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class VehicleGroupTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  VehicleGroupTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteOilChangeState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteOilChangeState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteCheckInState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteCheckInState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteCheckOutState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteCheckOutState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteMaintenanceCheckState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteMaintenanceCheckState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteRentalCheckOutState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteRentalCheckOutState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteRentalPickupState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteRentalPickupState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteDropCarState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteDropCarState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class VehicleHistoryTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  VehicleHistoryTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ViewVehicleState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ViewVehicleState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class FilterTaskState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ViewCustomLinkState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  final String? link;
  ViewCustomLinkState(this.model, this.link);
  @override
  List<Object?> get props => [model, link, Random().nextDouble()];
}

class ViewAttachmentState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ViewAttachmentState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ViewReasonAttachmentState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ViewReasonAttachmentState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ShowDropCheckInPopupState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  final TimeOfDay selectedTime;
  final String type; // PICKUP / DROP
  ShowDropCheckInPopupState(this.model, this.selectedTime, this.type);
  @override
  List<Object?> get props => [model, selectedTime, type, Random().nextDouble()];
}

class ViewBouncieState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ViewBouncieState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompleteTransportCarState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  CompleteTransportCarState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class MaintenanceCheckTasksCompleteState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  MaintenanceCheckTasksCompleteState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class TaskerTypeState extends ToDoTaskerState {
  final Offset offset;
  TaskerTypeState(this.offset);
  @override
  List<Object?> get props => [offset, Random().nextDouble()];
}

class FollowupTaskState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  FollowupTaskState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class LeadChangeState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  LeadChangeState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class MeetingChangeState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  MeetingChangeState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}