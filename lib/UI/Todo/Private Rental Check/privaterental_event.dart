import 'package:equatable/equatable.dart';

abstract class PrivateRentalsEvent extends Equatable {
  const PrivateRentalsEvent();
  @override
  List<Object?> get props => [];
}

class PrivateRentalInitialEvent extends PrivateRentalsEvent {
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;
  const PrivateRentalInitialEvent({
    required this.todoItem,
    required this.vehicle,
  });
  @override
  List<Object?> get props => [todoItem, vehicle];
}

class UpdateCheckboxEvent extends PrivateRentalsEvent {
  final int itemId;
  final bool isChecked;
  const UpdateCheckboxEvent({
    required this.itemId,
    required this.isChecked,
  });
  @override
  List<Object?> get props => [itemId, isChecked];
}

class CreatePrivateFixTaskEvent extends PrivateRentalsEvent {
  final int? identifierId;
  final String title;
  final String notes;
  final String id;
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;
  const CreatePrivateFixTaskEvent({
    this.identifierId,
    required this.title,
    required this.notes,
    required this.id,
    required this.todoItem,
    required this.vehicle,
  });
  @override
  List<Object?> get props => [notes, id, todoItem, vehicle, title, identifierId];
}

class UpdateFixTaskEvent extends PrivateRentalsEvent {
  final String? notes;
  final int? todoId;
  const UpdateFixTaskEvent({ this.notes, this.todoId});
  @override
  List<Object?> get props => [notes, todoId];
}

class CompletePrivateRentalItemEvent extends PrivateRentalsEvent {
  final String todoId;
  const CompletePrivateRentalItemEvent({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class DeletePrivateRentalItemEvent extends PrivateRentalsEvent {
  final String todoId;
  final String reason;
  const DeletePrivateRentalItemEvent({required this.todoId, required this.reason});
  @override
  List<Object?> get props => [todoId];
}