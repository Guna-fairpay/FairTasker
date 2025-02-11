import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepo authenticationRepo = AuthenticationRepo();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<DoLoginEvent>((event, emit) async {
      emit(const AuthenticationLoading());
      var response = await authenticationRepo.callLoginAPI(event.email, event.password);
      emit(AuthenticationLoaded(authenticationData: response?.user, userPermissions: response?.userPermissions));
    });
  }
}
