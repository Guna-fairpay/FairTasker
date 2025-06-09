part of 'person_view_bloc.dart';

abstract class PersonViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PersonViewEvent{
  @override
  List<Object?> get props => [];
}

class AddEditEvent extends PersonViewEvent{
  final dynamic model;
  AddEditEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class DeleteEvent extends PersonViewEvent{
  final dynamic model;
  DeleteEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class ApproveEvent extends PersonViewEvent{
  final dynamic model;
  final dynamic approved;
  ApproveEvent({this.model, this.approved});
  @override
  List<Object?> get props => [model, approved];
}

class DateRangeEvent extends PersonViewEvent{
  final DateRange selectedDate;
  DateRangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class PersonExpenseDetailEvent extends PersonViewEvent{
  final dynamic model;
  PersonExpenseDetailEvent({this.model});
  @override
  List<Object?> get props => [model];

}