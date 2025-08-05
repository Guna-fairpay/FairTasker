part of 'precheck_bloc.dart';

abstract class PrecheckEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PrecheckEvent{
  final dynamic payload;
  final List<dynamic> vinList;
  InitialEvent({this.payload, required this.vinList});
  @override
  List<Object?> get props => [payload, vinList];
}

class CreateTaskEvent extends PrecheckEvent{}

class UploadImageEvent extends PrecheckEvent{}

class DatePickEvent extends PrecheckEvent{
  final dynamic payload;
  DatePickEvent(this.payload);
  @override
  List<Object?> get props => [payload];
}

class CheckEvent extends PrecheckEvent{
  final dynamic payload;
  final bool showDialog;
  CheckEvent({this.payload, this.showDialog = false});
  @override
  List<Object?> get props => [payload, showDialog];
}

class DeleteImageEvent extends PrecheckEvent{
  final dynamic payload;
  DeleteImageEvent(this.payload);
  @override
  List<Object?> get props => [payload];
}

class DeleteImageDialogEvent extends PrecheckEvent{
  final dynamic payload;
  DeleteImageDialogEvent(this.payload);
  @override
  List<Object?> get props => [payload];
}

class SaveEvent extends PrecheckEvent{}