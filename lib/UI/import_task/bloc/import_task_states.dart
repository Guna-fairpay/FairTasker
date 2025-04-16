import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class ImportTaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImportTaskLoadingState extends ImportTaskState {}
class ImportTaskCommonState extends ImportTaskState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ImportTaskErrorState extends ImportTaskState {
  final dynamic message;
  ImportTaskErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class ImportTaskSuccessState extends ImportTaskState {
  final dynamic message;
  ImportTaskSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}