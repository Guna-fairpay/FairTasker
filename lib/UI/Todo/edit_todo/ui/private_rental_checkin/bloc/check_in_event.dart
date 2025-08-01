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

class CapturedImageEvent extends CheckInEvent {}

class UploadImageEvent extends CheckInEvent {}