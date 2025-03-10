import 'package:equatable/equatable.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_config.dart';

abstract class VehicleStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleStatusInitialEvent extends VehicleStatusEvent {} // FETCHING ALL THE LIST OF APIS
class VehicleStatusShowHideSearcherEvent extends VehicleStatusEvent {} // SHOW THE SEARCHER

class VehicleStatusCohortChangeEvent extends VehicleStatusEvent {
  final Map<String, dynamic>? cohort;
  VehicleStatusCohortChangeEvent(this.cohort);
  @override
  List<Object?> get props => [cohort];
}

class VehicleStatusCategoryChangeEvent extends VehicleStatusEvent {
  final Map<String, dynamic>? category;
  VehicleStatusCategoryChangeEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class VehicleStatusOnChangeTripCategory extends VehicleStatusEvent {
  final Map<String, dynamic>? tripCategory;
  VehicleStatusOnChangeTripCategory(this.tripCategory);
  @override
  List<Object?> get props => [tripCategory];
}

class VehicleStatusDisplayRentalCategories extends VehicleStatusEvent {}

class VehicleStatusOnTapEvent extends VehicleStatusEvent {
  final Map<String, dynamic>? model;
  final VehicleStatusOnPressed? type;
  VehicleStatusOnTapEvent({required this.model, required this.type});
  @override
  List<Object?> get props => [model];
}

class VehicleOnCompleteEvent extends VehicleStatusEvent {
  final Map<String, dynamic>? model;
  VehicleOnCompleteEvent({required this.model});
  @override
  List<Object?> get props => [model];
}

class VehicleOnPreviousEvent extends VehicleStatusEvent {
  final Map<String, dynamic>? model;
  VehicleOnPreviousEvent({required this.model});
  @override
  List<Object?> get props => [model];
}