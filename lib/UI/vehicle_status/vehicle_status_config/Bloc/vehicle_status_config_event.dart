
import 'package:equatable/equatable.dart';

abstract class VehicleStatusConfigEvent extends Equatable {
  const VehicleStatusConfigEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleStatusConfigData extends VehicleStatusConfigEvent {
  final String? vin;
  const GetVehicleStatusConfigData({required this.vin});
  @override
  List<Object?> get props => [vin];
}

class CheckListSelectedEvent extends  VehicleStatusConfigEvent {
  final dynamic data;
  final dynamic isChecked;
  const CheckListSelectedEvent({required this.data,required this.isChecked});
  @override
  List<Object?> get props => [data,isChecked];
}

class AllCheckListSelectedEvent extends  VehicleStatusConfigEvent {
  final dynamic data;
  final dynamic isAllChecked;
  const AllCheckListSelectedEvent({required this.data,required this.isAllChecked});
  @override
  List<Object?> get props => [data,isAllChecked];
}

class SwapIndexSaveEvent extends  VehicleStatusConfigEvent {
  final List<dynamic> data;
  const SwapIndexSaveEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class InitialDialogData extends  VehicleStatusConfigEvent {
  final dynamic data;
  const InitialDialogData({required this.data});
  @override
  List<Object?> get props => [data];
}


