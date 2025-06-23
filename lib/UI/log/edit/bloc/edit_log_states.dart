import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class EditLogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditLogLoadingState extends EditLogState {}
class EditLogCommonState extends EditLogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditLogSuccessState extends EditLogState {
  final dynamic message;
  EditLogSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class EditLogErrorState extends EditLogState {
  final dynamic message;
  EditLogErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class EditLogCompleteState extends EditLogState {}

class EditLogDeletePermissionState extends EditLogState {
  final dynamic model;
  EditLogDeletePermissionState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class EditLogRecordState extends EditLogState {}