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

class CompleteTodoItemEvent  extends MaintenanceEvent {
  const CompleteTodoItemEvent();
}


class DeleteTodoItemEvent  extends MaintenanceEvent {
  const DeleteTodoItemEvent();
}

class FetchTodoListEvent extends MaintenanceEvent {
  final String? selectedDate;
  final String? status;
  final String? resourceId;
  const FetchTodoListEvent({this.selectedDate, this.status, this.resourceId});
}




