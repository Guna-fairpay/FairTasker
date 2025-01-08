import 'package:equatable/equatable.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
}

class DepartmentEventInitialEvent extends DepartmentEvent {
  @override
  List<Object?> get props => [];
}

class GetDepartmentData extends DepartmentEvent {
  const GetDepartmentData();
  @override
  List<Object> get props => [];
}

class AddDepartmentData extends DepartmentEvent {

  final String name;
  final String head;
  final int? id;

  const AddDepartmentData({
    required this.name,required this.head,required this.id,
});
  @override
  List<Object?> get props => [name,head,id];
}

class DeleteDepartment extends DepartmentEvent {
  final String id;

  const DeleteDepartment({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
