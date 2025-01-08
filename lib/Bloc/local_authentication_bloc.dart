import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Event/local_authentication_event.dart';
import 'package:fairpytasker/State/local_authentication_state.dart';

class LocalAuthenticationBloc extends Bloc<LocalAuthenticationEvent, LocalAuthenticationState> {
  LocalAuthenticationBloc() : super(LocalAuthenticationInitial()) {
    on<LocalAuthenticationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
