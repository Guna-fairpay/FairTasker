part of 'set_vehicles_bloc.dart';

abstract class SetVehiclesEvent extends Equatable{
 @override
  List<Object?> get props => [];
}

class InitialEvent extends SetVehiclesEvent {
 final dynamic vehicle;
 final dynamic todoItems;
 InitialEvent({required this.vehicle, required this.todoItems});
 @override
 List<Object?> get props => [vehicle, todoItems];
}

class RefreshEvent extends SetVehiclesEvent {
 final dynamic vehicle;
 RefreshEvent({this.vehicle,});
 @override
 List<Object?> get props => [vehicle];
}

class RegStickerDateEvent extends SetVehiclesEvent {
 final DateTime selectedDate;
 RegStickerDateEvent({required this.selectedDate});
 @override
 List<Object?> get props => [selectedDate];
}

class TollImageEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class TireImageEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class UploadRegStickerImageEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class InsuranceImageEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class RemoveTollImageEvent extends SetVehiclesEvent {
 final dynamic data;
 RemoveTollImageEvent({required this.data});
 @override
 List<Object?> get props => [data];
}

class RemoveTireImageEvent extends SetVehiclesEvent {
 final dynamic data;
 RemoveTireImageEvent({required this.data});
 @override
 List<Object?> get props => [data];
}

class RemoveRegStickerImageEvent extends SetVehiclesEvent {
 final dynamic data;
 RemoveRegStickerImageEvent({required this.data});
 @override
 List<Object?> get props => [data];
}

class RemoveInsuranceImageEvent extends SetVehiclesEvent {
 final dynamic data;
 RemoveInsuranceImageEvent({required this.data});
 @override
 List<Object?> get props => [data];
}

class BouncieEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class TollTagsEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class AirTagEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class PermanentPlateEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class SpareTireEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class SpareKeyEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class FrontLicensePlateEvent extends SetVehiclesEvent {
 @override
 List<Object?> get props => [Random().nextDouble()];
}

class SaveVehicle extends SetVehiclesEvent {
 final bool? overRide;
 SaveVehicle({this.overRide});
 @override
 List<Object?> get props => [overRide];
}
