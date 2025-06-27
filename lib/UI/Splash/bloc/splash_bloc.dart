import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  bool get isLoggedIn => Session.of.getBool(Str.loginPrefText) ?? false;
  final LocalAuthentication _auth = LocalAuthentication();
  SplashBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<SplashState> emit) async {
    await CommonHelper.instance.waitForPostFrameCallback();
    emit(LoadingState());
    await getIt<CommonService>().initialFetch();
    var hasBiometrics = await _auth.getAvailableBiometrics();
    Console.of.warning("HasBio $hasBiometrics");
    Session.of.set(Str.availBioMetrics, hasBiometrics.isNotEmpty);
    await Future.delayed(const Duration(seconds: 8));
    emit(CommonState());
    await Future.delayed(Durations.short4);
    emit(isLoggedIn ? NavigateHomeState() : NavigateLoginState());
  }
}