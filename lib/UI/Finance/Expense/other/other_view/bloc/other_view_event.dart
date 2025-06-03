part of 'other_view_bloc.dart';

abstract class OtherViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends OtherViewEvent{}

class DateRangeEvent extends OtherViewEvent{
  final DateRange dateRange;
  DateRangeEvent(this.dateRange);
  @override
  List<Object?> get props => [dateRange];
}

class ApproveEvent extends OtherViewEvent {
  final dynamic model;
  final dynamic approved;
  ApproveEvent({required this.model, required this.approved});
  @override
  List<Object?> get props => [model, approved];
}

class DeleteEvent extends OtherViewEvent {
  final String? id;
  DeleteEvent({required this.id,});
  @override
  List<Object?> get props => [id];
}

class AddEditEvent extends OtherViewEvent{
  final String? id;
  AddEditEvent({this.id,});
  @override
  List<Object?> get props => [id];
}

class RefreshEvent extends OtherViewEvent{}

class CategoryDialogEvent extends OtherViewEvent{
  final dynamic model;
  CategoryDialogEvent(this.model);
  @override
  List<Object?> get props => [model];
}