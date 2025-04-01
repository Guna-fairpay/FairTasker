
import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class UsersInitialEvent extends UsersEvent {
  @override
  List<Object?> get props => [];
}

class GetUsersData extends UsersEvent {
  const GetUsersData();
  @override
  List<Object> get props => [];
}
class AddUsersData extends UsersEvent {
  final String name;
  final int? id;

  const AddUsersData({

    required this.name,
    required this.id,
  });
  @override
  List<Object?> get props => [name,id];
}

class DeleteUsersData extends UsersEvent {
  final String id;

  const DeleteUsersData({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}