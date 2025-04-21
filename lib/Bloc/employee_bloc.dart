
import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
    APiRepository apiRepository = APiRepository();

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
      ).then((value) {
        if (value != null) {
          emit(EmployeeLoaded(
            message: value.message ?? [].toString(),
          ));
        }
        //FBroadcast.instance().broadcast("refresh_add");
      });
      Map<String, String> body = {
        "first_name": event.firstname,
        "last_name": event.lastname,
        "email": event.email,
        "password": event.password??'',
      };
      await apiRepository.addEmployee(body: body);
      await getIt<CommonService>().getResources(reset: true);
      await getIt<CommonService>().getUsers(reset: true);
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
          .then((value) async {
        if (value != null) {
          emit(EmployeeLoaded(
            message: value.message ?? [].toString(),
          ));
        }
        await getIt<CommonService>().getResources(reset: true);
        await getIt<CommonService>().getUsers(reset: true);
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
