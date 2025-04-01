
import 'package:bloc/bloc.dart';
import '../Event/task_event.dart';
import '../Repository/task_repository.dart';
import '../State/task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    TaskRepository taskRepository = TaskRepository();

    on<GetTaskData>((event, emit) async {
      emit(TaskLoading());

      await taskRepository.getTask()
          .then((value) {
        if (value != null) {
          emit(TaskListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetTaskExpense>((event, emit) async {
      emit(TaskLoading());

      await taskRepository.getTaskExpense()
          .then((value) {
        if (value != null) {
          emit(TaskExpenseLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddTaskData>((event, emit) async {
      emit(TaskLoading());

      await taskRepository.createTask(
        event.id,
        event.name,
        event.category,
        event.subCategory,
        event.timeTaken,
        event.userType,
      )
          .then((value) {
        if (value != null) {
          emit(TaskLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteTaskData>((event, emit) async {
      emit(TaskLoading());

      await taskRepository.deleteTask(event.id)
          .then((value) {
        if (value != null) {
          emit(TaskLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
