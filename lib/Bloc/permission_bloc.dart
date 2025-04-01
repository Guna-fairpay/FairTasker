
import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Repository/permission_repository.dart';
import '../Event/permission_event.dart';
import '../State/permission_state.dart';


class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitial()) {
    PermissionRepository permissionRepository = PermissionRepository();

    on<GetPermissionData>((event, emit) async {
      emit(PermissionLoading());

      await permissionRepository.getPermissions()
          .then((value) {
        if (value != null) {
          emit(PermissionListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });



    on<AddPermissionData>((event, emit) async {
      emit(PermissionLoading());

      await permissionRepository.createPermissions(
        event.id,
        event.name,
      )
          .then((value) {
        if (value != null) {
          emit(PermissionLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

    on<DeletePermissionData>((event, emit) async {
      emit(PermissionLoading());

      await permissionRepository.deletePermission(event.id)
          .then((value) {
        if (value != null) {
          emit(PermissionLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
