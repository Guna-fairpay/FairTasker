import 'package:equatable/equatable.dart';

abstract class TRSDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TRSDInitialEvent extends TRSDEvents {
  final Map<String, dynamic>? model;
  TRSDInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TRSDSelectedEvent extends TRSDEvents {
  final Map<String, dynamic> value;
  final bool isChecked;
  TRSDSelectedEvent(this.value, this.isChecked);
  @override
  List<Object?> get props => [value, isChecked];
}