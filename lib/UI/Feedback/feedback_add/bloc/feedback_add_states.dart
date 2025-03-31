import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class FeedbackAddState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedbackAddLoadingState extends FeedbackAddState {}
class FeedbackAddCommonState extends FeedbackAddState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class FeedbackAddErrorState extends FeedbackAddState {
  final dynamic message;
  FeedbackAddErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class FeedbackAddCompletedState extends FeedbackAddState {}

class FeedbackAddViewAttachmentState extends FeedbackAddState {
  final dynamic selectedModel;
  final List<dynamic> files;
  FeedbackAddViewAttachmentState(this.selectedModel, this.files);
  @override
  List<Object?> get props => [selectedModel, files, Random().nextDouble()];
}