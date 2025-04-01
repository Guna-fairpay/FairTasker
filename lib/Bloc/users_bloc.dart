import 'package:bloc/bloc.dart';

import '../Event/users_event.dart';
import '../Repository/user_repository.dart';
import '../State/user_state.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    UsersRepository usersRepository = UsersRepository();

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

    on<AddUsersData>((event, emit) async {
      emit(UsersLoading());
      await usersRepository.createUsers(
        event.id,
       event.name,
      )
          .then((value) {
        if (value != null) {
          emit(UsersLoaded(
            message: value.message ?? [].toString(),
          ));
        }
      });
    });

  }
}
