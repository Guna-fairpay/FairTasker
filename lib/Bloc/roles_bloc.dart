
import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Event/roles_event.dart';
import 'package:fairpytasker/State/roles_state.dart';
import '../Repository/permission_repository.dart';
import '../Repository/roles_repository.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  RolesBloc() : super(RolesInitial()) {
    RolesRepository rolesRepository = RolesRepository();
    PermissionRepository permissionRepository = PermissionRepository();

    on<GetRolesData>((event, emit) async {
      emit(RolesLoading());
      await rolesRepository
          .getRoles()
          .then((value) {
        if (value != null) {
          emit(RolesListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetPermissionDataForRole>((event, emit) async {
      emit(RolesLoading());
      await permissionRepository.getPermissions()
          .then((value) {
        if (value != null) {
          emit(PermissionDataForRoleLoaded(data: value.data ?? [],));
        }
      });
    });

    on<GetEditRoleData>((event, emit) async {
      emit(RolesLoading());
      await rolesRepository.getEditRoles(id: event.id)
          .then((value) {
        if (value != null) {
          emit(EditRolesLoaded(
            rolePermission: value.rolePermission ?? [],
          ));
        }
      });
    });

    on<AddRoleData>((event, emit) async {
      emit(RolesLoading());
      await rolesRepository.createRole(
        id : event.id,
        name: event.name,
        permission:  event.permissions,)
          .then((value) {
        if (value != null) {
          emit(RolesLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeleteRole>((event, emit) async {
      emit(RolesLoading());
      await rolesRepository.deleteRole(event.id,)
          .then((value) {
        if (value != null) {
          emit(RolesLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
