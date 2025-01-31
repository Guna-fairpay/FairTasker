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

class FBFeedSubmitEvent extends FBEditEvents {}

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


