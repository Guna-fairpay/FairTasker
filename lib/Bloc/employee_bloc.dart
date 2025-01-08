
import 'package:bloc/bloc.dart';
import '../Event/employee_event.dart';
import '../Repository/employee_repository.dart';
import '../State/employee_state.dart';


class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    EmployeeRepository employeeRepository = EmployeeRepository();

    on<GetEmployeeData>((event, emit) async {
      emit(EmployeeLoading());

      await employeeRepository.getEmployee()
          .then((value) {
        if (value != null) {
          emit(EmployeeListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddEmployeeData>((event, emit) async {
      emit(EmployeeLoading());

      await employeeRepository.createEmployee(
        event.id,
        event.department,
        event.email,
        event.firstname,
        event.lastname,
        event.password,
        event.phone,
        event.role,


      )
          .then((value) {
        if (value != null) {
          emit(EmployeeLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<EditEmployeeData>((event, emit) async {
      emit(EmployeeLoading());

      await employeeRepository.editEmployee(
        event.id,
        event.firstname,
        event.lastname,
        event.email,
        event.phone,
        event.role,
        event.department,

      )
          .then((value) {
        if (value != null) {
          emit(EmployeeLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteEmployeeData>((event, emit) async {
      emit(EmployeeLoading());

      await employeeRepository.deleteEmployee(event.id)
          .then((value) {
        if (value != null) {
          emit(EmployeeLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
