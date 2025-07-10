part of 'add_todo_bloc.dart';

abstract class AddToDoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends AddToDoEvent {
  final bool showAppBar;
  final DateTime? selectedDate;
  final bool isNextTask;
  final TaskType taskType;
  final List<Map<String, dynamic>>? selectedVPerson;

  InitialEvent({this.showAppBar = true, this.selectedDate, this.isNextTask = false, this.selectedVPerson, this.taskType = TaskType.rental});
  @override
  List<Object?> get props => [showAppBar, selectedDate, isNextTask, selectedVPerson, taskType];
}

class RefreshEvent extends AddToDoEvent {}

class IdentifierEvent extends AddToDoEvent {
  final dynamic identifier;
  IdentifierEvent(this.identifier);
  @override
  List<Object?> get props => [identifier];
}

class MoreEvent extends AddToDoEvent {}
class PartStatusEvent extends AddToDoEvent {}
class SupplyStatusEvent extends AddToDoEvent {}
class PlatformCheckEvent extends AddToDoEvent {}

class TaskManagerEvent extends AddToDoEvent {
  final bool isChecked;
  final dynamic taskManager;
  TaskManagerEvent(this.isChecked, this.taskManager);
  @override
  List<Object?> get props => [isChecked, taskManager];
}

class RecurringEvent extends AddToDoEvent {
  final Map<String, dynamic>? recurring;
  RecurringEvent(this.recurring);
  @override
  List<Object?> get props => [recurring];
}

class DateSelectEvent extends AddToDoEvent {
  final DateTime date;
  DateSelectEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class TimeSelectEvent extends AddToDoEvent {
  final TimeOfDay time;
  TimeSelectEvent(this.time);
  @override
  List<Object?> get props => [time];
}

class CustomEvent extends AddToDoEvent {
  final Map<String, dynamic>? custom;
  CustomEvent(this.custom);
  @override
  List<Object?> get props => [custom];
}

class RecurringDaysEvent extends AddToDoEvent {
  final String day;
  RecurringDaysEvent(this.day);
  @override
  List<Object?> get props => [day];
}

class RecurringMonthlyEvent extends AddToDoEvent {
  final bool isRecurringMonthOccurrence;
  RecurringMonthlyEvent(this.isRecurringMonthOccurrence);
  @override
  List<Object?> get props => [isRecurringMonthOccurrence];
}

class RecurringYearlyEvent extends AddToDoEvent {
  final dynamic month;
  RecurringYearlyEvent(this.month);
  @override
  List<Object?> get props => [month];
}

class RecurringEndAfterEvent extends AddToDoEvent {
  final bool isRecurringEndDate;
  RecurringEndAfterEvent(this.isRecurringEndDate);
  @override
  List<Object?> get props => [isRecurringEndDate];
}

class RecurringEndDateEvent extends AddToDoEvent {
  final DateTime date;
  RecurringEndDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class ClearVLEvent extends AddToDoEvent {}

class VendorLocationEvent extends AddToDoEvent {
  final dynamic vendorLocation;
  VendorLocationEvent(this.vendorLocation);
  @override
  List<Object?> get props => [vendorLocation];
}

class VehiclePersonEvent extends AddToDoEvent {
  final List<Map<String, dynamic>> vehiclePerson;
  VehiclePersonEvent(this.vehiclePerson);
  @override
  List<Object?> get props => [vehiclePerson];
}

class SubmitEvent extends AddToDoEvent {
  final bool oilChangeOverride;
  SubmitEvent({this.oilChangeOverride = false});
  @override
  List<Object?> get props => [oilChangeOverride];

}

class TimeSensitiveEvent extends AddToDoEvent {}

class ViewAttachmentEvent extends AddToDoEvent {}

class AddAttachmentEvent extends AddToDoEvent {}

class CleanCarEvent extends AddToDoEvent {}

class CleanCarDurationEvent extends AddToDoEvent {
  final dynamic duration;
  CleanCarDurationEvent(this.duration);
  @override
  List<Object?> get props => [duration];
}

class NewPartsEvent extends AddToDoEvent {}

class NewSuppliesEvent extends AddToDoEvent {}

class PartsEvent extends AddToDoEvent {
  final bool isChecked;
  final dynamic part;
  PartsEvent(this.isChecked, this.part);
  @override
  List<Object?> get props => [isChecked, part];
}

class SuppliesEvent extends AddToDoEvent {
  final bool isChecked;
  final dynamic supply;
  SuppliesEvent(this.isChecked, this.supply);
  @override
  List<Object?> get props => [isChecked, supply];
}

class LeadEvent extends AddToDoEvent {
  final dynamic lead;
  LeadEvent(this.lead);
  @override
  List<Object?> get props => [lead];
}

class MeetingEvent extends AddToDoEvent {
  final dynamic meetingMode;
  MeetingEvent(this.meetingMode);
  @override
  List<Object?> get props => [meetingMode];
}

class OpenCustomLinkEvent extends AddToDoEvent {}

class AddressEvent extends AddToDoEvent {
  final dynamic address;
  final bool isChecked;
  AddressEvent(this.isChecked, this.address);
  @override
  List<Object?> get props => [isChecked, address];
}

class ReassignEvent extends AddToDoEvent {
  final bool? isSaveEvent;
  final List<dynamic>? reasonFiles;
  final String? reasonMessage;
  ReassignEvent({this.isSaveEvent, this.reasonFiles, this.reasonMessage});
  @override
  List<Object?> get props => [isSaveEvent, reasonFiles, reasonMessage];
}

class DeleteTodoEvent extends AddToDoEvent {
  final dynamic model;
  DeleteTodoEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class DeleteAttachmentEvent extends AddToDoEvent {
  final dynamic attachment;
  DeleteAttachmentEvent(this.attachment);
  @override
  List<Object?> get props => [attachment];
}