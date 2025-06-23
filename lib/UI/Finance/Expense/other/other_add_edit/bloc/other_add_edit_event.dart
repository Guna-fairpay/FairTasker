part of 'other_add_edit_bloc.dart';

abstract class OtherAddEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends OtherAddEditEvent{
  final dynamic id;
  InitialEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class CategoryEvent extends OtherAddEditEvent{
  final dynamic selectedCategory;
  CategoryEvent({required this.selectedCategory});
  @override
  List<Object?> get props => [selectedCategory];
}

class SubCategoryEvent extends OtherAddEditEvent {
  final dynamic selectedSubCategory;
  SubCategoryEvent({required this.selectedSubCategory});
  @override
  List<Object?> get props => [selectedSubCategory];
}

class PaymentEvent extends OtherAddEditEvent {
  final dynamic paymentType;
  PaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType];
}

class ApprovedEvent extends OtherAddEditEvent {
  final dynamic selectedApproved;
  ApprovedEvent({required this.selectedApproved});
  @override
  List<Object?> get props => [selectedApproved];
}

class DateChangeEvent extends OtherAddEditEvent {
  final DateTime? selectedDate;
  DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class PickImageEvent extends OtherAddEditEvent {}

class RemoveImageEvent extends OtherAddEditEvent {
  final dynamic data;
  RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class DeleteEvent extends OtherAddEditEvent {}

class SaveOrUpdateEvent extends OtherAddEditEvent {}