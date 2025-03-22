import 'package:equatable/equatable.dart';

abstract class TPSDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TPSDInitialEvent extends TPSDEvents {
  final Map<String, dynamic>? model;
  final bool isParts;
  TPSDInitialEvent(this.model, this.isParts);
  @override
  List<Object?> get props => [model, isParts];
}

class TPSDSelectedEvent extends TPSDEvents {
  final Map<String, dynamic> value;
  final bool isChecked;
  TPSDSelectedEvent(this.value, this.isChecked);
  @override
  List<Object?> get props => [value, isChecked];
}