
import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Event/roles_event.dart';
import 'package:fairpytasker/State/roles_state.dart';
import '../Repository/roles_repository.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  RolesBloc() : super(RolesInitial()) {
    RolesRepository rolesRepository = RolesRepository();

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

    on<AddRoleData>((event, emit) async {
      emit(RolesLoading());

      await rolesRepository.createRole(event.id,event.name,event.permissions,)
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
