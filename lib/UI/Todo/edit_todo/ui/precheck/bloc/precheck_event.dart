part of 'precheck_bloc.dart';

abstract class PrecheckEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PrecheckEvent{
  final dynamic payload;
  InitialEvent(this.payload);
  @override
  List<Object?> get props => [payload];
}

class CreateTaskEvent extends PrecheckEvent{}

class UploadImageEvent extends PrecheckEvent{}