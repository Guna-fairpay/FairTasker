import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bouncie_event.dart';
part 'bouncie_state.dart';

class BouncieBloc extends Bloc<BouncieEvent, BouncieState> {
  final APiRepository _aPiRepository = APiRepository();
  Map<String, dynamic>? _codeResponse, _tokenResponse;
  List<Map<String, dynamic>>? _bouncies;
  // List<Map<String, dynamic>>? lists = [];
  BouncieBloc() : super(LoadingState()) {
   on<InitialEvent>(_onInitialEvent);
   on<ViewBouncieEvent>(_onViewBouncieEvent);
  }

  List<Map<String, dynamic>>? get lists {
    var vinList = _bouncies?.map((e) => e['vin'] ?? "").toList();
    var lists = _vehicles.where((element) => vinList?.contains(element['vin']) ?? false).toList();
    for (var element in lists) {
      element['bouncie'] = _bouncies?.firstWhereOrNull((e) => e['vin'] == element['vin']);
    }

    return lists;
  }

  List<Map<String, dynamic>> get _vehicles => List.from(getIt<CommonService>().activeVehicleList);
  Future<Map<String, dynamic>?> _fetchCode() async => await _aPiRepository.getCode();
  Future<Map<String, dynamic>?> _fetchBouncieToken() async => await _aPiRepository.getBouncieToken(code: _codeResponse?['code']);
  Future<Map<String, dynamic>?> _fetchBouncie() async => await _aPiRepository.getBouncieVehicle(token: _tokenResponse?['access_token']);
  Future<List<Map<String, dynamic>>> _fetchActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();

  void _onInitialEvent(InitialEvent event, Emitter<BouncieState> emit) async {
    try {
      emit(LoadingState());
      await _fetchActiveVehicles();
      var response = await _fetchCode();
      _codeResponse = response?['code'];
      _tokenResponse = (await _fetchBouncieToken())?['data'];
      var bouncieResponse = await _fetchBouncie();
      _bouncies = List<Map<String, dynamic>>.from(bouncieResponse?['data'] ?? []);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(dynamic e, Emitter<BouncieState> emit) {
    Console.of.error("Error", error: e);
    emit(ErrorState(e));
  }

  void _onViewBouncieEvent(ViewBouncieEvent event, Emitter<BouncieState> emit) {
    emit(ViewBouncie(event.model));
  }
}