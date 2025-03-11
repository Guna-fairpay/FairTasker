
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VehicleExpenseHistoryEvent extends Equatable {
  const VehicleExpenseHistoryEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleExpenseHistoryList extends VehicleExpenseHistoryEvent {
  final String? vin;
  const GetVehicleExpenseHistoryList({required this.vin});
  @override
  List<Object?> get props => [vin];
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