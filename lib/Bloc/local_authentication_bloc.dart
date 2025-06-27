import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:math';

import 'package:equatable/equatable.dart';

part '../Event/local_authentication_event.dart';
part '../State/local_authentication_state.dart';

class LocalAuthenticationBloc extends Bloc<LocalAuthenticationEvent, LocalAuthenticationState> {
  final LocalAuthentication _auth = LocalAuthentication();
  // List<BiometricType> _availableBiometrics = [];
  bool showButton = false;
  LocalAuthenticationBloc() : super(LoadingState()) {
    on<LocalAuthenticationInitialEvent>(_onInitialEvent);
    on<LocalAuthenticationCheckEvent>(_onCheckEvent);
  }

  void _onInitialEvent(LocalAuthenticationInitialEvent event, Emitter<LocalAuthenticationState> emit) async {
    try {
      // _availableBiometrics = await _auth.getAvailableBiometrics();
      showButton = true;
      emit(CommonState());
      if (Session.of.getBool(Str.availBioMetrics) ?? false) {
        var isAuthenticated = await _auth.authenticate(localizedReason: "Please authenticate to continue");
        if (isAuthenticated) {
          emit(SuccessState());
        } else {
          emit(FailureState());
        }
      } else {
        emit(SuccessState());
      }
    } catch (e) {
      e is PlatformException ? emit(FailureState(message: e.message)) : emit(FailureState(message: "Authentication failed"));
    }
  }

  void _onCheckEvent(LocalAuthenticationCheckEvent event, Emitter<LocalAuthenticationState> emit) async {
    try {
      if (Session.of.getBool(Str.availBioMetrics) ?? false) {
        var isAuthenticated = await _auth.authenticate(localizedReason: "Please authenticate to continue");
        if (isAuthenticated) {
          emit(SuccessState());
        } else {
          emit(FailureState());
        }
      } else {
        emit(SuccessState());
      }
    } catch (e) {
      e is PlatformException ? emit(FailureState(message: e.message)) : emit(FailureState(message: "Authentication failed"));
    }
  }
}
