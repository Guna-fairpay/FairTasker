import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class FeedBackViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedBackInitialEvent extends FeedBackViewEvent {}

class FeedBackSearchEvent extends FeedBackViewEvent {
  final String? searchQuery;

  FeedBackSearchEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class FeedBackStatusEvent extends FeedBackViewEvent {
  final int status;

  FeedBackStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class FeedBackDeleteEvent extends FeedBackViewEvent {
  final dynamic feedBackId;
  FeedBackDeleteEvent(this.feedBackId);
  @override
  List<Object?> get props => [feedBackId];
}

class FeedBackViewAttachmentEvent extends FeedBackViewEvent {
  final List<dynamic>? attachments;
  final String? title;
  FeedBackViewAttachmentEvent(this.attachments, this.title);
  @override
  List<Object?> get props => [attachments, title, Random().nextDouble()];
}

class FeedBackAddNewEvent extends FeedBackViewEvent {}

class FeedBackDeleteConfirmEvent extends FeedBackViewEvent {
  final dynamic feedBackId;
  FeedBackDeleteConfirmEvent(this.feedBackId);
  @override
  List<Object?> get props => [feedBackId];
}

class FeedBackEditEvent extends FeedBackViewEvent {
  final dynamic feedBackId;
  final Map<String, dynamic> feedbacks;
  FeedBackEditEvent(this.feedBackId, this.feedbacks);
  @override
  List<Object?> get props => [feedBackId, feedbacks, Random().nextDouble()];
}
