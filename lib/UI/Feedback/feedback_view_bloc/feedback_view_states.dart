import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/feedback_status_response.dart';
import 'package:fairpytasker/Response/feedback_view_response.dart';
import 'package:fairpytasker/Utilities/Str.dart';

abstract class FeedBackViewState extends Equatable {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FeedBackViewLoadingState extends FeedBackViewState {}
class FeedBackViewLoadedState extends FeedBackViewState {}
class FeedBackViewShowState extends FeedBackViewState {
  final List<Feedback>? feedback;
  FeedBackViewShowState(this.feedback);
  @override
  List<Object?> get props => [feedback];
}
class FeedBackViewErrorState extends FeedBackViewState {
  final String? message;

  FeedBackViewErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
class FeedBackViewSuccessState extends FeedBackViewState {
  final String? message;

  FeedBackViewSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
class FeedBackViewAttachmentState extends FeedBackViewState {
  final List<dynamic>? attachments;
  final String? title;
  FeedBackViewAttachmentState(this.attachments, this.title);
  @override
  List<Object?> get props => [attachments, title, Random().nextDouble()];
}
class FeedBackViewShowStatusState extends FeedBackViewState {
  final List<StatusList>? status;
  FeedBackViewShowStatusState(this.status);
  @override
  List<Object?> get props => [status];
}

class FeedBackOnStatusState extends FeedBackViewState {}

class FeedBackShowDeleteDialogState extends FeedBackViewState {
  final dynamic feedBackId;
  FeedBackShowDeleteDialogState(this.feedBackId);
  @override
  List<Object?> get props => [feedBackId, Random().nextDouble()];
}

class FeedBackAddState extends FeedBackViewState {}
class FeedBackEditState extends FeedBackViewState {
  final dynamic feedBackId;
  final Map<String, dynamic> feedbacks;
  FeedBackEditState(this.feedBackId, this.feedbacks);
  @override
  List<Object?> get props => [feedBackId, feedbacks, Random().nextDouble()];
}

