
import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class TaskInitialEvent extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class GetTaskData extends TaskEvent {
  const GetTaskData();
  @override
  List<Object> get props => [];
}

class GetTaskExpense extends TaskEvent {
  const GetTaskExpense();
  @override
  List<Object> get props => [];
}

class AddTaskData extends TaskEvent {

  final String? name;
  final String? subCategory;
  final String? category;
  final String? timeTaken;
  final String? userType;
  final int? id;

  const AddTaskData({
    required this.name,
    required this.subCategory,
    required this.category,
    required this.timeTaken,
    required this.userType,
    required this.id,
  });
  @override
  List<Object?> get props => [name, category, subCategory,timeTaken,userType, id];
}




class DeleteTaskData extends TaskEvent {
  final String id;

  const DeleteTaskData({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
