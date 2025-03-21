import 'package:equatable/equatable.dart';

abstract class TFRDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TFRDInitialEvent extends TFRDEvents {
  final List<Map<String, dynamic>>? selected;
  TFRDInitialEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}

class TFRDSelectEvent extends TFRDEvents {
  final Map<String, dynamic>? model;
  TFRDSelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TFRDAllEvent extends TFRDEvents {}