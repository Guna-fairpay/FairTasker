
import 'package:bloc/bloc.dart';
import '../Event/users_event.dart';
import '../Repository/permission_repository.dart';
import '../Repository/user_repository.dart';
import '../Response/users_response.dart';
import '../State/user_state.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    UsersRepository usersRepository = UsersRepository();
    PermissionRepository permissionRepository = PermissionRepository();

    on<GetUsersData>((event, emit) async {
      emit(UsersLoading());
      await usersRepository.getUsers().then((value) {
        if (value != null) {
          emit(UsersListLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetPermissionForUsers>((event, emit) async {
      emit(UsersLoading());
      await permissionRepository.getPermissions().then((value) {
        if (value != null) {
          emit(PermissionForUsersLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<GetEditUsers>((event, emit) async {
      emit(UsersLoading());
      await usersRepository.getEditPermissionListForUsers(id: event.id).then(
        (value) {
        if (value != null) {
          emit(EditUsersLoaded(
            data: value.data ?? [],
          ));
        }
      });
    });

    on<AddUsersData>((event, emit) async {
      emit(UsersLoading());
      await usersRepository.createUsers(
      user:  event.user,
       permissions:  event.permissions,
      ).then((value) {
        if (value != null) {
          emit(UsersLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
