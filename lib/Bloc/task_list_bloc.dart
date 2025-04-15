//
// import 'package:Bloc/Bloc.dart';
// import '../Event/task_list_event.dart';
// import '../Repository/task_list_repository.dart';
// import '../State/task_list_state.dart';
//
//
// class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
//   TaskListBloc() : super(TaskListInitial()) {
//     TaskListRepository taskListRepository = TaskListRepository();
//
//     on<GetTaskListData>((event, emit) async {
//       emit(TaskListViewLoading());
//       try {
//         final value = await taskListRepository.getTaskList(event.startDate, event.endDate);
//         if (value != null) {
//           emit(TaskListViewLoaded(data: value.data ?? []));
//         } else {
//           emit(const TaskListError("Failed to load data"));
//         }
//       } catch (error) {
//         emit(TaskListError(error.toString()));
//       }
//     });
//
//   }
// }
