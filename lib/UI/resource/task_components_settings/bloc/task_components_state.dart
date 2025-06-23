import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class TaskComponentState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskComponentLoadingState extends TaskComponentState {}

class TaskComponentCommentState extends TaskComponentState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}