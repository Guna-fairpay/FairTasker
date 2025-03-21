import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TFTDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TFTDInitialEvent extends TFTDEvents {
  final List<Map<String, dynamic>>? toDos;
  final List<dynamic>? selected;
  TFTDInitialEvent({this.toDos, this.selected});
  @override
  List<Object?> get props => [toDos, selected];
}

class TFTDSingleSelectEvent extends TFTDEvents {
  final dynamic name;
  TFTDSingleSelectEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class TFTDMultiSelectEvent extends TFTDEvents {
  final List<dynamic> names;
  TFTDMultiSelectEvent(this.names);
  @override
  List<Object?> get props => [names];
}

class TFTDAllSelectEvent extends TFTDEvents {
  @override
  List<Object?> get props => [Random().nextDouble()];
}