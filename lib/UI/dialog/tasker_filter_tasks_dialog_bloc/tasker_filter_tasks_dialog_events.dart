
part of 'tasker_filter_tasks_dialog_bloc.dart';
abstract class TFTDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TFTDEvents {
  final List<Map<String, dynamic>>? toDos;
  final List<dynamic>? selected;
  final bool isTimeSensitive;
  InitialEvent({this.toDos, this.selected, required this.isTimeSensitive});
  @override
  List<Object?> get props => [toDos, selected, isTimeSensitive];
}

class TFTDSingleSelectEvent extends TFTDEvents {
  final dynamic name;
  TFTDSingleSelectEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class TFTDMultiSelectEvent extends TFTDEvents {
  final List<dynamic> names;
  TFTDMultiSelectEvent(this.names);
  @override
  List<Object?> get props => [names];
}

class SelectAllEvent extends TFTDEvents {}

class TimeSensitiveEvent extends TFTDEvents {
  final bool? value;
  TimeSensitiveEvent(this.value);
  @override
  List<Object?> get props => [value];
}