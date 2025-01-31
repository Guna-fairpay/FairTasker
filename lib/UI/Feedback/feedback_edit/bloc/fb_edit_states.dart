import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

abstract class FBEditStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class FBLoadingState extends FBEditStates {}
class FBLoadedState extends FBEditStates {}
class FBErrorState extends FBEditStates {
  final dynamic message;
  FBErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class FBSuccessState extends FBEditStates {
  final dynamic message;
  FBSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class FBFeedbackState extends FBEditStates {
  final TextEditingController titleController;
  final QuillController descriptionController;
  final dynamic priority;

  FBFeedbackState(this.titleController, this.descriptionController, this.priority);

  FBFeedbackState copyWith(
      {TextEditingController? titleController,
      QuillController? descriptionController,
      dynamic priority}) =>
      FBFeedbackState(
        titleController ?? this.titleController,
        descriptionController ?? this.descriptionController,
        priority ?? this.priority,
      );

  @override
  List<Object?> get props => [titleController, descriptionController, priority, Random().nextDouble()];
}

class FBFeedAttachmentState extends FBEditStates {
  final List<dynamic> attachments;
  FBFeedAttachmentState(this.attachments);
  @override
  List<Object?> get props => [attachments, Random().nextDouble()];
}

class FBFeedState extends FBEditStates{
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class FBCommentState extends FBEditStates{
  final List<dynamic> comments;
  FBCommentState(this.comments);
  @override
  List<Object?> get props => [comments, Random().nextDouble()];
}

class FBFeedViewAttachmentState extends FBEditStates {
  final dynamic attachment;
  final List<dynamic> attachments;
  FBFeedViewAttachmentState(this.attachment, this.attachments);
  @override
  List<Object?> get props => [attachment, attachments, Random().nextDouble()];
}