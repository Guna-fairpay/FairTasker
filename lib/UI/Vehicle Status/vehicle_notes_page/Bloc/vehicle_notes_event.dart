
import 'package:equatable/equatable.dart';

abstract class VehicleNotesEvent extends Equatable {
  const VehicleNotesEvent();
  @override
  List<Object?> get props => [];
}

class GetVehicleNotesData extends VehicleNotesEvent {
  final String? vin;
  const GetVehicleNotesData({required this.vin});
  @override
  List<Object?> get props => [vin];
}

class DatePickEvent extends VehicleNotesEvent {
  final DateTime selectedDate;
  const DatePickEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class SaveNotesEvent extends VehicleNotesEvent {}

class DeleteNotesEvent extends VehicleNotesEvent {}

class UpdateNotesEvent extends VehicleNotesEvent {
  final dynamic editData;
  const UpdateNotesEvent({required this.editData});
  @override
  List<Object?> get props => [editData];
}

