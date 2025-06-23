import 'package:bloc/bloc.dart';
import 'package:fairpytasker/Event/local_authentication_event.dart';
import 'package:fairpytasker/State/local_authentication_state.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationBloc extends Bloc<LocalAuthenticationEvent, LocalAuthenticationState> {
  final LocalAuthentication _auth = LocalAuthentication();
  List<BiometricType> _availableBiometrics = [];
  bool showButton = false;
  LocalAuthenticationBloc() : super(LocalAuthenticationLoadingState()) {
    on<LocalAuthenticationInitialEvent>(_onInitialEvent);
    on<LocalAuthenticationCheckEvent>(_onCheckEvent);
  }

  void _onInitialEvent(LocalAuthenticationInitialEvent event, Emitter<LocalAuthenticationState> emit) async {
    try {
      _availableBiometrics = await _auth.getAvailableBiometrics();
      showButton = true;
      emit(LocalAuthenticationCommonState());
      await getIt<CommonService>().initialFetch();
      if (_availableBiometrics.isNotEmpty) {
        var isAuthenticated = await _auth.authenticate(localizedReason: "Please authenticate to continue");
        if (isAuthenticated) {
          emit(LocalAuthenticationSuccessState());
        } else {
          emit(LocalAuthenticationFailureState());
        }
      } else {
        emit(LocalAuthenticationSuccessState());
      }
    } catch (e) {
      e is PlatformException ? emit(LocalAuthenticationFailureState(message: e.message)) : emit(LocalAuthenticationFailureState(message: "Authentication failed"));
    }
  }

  void _onCheckEvent(LocalAuthenticationCheckEvent event, Emitter<LocalAuthenticationState> emit) async {
    try {
      if (_availableBiometrics.isNotEmpty) {
        var isAuthenticated = await _auth.authenticate(localizedReason: "Please authenticate to continue");
        if (isAuthenticated) {
          emit(LocalAuthenticationSuccessState());
        } else {
          emit(LocalAuthenticationFailureState());
        }
      } else {
        emit(LocalAuthenticationSuccessState());
      }
    } catch (e) {
      e is PlatformException ? emit(LocalAuthenticationFailureState(message: e.message)) : emit(LocalAuthenticationFailureState(message: "Authentication failed"));
    }
  }
}
