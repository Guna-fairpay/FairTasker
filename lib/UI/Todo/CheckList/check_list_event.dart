

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
  const AddFixTaskEvent({ this.notes, this.title});
  @override
  List<Object?> get props => [notes, title];
}

class CompleteEvent  extends CheckListEvent {
  const CompleteEvent();
}

class DeleteEvent  extends CheckListEvent {
  const DeleteEvent();
}