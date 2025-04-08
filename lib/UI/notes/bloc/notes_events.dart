import 'package:equatable/equatable.dart';

abstract class NotesEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesInitialEvent extends NotesEvents {}
class NotesAddNewEvent extends NotesEvents {}

class NotesEditEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesEditEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesAddCommentEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesAddCommentEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesCheckEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  final bool isAll;
  final bool? status;
  NotesCheckEvent(this.data, {this.isAll = false, this.status});
  @override
  List<Object?> get props => [data, isAll, status];
}

class NotesDateEvent extends NotesEvents {
  final DateTime? date;
  NotesDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}
class NotesNextDayEvent extends NotesEvents {}
class NotesPreviousDayEvent extends NotesEvents {}
class NotesDatePickerEvent extends NotesEvents {}

class NotesDeletePermissionEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesDeletePermissionEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesDeleteEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesDeleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesFilterEvent extends NotesEvents {
  final bool? status;
  NotesFilterEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class NotesSearchEvent extends NotesEvents {
  final String? search;
  NotesSearchEvent(this.search);
  @override
  List<Object?> get props => [search];
}

class NotesSwipeTomorrowEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesSwipeTomorrowEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesSwipeCompleteEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesSwipeCompleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesEditTaskTapEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesEditTaskTapEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesAddTaskTapEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  NotesAddTaskTapEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class NotesUpdateTaskEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  final String? input;
  NotesUpdateTaskEvent(this.data, this.input);
  @override
  List<Object?> get props => [data, input];
}

class NotesAddTaskEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  final String? input;
  NotesAddTaskEvent(this.data, this.input);
  @override
  List<Object?> get props => [data, input];
}

class NotesCheckTapEvent extends NotesEvents {
  final Map<String, dynamic>? data;
  final bool isAll;
  final bool? status;
  NotesCheckTapEvent(this.data, {this.isAll = false, this.status});
  @override
  List<Object?> get props => [data, isAll, status];
}
