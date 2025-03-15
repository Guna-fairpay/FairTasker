import 'package:equatable/equatable.dart';

abstract class ToDoTaskerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToDoTaskerInitialEvent extends ToDoTaskerEvent {}

class ToDoTaskerPreviousDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerNextDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerTapDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerDateFilterEvent extends ToDoTaskerEvent {
  final DateTime? selectedDate;
  ToDoTaskerDateFilterEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}
class ToDoTaskerShowCompleteEvent extends ToDoTaskerEvent {
  final bool showCompleted;
  ToDoTaskerShowCompleteEvent(this.showCompleted);
  @override
  List<Object?> get props => [showCompleted];
}