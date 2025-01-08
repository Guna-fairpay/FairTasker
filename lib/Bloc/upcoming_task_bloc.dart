import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/create_job_params.dart';
import 'package:fairpytasker/Repository/job_list_repository.dart';

part '../Event/upcoming_task_event.dart';
part '../State/upcoming_task_state.dart';

class UpcomingTaskBloc extends Bloc<UpcomingTaskEvent, UpcomingTaskState> {
  JobListRepo authenticationRepo = JobListRepo();

  UpcomingTaskBloc() : super(UpcomingTaskInitial()) {
    on<UpcomingTaskEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetJobList>((event, emit) async {
      emit(JobListLoading());
      await authenticationRepo.callJobListAPI(event.selectedDate).then((value) {
        emit(JobListLoaded(taskList: value?.tasks ?? []));
      });
    });

    on<DeleteJobEvent>((event, emit) async {
      emit(JobListLoading());
      await authenticationRepo.deleteAJob(event.taskId ?? '').then((value) {
        emit(DeleteJobLoaded(result: value));
      });
    });

    on<CreateTaskEvent>((event, emit) async {
      emit(JobListLoading());
      if (event.createJobParams?.jobId == null) {
        await authenticationRepo
            .createAJob(event.createJobParams!)
            .then((value) {
          emit(CreateJobLoaded(result: value));
        });
      } else {
        await authenticationRepo.editAJob(event.createJobParams!).then((value) {
          emit(CreateJobLoaded(result: value));
        });
      }
    });

    on<GetAssignedToList>((event, emit) async {
      emit(JobListLoading());
      await authenticationRepo.getAssignedTo().then((value) {
        emit(AssignedToLoaded(resource: value?.resource ?? []));
      });
    });
  }
}
