

import 'package:equatable/equatable.dart';

abstract class CheckListEvent extends Equatable {
  const CheckListEvent();
  @override
  List<Object?> get props => [];
}

class CheckListInitialEvent extends CheckListEvent {
  final Map<String, dynamic> todoItems;
  final Map<String, dynamic> vehicle;
  const CheckListInitialEvent({
    required this.todoItems,
    required this.vehicle
  });
  @override
  List<Object?> get props => [todoItems, vehicle];
}

class IndividualCheckEvent extends CheckListEvent {
  final String itemId;
  final bool status;
  final Map<String, dynamic> checkListData;
  const IndividualCheckEvent(this.itemId, this.status, this.checkListData);
  @override
  List<Object?> get props => [itemId, status,];
}

class AddFixTaskEvent extends CheckListEvent {
  final String? title;
  final String? notes;
  final int? checklistId;
  const AddFixTaskEvent({ this.notes, this.title, this.checklistId});
  @override
  List<Object?> get props => [notes, title, checklistId];
}

class UpdateFixTaskEvent extends CheckListEvent {
  final String? notes;
  final int? todoId;
  const UpdateFixTaskEvent({ this.notes, this.todoId});
  @override
  List<Object?> get props => [notes, todoId];
}

class CompleteEvent  extends CheckListEvent {
  final int? todoId;
  const CompleteEvent(this.todoId);
  @override
  List<Object?> get props =>[todoId];
}

class DeleteEvent  extends CheckListEvent {
  final int? todoId;
  final String? reason;
  const DeleteEvent({this.reason, this.todoId});
  @override
  List<Object?> get props =>[reason,todoId];
}