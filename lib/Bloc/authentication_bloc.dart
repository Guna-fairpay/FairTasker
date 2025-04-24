import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepo authenticationRepo = AuthenticationRepo();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<DoLoginEvent>((event, emit) async {
      emit(const AuthenticationLoading());
      var response = await authenticationRepo.callLoginAPI(event.email, event.password);
      var users = await getIt<CommonService>().getUsers();
      var branches = await getIt<CommonService>().getBranches();
      if (response?.user?.branchId != null) {
        String? branchName = branches.firstWhereOrNull((element) => element['id'] == response?.user?.branchId)?['city'];
        Session.of.set(Str.branchNamePrefText, branchName);
      }
      emit(AuthenticationLoaded(authenticationData: response?.user, userPermissions: response?.userPermissions));
    });
  }
}
