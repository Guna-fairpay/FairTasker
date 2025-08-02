part of 'check_in_bloc.dart';

abstract class CheckInEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CheckInEvent {
  final dynamic data;
  InitialEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SaveEvent extends CheckInEvent {
  final dynamic data;
  SaveEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class CapturedImageEvent extends CheckInEvent {
  final String imageName;
  CapturedImageEvent({required this.imageName});
  @override
  List<Object?> get props => [imageName];
}

class UploadImageEvent extends CheckInEvent {
  final String imageName;
  UploadImageEvent({required this.imageName});
  @override
  List<Object?> get props => [imageName];
}

class ViewImageEvent extends CheckInEvent {
  final String imageName;
  ViewImageEvent({required this.imageName});
  @override
  List<Object?> get props => [imageName];
}

class DeleteImageEvent extends CheckInEvent {
  final String imageName;
  final dynamic data;
  DeleteImageEvent({required this.imageName, required this.data});
  @override
  List<Object?> get props => [imageName, data];
}

class CheckBoxEvent extends CheckInEvent {}