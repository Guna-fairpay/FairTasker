import 'package:equatable/equatable.dart';

abstract class TFRDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TFRDInitialEvent extends TFRDEvents {}

class TFRDSelectEvent extends TFRDEvents {
  final Map<String, dynamic>? model;
  TFRDSelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}