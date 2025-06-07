import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  bool get isLoggedIn => Session.of.getBool(Str.loginPrefText) ?? false;
  SplashBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    emit(isLoggedIn ? NavigateHomeState() : NavigateLoginState());
  }
}