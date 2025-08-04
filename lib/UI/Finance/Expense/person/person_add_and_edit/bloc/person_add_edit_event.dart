part of 'person_add_edit_bloc.dart';

abstract class PersonAddEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PersonAddEditEvent{
  final dynamic model;
  InitialEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class SelectPersonEvent extends PersonAddEditEvent {
  final dynamic selectedPerson;
  SelectPersonEvent(this.selectedPerson);
  @override
  List<Object?> get props => [selectedPerson];
}

class SelectDateEvent extends PersonAddEditEvent {
  final DateTime selectedDate;
  SelectDateEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class SelectCategoryEvent extends PersonAddEditEvent {
  final dynamic selectedCategory;
  SelectCategoryEvent(this.selectedCategory);
  @override
  List<Object?> get props => [selectedCategory,];
}

class SelectSubCategoryEvent extends PersonAddEditEvent {
  final dynamic selectedSubCategory;
  SelectSubCategoryEvent(this.selectedSubCategory);
  @override
  List<Object?> get props => [selectedSubCategory,];
}

class ExpenseToEvent extends PersonAddEditEvent {
  final dynamic selectedExpenseTo;
  ExpenseToEvent(this.selectedExpenseTo);
  @override
  List<Object?> get props => [selectedExpenseTo];
}

class SelectPaymentEvent extends PersonAddEditEvent {
  final dynamic paymentType;
  SelectPaymentEvent(this.paymentType);
  @override
  List<Object?> get props => [paymentType,];
}

class ApproveEvent extends PersonAddEditEvent {
  final dynamic selectedApproved;
  ApproveEvent(this.selectedApproved);
  @override
  List<Object?> get props => [selectedApproved,];
}

class PickImageEvent extends PersonAddEditEvent {}

class RemoveImageEvent extends PersonAddEditEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class SaveEvent extends PersonAddEditEvent {}

class DeleteEvent extends PersonAddEditEvent {}
