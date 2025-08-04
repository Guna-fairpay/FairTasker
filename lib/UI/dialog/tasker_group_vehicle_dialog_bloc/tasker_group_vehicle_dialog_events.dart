import 'package:equatable/equatable.dart';

abstract class TGVDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TGVDInitialEvent extends TGVDEvents {
  final Map<String, dynamic>? model;
  TGVDInitialEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class TGVDeleteVehicleEvent extends TGVDEvents {
  final Map<String, dynamic>? model;
  TGVDeleteVehicleEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class TGVDAddVehicleEvent extends TGVDEvents {
  final Map<String, dynamic>? model;
  TGVDAddVehicleEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class TGVDSubmitEvent extends TGVDEvents {}