part of 'vehicle_view_bloc.dart';

abstract class VehicleViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends VehicleViewEvent{}

class ApproveCheckEvent extends VehicleViewEvent{
  final dynamic model;
  final dynamic approved;
  ApproveCheckEvent({required this.model, required this.approved});
  @override
  List<Object?> get props => [model, approved];
}

class FairRentalEvent extends VehicleViewEvent {
  final dynamic id;
  FairRentalEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class DateRangeEvent extends VehicleViewEvent {
  final dynamic selectedRange;
  DateRangeEvent({required this.selectedRange});
  @override
  List<Object?> get props => [selectedRange];
}

class ApprovedEvent extends VehicleViewEvent {
  final dynamic isApproved;
  ApprovedEvent({required this.isApproved});
  @override
  List<Object?> get props => [isApproved];
}

class CohortEvent extends VehicleViewEvent {
  final dynamic cohort;
  CohortEvent({required this.cohort});
  @override
  List<Object?> get props => [cohort];
}

class CategoryEvent extends VehicleViewEvent {
  final dynamic category;
  CategoryEvent({required this.category});
  @override
  List<Object?> get props => [category];
}

class SubCategoryEvent extends VehicleViewEvent {
  final dynamic subCategory;
  SubCategoryEvent({required this.subCategory});
  @override
  List<Object?> get props => [subCategory];
}

class DeleteExpenseEvent extends VehicleViewEvent {
  final dynamic id;
  DeleteExpenseEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class RefreshEvent extends VehicleViewEvent{}

