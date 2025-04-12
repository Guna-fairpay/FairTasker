import 'package:equatable/equatable.dart';

abstract class VehicleGroupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleGroupInitialEvent extends VehicleGroupEvent {
  final dynamic selectedModels;
  VehicleGroupInitialEvent({this.selectedModels});
  @override
  List<Object?> get props => [selectedModels];
}

class VehicleGroupEditEvent extends VehicleGroupEvent {
  final dynamic model;
  VehicleGroupEditEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class VehicleGroupSearchEvent extends VehicleGroupEvent {
  final String? query;
  VehicleGroupSearchEvent({this.query});
  @override
  List<Object?> get props => [query];
}

class VehicleGroupPaginationEvent extends VehicleGroupEvent {
  final int page;
  VehicleGroupPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class VehicleGroupCancelEvent extends VehicleGroupEvent {}

class VehicleGroupSelectVehicleEvent extends VehicleGroupEvent {
  final Map<String, dynamic> selectedModel;
  final bool isChecked;
  VehicleGroupSelectVehicleEvent({ this.isChecked = false, required this.selectedModel});
  @override
  List<Object?> get props => [isChecked, selectedModel];
}

class VehicleGroupDeleteVehicleEvent extends VehicleGroupEvent {
  final Map<String, dynamic> selectedModel;
  VehicleGroupDeleteVehicleEvent({required this.selectedModel});
  @override
  List<Object?> get props => [selectedModel];
}