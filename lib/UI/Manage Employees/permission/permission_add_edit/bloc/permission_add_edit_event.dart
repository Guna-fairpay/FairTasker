part of'permission_add_edit_bloc.dart';

abstract class PermissionAddEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PermissionAddEditEvent{
  final dynamic model;
  InitialEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class SaveEvent extends PermissionAddEditEvent{}
