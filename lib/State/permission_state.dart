
import 'package:equatable/equatable.dart';
///Permission
abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {
  @override
  List<Object> get props => [];
}

class PermissionLoading extends PermissionState {}

class PermissionListLoaded extends PermissionState {
  final List<Map<String, dynamic>>? data;

  const PermissionListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}



class PermissionLoaded extends PermissionState {
  final String message;

  const PermissionLoaded(
      {required this.message});

  @override
  List<Object> get props => [message];
}


class PermissionError extends PermissionState {
  final String message;

  const PermissionError(this.message);

  @override
  List<Object> get props => [message];
}

