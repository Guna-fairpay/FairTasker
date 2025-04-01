import 'package:equatable/equatable.dart';

abstract class FeedbackAddEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class FeedbackAddAttachmentEvent extends FeedbackAddEvent {}
class FeedbackViewAttachmentEvent extends FeedbackAddEvent {
  final dynamic model;
  FeedbackViewAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class FeedbackDeleteAttachmentEvent extends FeedbackAddEvent {
  final dynamic model;
  FeedbackDeleteAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class FeedbackSelectedPriorityEvent extends FeedbackAddEvent {
  final String? value;
  FeedbackSelectedPriorityEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class FeedbackSubmitEvent extends FeedbackAddEvent {}