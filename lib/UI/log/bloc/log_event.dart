import 'package:equatable/equatable.dart';

abstract class LogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogInitialEvent extends LogEvent {}
class LogRefreshEvent extends LogEvent {}

class LogAddAttachmentEvent extends LogEvent {}
class LogAddRecordingEvent extends LogEvent {}
class LogAddVideoEvent extends LogEvent {}
class LogAddViewAttachmentEvent extends LogEvent {}
class LogAddSubmitEvent extends LogEvent {}

class LogPaginationEvent extends LogEvent {
  final int page;
  LogPaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class LogEditEvent extends LogEvent {
  final dynamic model;
  LogEditEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LogDeleteEvent extends LogEvent {
  final dynamic model;
  LogDeleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LogDeletePermissionEvent extends LogEvent {
  final dynamic model;
  LogDeletePermissionEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LogViewAttachmentEvent extends LogEvent {
  final dynamic model;
  LogViewAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}