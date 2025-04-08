import 'package:equatable/equatable.dart';

abstract class MaintenanceEvent extends Equatable {
  const MaintenanceEvent();
  @override
  List<Object?> get props => [];
}



class MaintenanceInitialEvent extends MaintenanceEvent {
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;
  const MaintenanceInitialEvent({
    required this.todoItem,
    required this.vehicle
  });
  @override
  List<Object?> get props => [todoItem, vehicle];
}

class IsAllMaintenanceCheckEvent extends MaintenanceEvent {
  final bool status;
  const IsAllMaintenanceCheckEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class IndividualCheckEvent extends MaintenanceEvent {
  final String itemId;
  final bool status;
  final Map<String, dynamic>? item;
  const IndividualCheckEvent(this.itemId, this.status, {this.item});
  @override
  List<Object?> get props => [itemId, status, item];
}

class DropDownOptionEvent extends MaintenanceEvent {
  final dynamic linkOption;

  const DropDownOptionEvent(this.linkOption);

  @override
  List<Object?> get props => [linkOption];
}

class createFixTaskEvent extends MaintenanceEvent {
  final int? todoId;
  final String? maintenanceTaskId;
  final String? notes;
  final String? comments;
  final dynamic item;

  const createFixTaskEvent({
    required this.todoId,
    required this.maintenanceTaskId,
    required this.notes,
    required this.comments,
    required this.item,
  });

  @override
  List<Object?> get props => [maintenanceTaskId, notes, comments, item, todoId];
}

class createPrivateFixTaskEvent extends MaintenanceEvent {
  final String? notes;
  final String? id;
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;

  const createPrivateFixTaskEvent({
    required this.notes,
    required this.id,
    required this.todoItem,
    required this.vehicle,
  });

  @override
  List<Object?> get props => [notes, id, todoItem, vehicle];
}

class CompleteTodoItemEvent  extends MaintenanceEvent {
  const CompleteTodoItemEvent();
}

class CompletePrivateRentalItemEvent  extends MaintenanceEvent {
  var todoId;
  CompletePrivateRentalItemEvent({this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class DeletePrivateRentalItemEvent  extends MaintenanceEvent {
  var todoId;
  DeletePrivateRentalItemEvent({this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class DeleteTodoItemEvent  extends MaintenanceEvent {
  const DeleteTodoItemEvent();
}

class FetchTodoListEvent extends MaintenanceEvent {
  final String? selectedDate;
  final String? status;
  final String? resourceId;
  FetchTodoListEvent({this.selectedDate, this.status, this.resourceId});
}

//Private Rental Check
class PrivateRentalInitialEvent extends MaintenanceEvent {
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;
  const PrivateRentalInitialEvent({
    required this.todoItem,
    required this.vehicle
  });
  @override
  List<Object?> get props => [todoItem, vehicle];
}

class UpdateCheckboxEvent extends MaintenanceEvent {
  final int itemId;
  final bool isChecked;
  const UpdateCheckboxEvent({required this.itemId, required this.isChecked});
  @override
  List<Object?> get props => [itemId, isChecked];

}
