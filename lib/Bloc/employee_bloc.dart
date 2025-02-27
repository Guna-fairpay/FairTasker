
import 'package:bloc/bloc.dart';
import '../Event/employee_event.dart';
import '../Repository/department_repository.dart';
import '../Repository/employee_repository.dart';
import '../Repository/roles_repository.dart';
import '../State/employee_state.dart';


class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    EmployeeRepository employeeRepository = EmployeeRepository();
    DepartmentRepository departmentRepository = DepartmentRepository();
    RolesRepository roleRepository = RolesRepository();

    on<GetEmployeeRoleData>((event, emit) async {
      emit(EmployeeLoading());
      await roleRepository.getRoles()
          .then((value) {
        if (value != null) {
          emit(EmployeeRoleLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetEmployeeDepartmentData>((event, emit) async {
      emit(EmployeeLoading());
      await departmentRepository.getDepartment()
          .then((value) {
        if (value != null) {
          emit(EmployeeDepartmentLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

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

    on<GetEditEmployeeData>((event, emit) async {
      emit(EmployeeLoading());
      await employeeRepository.getEditEmployee(id: event.id)
          .then((value) {
        if (value != null) {
          emit(EditEmployeeListLoaded(
            user: value.user,
            role: value.role,
            userRole: value.userRole,
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
