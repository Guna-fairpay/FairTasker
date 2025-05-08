import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class LogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogLoadingState extends LogState {}

class LogCommonState extends LogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class LogErrorState extends LogState {
  final dynamic message;
  LogErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class LogSuccessState extends LogState {
  final dynamic message;
  LogSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class LogEditState extends LogState {
  final dynamic model;
  LogEditState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class LogDeletePermissionState extends LogState {
  final dynamic model;
  LogDeletePermissionState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class LogViewAttachmentState extends LogState {
  final dynamic model;
  LogViewAttachmentState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

// class LogAddAttachmentState extends LogState {}
class LogAddRecordingState extends LogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
// class LogAddVideoState extends LogState {}
class LogAddViewAttachmentState extends LogState {
  final dynamic model;
  LogAddViewAttachmentState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}