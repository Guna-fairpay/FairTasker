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
  final String notes;
  final String id;
  final Map<String, dynamic> todoItem;
  final Map<String, dynamic> vehicle;
  const CreatePrivateFixTaskEvent({
    required this.notes,
    required this.id,
    required this.todoItem,
    required this.vehicle,
  });
  @override
  List<Object?> get props => [notes, id, todoItem, vehicle];
}

class CompletePrivateRentalItemEvent extends PrivateRentalsEvent {
  final String todoId;
  const CompletePrivateRentalItemEvent({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class DeletePrivateRentalItemEvent extends PrivateRentalsEvent {
  final String todoId;
  const DeletePrivateRentalItemEvent({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}