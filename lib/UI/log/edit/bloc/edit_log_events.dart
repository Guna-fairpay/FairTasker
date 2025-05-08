import 'package:equatable/equatable.dart';

abstract class EditLogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditLogInitialEvent extends EditLogEvent {
  final dynamic model;
  EditLogInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class EditLogPickFilesEvent extends EditLogEvent {}
class EditLogTapRecordAudioEvent extends EditLogEvent {}
class EditLogTapRecordVideoEvent extends EditLogEvent {}

class EditLogSubmitEvent extends EditLogEvent {}

class EditLogTapDeleteAttachmentEvent extends EditLogEvent {
  final dynamic model;
  EditLogTapDeleteAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}
class EditLogDeleteAttachmentEvent extends EditLogEvent {
  final dynamic model;
  EditLogDeleteAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class EditLogInsertAttachmentEvent extends EditLogEvent {
  final dynamic model;
  EditLogInsertAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}