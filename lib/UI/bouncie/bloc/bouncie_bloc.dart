import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bouncie_event.dart';
part 'bouncie_state.dart';

class BouncieBloc extends Bloc<BouncieEvent, BouncieState> {
  final APiRepository _aPiRepository = APiRepository();
  List<Map<String, dynamic>>? _bouncies;
  BouncieBloc() : super(LoadingState()) {
   on<InitialEvent>(_onInitialEvent);
   on<ViewBouncieEvent>(_onViewBouncieEvent);
  }

  List<Map<String, dynamic>>? get lists => _bouncies;

  Future<Map<String, dynamic>?> _fetchBouncies() async => await _aPiRepository.getBouncies();

  void _onInitialEvent(InitialEvent event, Emitter<BouncieState> emit) async {
    try {
      emit(LoadingState());
      var bouncieResponse = await _fetchBouncies();
      _bouncies = List<Map<String, dynamic>>.from(bouncieResponse?['bouncieVehicles'] ?? []);
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