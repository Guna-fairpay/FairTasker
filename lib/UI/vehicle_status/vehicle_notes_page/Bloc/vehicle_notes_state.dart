
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract  class VehicleNotesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class VehicleNotesLoadingState extends VehicleNotesState{}

class VehicleNotesLoadedState extends VehicleNotesState{}

class VehicleNotesCommonState extends VehicleNotesState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleNotesStateErrorState extends VehicleNotesState {
  final dynamic message;
  VehicleNotesStateErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

