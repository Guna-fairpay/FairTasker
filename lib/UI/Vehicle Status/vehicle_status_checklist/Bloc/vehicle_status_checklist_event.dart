
import 'package:equatable/equatable.dart';

abstract class VehicleStatusChecklistEvent extends Equatable {
  const VehicleStatusChecklistEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleStatusCheckListData extends VehicleStatusChecklistEvent {
  final String? vin;
  final dynamic data;
  const GetVehicleStatusCheckListData({required this.vin,required this.data});
  @override
  List<Object?> get props => [vin,data];
}

class CheckListSelectedEvent extends  VehicleStatusChecklistEvent {
  final dynamic data;
  final dynamic isChecked;
  const CheckListSelectedEvent({required this.data,required this.isChecked});
  @override
  List<Object?> get props => [data,isChecked];
}

class AllCheckListSelectedEvent extends  VehicleStatusChecklistEvent {
  final dynamic data;
  final dynamic isAllChecked;
  const AllCheckListSelectedEvent({required this.data,required this.isAllChecked});
  @override
  List<Object?> get props => [data,isAllChecked];
}

class ReorderVehicleStatusCheckListEvent extends  VehicleStatusChecklistEvent {}



