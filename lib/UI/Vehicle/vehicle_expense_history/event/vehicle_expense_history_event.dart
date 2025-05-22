
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VehicleExpenseHistoryEvent extends Equatable {
  const VehicleExpenseHistoryEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseHistoryList extends VehicleExpenseHistoryEvent {
  final String? vin;
  final bool isExpenseApprove;
  const GetVehicleExpenseHistoryList({required this.vin,required this.isExpenseApprove});
  @override
  List<Object?> get props => [vin, isExpenseApprove];
}

class GetEditVehicleExpenseHistory extends VehicleExpenseHistoryEvent {
  final String? id;
  const GetEditVehicleExpenseHistory({required this.id});
  @override
  List<Object?> get props => [id];
}

class SearchVehicleExpenseHistoryEvent extends VehicleExpenseHistoryEvent {
  final String? query;
  const SearchVehicleExpenseHistoryEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class PickImageEvent extends VehicleExpenseHistoryEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class CaptureImageEvent extends VehicleExpenseHistoryEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class RemoveImageEvent extends VehicleExpenseHistoryEvent {
  final dynamic data;
  const RemoveImageEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CategoryListEvent extends VehicleExpenseHistoryEvent {
  final dynamic category;
  const CategoryListEvent({required this.category});
  @override
  List<Object?> get props => [category, Random().nextDouble()];
}

class SubCategoryListEvent extends VehicleExpenseHistoryEvent {
  final dynamic subCategory;
  const SubCategoryListEvent({required this.subCategory});
  @override
  List<Object?> get props => [subCategory, Random().nextDouble()];
}

class CohortListEvent extends VehicleExpenseHistoryEvent {
  final dynamic selectedCohort;
  const CohortListEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort, Random().nextDouble()];
}

class SelectedPaymentEvent extends VehicleExpenseHistoryEvent {
  final dynamic paymentType;
  const SelectedPaymentEvent({required this.paymentType});
  @override
  List<Object?> get props => [paymentType, Random().nextDouble()];
}

class DateChangeEvent extends VehicleExpenseHistoryEvent {
  final DateTime selectedDate;
  const DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class DeleteVehicleExpenseHistoryEvent extends VehicleExpenseHistoryEvent {
  final String? id;
  const DeleteVehicleExpenseHistoryEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class VehicleEvent extends VehicleExpenseHistoryEvent {
  final dynamic selectedVehicle;
  const VehicleEvent({required this.selectedVehicle});
  @override
  List<Object?> get props => [selectedVehicle, Random().nextDouble()];
}

class UpdateVehicleExpenseHistoryEvent extends VehicleExpenseHistoryEvent {
  final String? id;
  const UpdateVehicleExpenseHistoryEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class PaginationEvent extends VehicleExpenseHistoryEvent {
  final int page;
  const PaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}