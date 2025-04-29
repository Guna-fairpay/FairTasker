
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class EditToDoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetEditTodoInitialEvent extends EditToDoEvent {
  final String? todoId;
   GetEditTodoInitialEvent({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class EditToDoShowMoreEvent extends EditToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditToDoShowPartsEvent extends EditToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditToDoShowSuppliesEvent extends EditToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditToDoTaskEvent extends EditToDoEvent {
  final dynamic selectedTask;
  EditToDoTaskEvent({required this.selectedTask});
  @override
  List<Object?> get props => [selectedTask, Random().nextDouble()];
}

class EditToDoVPersonEvent extends EditToDoEvent {
  final dynamic vPerson;
  EditToDoVPersonEvent(this.vPerson);
  @override
  List<Object?> get props => [vPerson];
}

class EditToDoVLocationEvent extends EditToDoEvent {
  final dynamic vLocation;
  EditToDoVLocationEvent(this.vLocation);
  @override
  List<Object?> get props => [vLocation];
}

class EditToDoPersonTapEvent extends EditToDoEvent {
  final dynamic person;
  final bool isSelected;
  EditToDoPersonTapEvent(this.person, this.isSelected);
  @override
  List<Object?> get props => [person, isSelected, Random().nextDouble()];
}

class EditToDoTaskManagerEvent extends EditToDoEvent {
  final dynamic taskManager;
  EditToDoTaskManagerEvent(this.taskManager);
  @override
  List<Object?> get props => [taskManager];
}

class EditToDoCleanCarDuration extends EditToDoEvent {
  final dynamic cleanCarDuration;
  EditToDoCleanCarDuration(this.cleanCarDuration);
  @override
  List<Object?> get props => [cleanCarDuration];
}

class EditToDoPlatformCheckEvent extends EditToDoEvent {}

class EditToDoPartSelectionEvent extends EditToDoEvent {
  final dynamic part;
  final bool isChecked;
  EditToDoPartSelectionEvent(this.isChecked, this.part);
  @override
  List<Object?> get props => [isChecked, part];
}

class EditToDoSupplySelectionEvent extends EditToDoEvent {
  final dynamic data;
  final bool isChecked;
  EditToDoSupplySelectionEvent(this.isChecked, this.data);
  @override
  List<Object?> get props => [isChecked, data];
}

class EditToDoCleanCarEvent extends EditToDoEvent {}

class EditToDoRecurringTypeEvent extends EditToDoEvent {
  final dynamic recurringType;
  EditToDoRecurringTypeEvent(this.recurringType);
  @override
  List<Object?> get props => [recurringType];
}

class EditToDoDateChangeEvent extends EditToDoEvent {
  final DateTime selectedDate;
  EditToDoDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class EditToDoStartDateChangeEvent extends EditToDoEvent {
  final DateTime selectedDate;
  EditToDoStartDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class EditToDoEndDateChangeEvent extends EditToDoEvent {
  final DateTime selectedDate;
  EditToDoEndDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class EditToDoTimeChangeEvent extends EditToDoEvent {
  final TimeOfDay selectedTime;
  EditToDoTimeChangeEvent(this.selectedTime);
  @override
  List<Object?> get props => [selectedTime];
}

class EditToDoBottomTapEvent extends EditToDoEvent {
  final dynamic selectedBottomTap;
  EditToDoBottomTapEvent(this.selectedBottomTap);
  @override
  List<Object?> get props => [selectedBottomTap];
}

class EditToDoTimeSensitiveEvent extends EditToDoEvent {}

class EditToDoEditAttachmentEvent extends EditToDoEvent {}

class EditToDoSelectLinkOptionEvent extends EditToDoEvent {
  final dynamic linkOption;
  EditToDoSelectLinkOptionEvent(this.linkOption);
  @override
  List<Object?> get props => [linkOption];
}

class EditToDoEditAddressSelectionEvent extends EditToDoEvent {
  final dynamic data;
  final bool isChecked;
  EditToDoEditAddressSelectionEvent(this.data, this.isChecked);
  @override
  List<Object?> get props => [data, isChecked];
}

class EditToDoRecurringWeekDaysEvent extends EditToDoEvent {
  final dynamic selectedRecurringDay;
  EditToDoRecurringWeekDaysEvent(this.selectedRecurringDay);
  @override
  List<Object?> get props => [selectedRecurringDay];
}

class EditToDoRecurringMonthOccurrenceEvent extends EditToDoEvent {
  final bool isRecurringMonthOccurrence;
  EditToDoRecurringMonthOccurrenceEvent(this.isRecurringMonthOccurrence);
  @override
  List<Object?> get props => [isRecurringMonthOccurrence];
}

class EditToDoRecurringEndDateEvent extends EditToDoEvent {
  final bool isRecurringEndDate;

  EditToDoRecurringEndDateEvent(this.isRecurringEndDate);

  @override
  List<Object?> get props => [isRecurringEndDate];
}

class EditToDoRecurringYearlySelectedMonthEvent extends EditToDoEvent {
  final dynamic selectedMonth;
  EditToDoRecurringYearlySelectedMonthEvent(this.selectedMonth);
  @override
  List<Object?> get props => [selectedMonth];
}

class EditToDoRecurringEndDateSelectionEvent extends EditToDoEvent {
  final DateTime dateTime;
  EditToDoRecurringEndDateSelectionEvent(this.dateTime);
  @override
  List<Object?> get props => [dateTime];
}

class EditToDoOpenCustomLinkEvent extends EditToDoEvent {}

class EditToDoSaveEvent extends EditToDoEvent {
  final bool? isRecurring;
  EditToDoSaveEvent({required this.isRecurring});
  @override
  List<Object?> get props => [isRecurring];
}

class TaskStatusChangeEvent extends EditToDoEvent {
  final bool? todoStatus;
  final String? todoId;
  final String? status;
   TaskStatusChangeEvent({required this.todoStatus,required this.todoId,required this.status});
  @override
  List<Object?> get props => [todoStatus,todoId,status,];
}

class UserSelectionEvent extends EditToDoEvent {
  final List<String>? selectedResource;
  final List<dynamic>? resourceName;
  UserSelectionEvent({required this.selectedResource,required this.resourceName,});
  @override
  List<Object?> get props => [selectedResource];
}

class SelectedUsersNameEvent extends EditToDoEvent {
  final List<String>? selectedName;
  SelectedUsersNameEvent({required this.selectedName,});
  @override
  List<Object?> get props => [selectedName];
}

class EditToDoAddressSelectionEvent extends EditToDoEvent {
  final dynamic data;
  final bool isChecked;
  EditToDoAddressSelectionEvent(this.data, this.isChecked);
  @override
  List<Object?> get props => [data, isChecked];
}

class EditToDoSelectTaskHistoryEvent extends EditToDoEvent {
  final dynamic selectTaskHistory;
  EditToDoSelectTaskHistoryEvent(this.selectTaskHistory);
  @override
  List<Object?> get props => [selectTaskHistory];
}

class DeleteTodoEvent extends EditToDoEvent {
  final String? todoId;
  final String? reason;
  final dynamic data;
  final bool isExpenseDelete;
  final bool isRecurring;
  DeleteTodoEvent({required this.todoId,required this.reason,required this.isExpenseDelete,required this.data,required this.isRecurring});
  @override
  List<Object?> get props => [todoId,reason,isExpenseDelete,data];
}

class EditToDoDeleteVehicleEvent extends EditToDoEvent {
  final String vehicleId;

  EditToDoDeleteVehicleEvent({
   required this.vehicleId,
  });
  @override
  List<Object?> get props => [vehicleId];
}

class EditToDoSelectSentimentsEvent extends EditToDoEvent {
  final dynamic selectedSentiments;
  EditToDoSelectSentimentsEvent(this.selectedSentiments);
  @override
  List<Object?> get props => [selectedSentiments];
}

class RemoveImageEvent extends EditToDoEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditToDoStatesChangeEvent extends EditToDoEvent {}

class EditToDoDeletePartsAndSuppliesEvent extends EditToDoEvent {}

class EditTodoTimeChangeReasonEvent extends EditToDoEvent {
  final String? reason;
  EditTodoTimeChangeReasonEvent({required this.reason});
  @override
  List<Object?> get props => [reason];
}

class RemoveNotesImageEvent extends EditToDoEvent {
  final dynamic data;
  RemoveNotesImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RemoveMileageImageEvent extends EditToDoEvent {
  final dynamic data;
  RemoveMileageImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditToDoRefreshEvent extends EditToDoEvent {}

