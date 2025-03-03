import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class TodoEditExpenseEvent extends Equatable{
  const TodoEditExpenseEvent();
  @override
  List<Object?> get props => [];
}

class GetTodoExpenseInitialEvent extends TodoEditExpenseEvent {
  final String? expenseId;
  final dynamic todoItem;
  const GetTodoExpenseInitialEvent({required this.expenseId, this.todoItem});
  @override
  List<Object?> get props => [expenseId, todoItem, Random().nextDouble()];
}

class TaskListEvent extends TodoEditExpenseEvent {
  final dynamic taskList;
  const TaskListEvent({required this.taskList});
  @override
  List<Object?> get props => [taskList, Random().nextDouble()];
}

class CategoryListEvent extends TodoEditExpenseEvent {
  final dynamic mainCategory;
  const CategoryListEvent({required this.mainCategory});
  @override
  List<Object?> get props => [mainCategory, Random().nextDouble()];
}

class SubCategoryListEvent extends TodoEditExpenseEvent {
  final dynamic subCategory;
  const SubCategoryListEvent({required this.subCategory});
  @override
    List<Object?> get props => [subCategory, Random().nextDouble()];
}

class SaveExpenseEvent extends TodoEditExpenseEvent {
  const SaveExpenseEvent();
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PickImageEvent extends TodoEditExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CaptureImageEvent extends TodoEditExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends TodoEditExpenseEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class InvoiceEvent extends TodoEditExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TaxIconEvent extends TodoEditExpenseEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SelectedPaymentEvent extends TodoEditExpenseEvent {
  final dynamic paymentType;
  const SelectedPaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class SelectedVehicleEvent extends TodoEditExpenseEvent {
  final dynamic vehicleName;
  const SelectedVehicleEvent({required this.vehicleName});
  @override
  List<Object?> get props => [vehicleName, Random().nextDouble()];
}


