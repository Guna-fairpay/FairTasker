
import 'package:bloc/bloc.dart';

import '../Event/department_event.dart';
import '../Repository/department_repository.dart';
import '../State/department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc() : super(DepartmentInitial()) {
    DepartmentRepository departmentRepository = DepartmentRepository();

    on<GetDepartmentData>((event, emit) async {
      emit(DepartmentLoading());

      await departmentRepository.getDepartment()
          .then((value) {
        if (value != null) {
          emit(DepartmentListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddDepartmentData>((event, emit) async {
      emit(DepartmentLoading());

      await departmentRepository.createDepartment(event.id,event.head,event.name)
          .then((value) {
        if (value != null) {
          emit(DepartmentLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteDepartment>((event, emit) async {
      emit(DepartmentLoading());

      await departmentRepository.deleteDepartment(event.id)
          .then((value) {
        if (value != null) {
          emit(DepartmentLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
