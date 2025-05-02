import 'package:equatable/equatable.dart';

abstract class PreCheckEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreCheckInitialEvent extends PreCheckEvent {
  final dynamic model;
  PreCheckInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PreCheckCheckEvent extends PreCheckEvent {
  final dynamic model;
  final bool? isChecked;
  PreCheckCheckEvent(this.model, this.isChecked);
  @override
  List<Object?> get props => [model, isChecked];
}

class PreCheckSubmitEvent extends PreCheckEvent {
  final dynamic model;
  PreCheckSubmitEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PreCheckCompleteEvent extends PreCheckEvent {
  final dynamic model;
  PreCheckCompleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PreCheckDeleteEvent extends PreCheckEvent {
  final dynamic model;
  final String? reason;
  PreCheckDeleteEvent(this.model, {this.reason});
  @override
  List<Object?> get props => [model, reason];
}