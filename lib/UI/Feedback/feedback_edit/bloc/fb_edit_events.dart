import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class FBEditEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FBInitialEvent extends FBEditEvents {
  final dynamic feedBackId;
  FBInitialEvent(this.feedBackId);
  @override
  List<Object?> get props => [feedBackId];
}

class FBPageEvent extends FBEditEvents {
  final int pageId;
  FBPageEvent(this.pageId);
  @override
  List<Object?> get props => [pageId];
}

class FBFeedSubmitEvent extends FBEditEvents {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FBFeedAddAttachmentEvent extends FBEditEvents {}

class FBFeedRemoveAttachmentEvent extends FBEditEvents {
  final dynamic attachment;
  FBFeedRemoveAttachmentEvent(this.attachment);
  @override
  List<Object?> get props => [attachment];
}

class FBFeedViewAttachmentEvent extends FBEditEvents {
  final dynamic attachment;
  final List<dynamic> attachments;
  FBFeedViewAttachmentEvent(this.attachment, this.attachments);
  @override
  List<Object?> get props => [attachment, attachments, Random().nextDouble()];

}

class FBCommentAddAttachmentEvent extends FBEditEvents {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FBCommentRemoveAttachmentEvent extends FBEditEvents {
  final dynamic attachment;
  FBCommentRemoveAttachmentEvent(this.attachment);
  @override
  List<Object?> get props => [attachment, Random().nextDouble()];
}

class FBCommentSubmitEvent extends FBEditEvents {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class FBCommentDeleteEvent extends FBEditEvents {
  final dynamic commentId;
  FBCommentDeleteEvent(this.commentId);
  @override
  List<Object?> get props => [commentId, Random().nextDouble()];
}

class FBFeedPriorityChangeEvent extends FBEditEvents {
  final String? priority;
  FBFeedPriorityChangeEvent(this.priority);
  @override
  List<Object?> get props => [priority, Random().nextDouble()];
}

class FBFeedStatusChangeEvent extends FBEditEvents {
  final int? status;
  FBFeedStatusChangeEvent(this.status);
  @override
  List<Object?> get props => [status, Random().nextDouble()];
}


