//
// import 'package:equatable/equatable.dart';
// ///TaskList
// abstract class TaskListState extends Equatable {
//   const TaskListState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class TaskListInitial extends TaskListState {
//   @override
//   List<Object> get props => [];
// }
//
// class TaskListViewLoading extends TaskListState {}
//
// class TaskListViewLoaded extends TaskListState {
//   final List<Map<String, dynamic>> data;
//   const TaskListViewLoaded(
//       {required this.data});
//   @override
//   List<Object> get props => [data];
// }
//
//
// class TaskListError extends TaskListState {
//   final String message;
//   const TaskListError(this.message);
//   @override
//   List<Object> get props => [message];
// }
//
