
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog_blog/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog_blog/transport_car_complete_state.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TCCDBloc extends Bloc<TCCDEvents, TCCDState> {
  Map<String, dynamic>? _model;
  final TextEditingController customTaskController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final APiRepository _aPiRepository = APiRepository();
  TCCDBloc() : super(TCCDLoadingState()) {
    on<TCCDInitialEvents>(_onInitialEvents);
  }


  void _onInitialEvents(TCCDInitialEvents event, Emitter<TCCDState> emit) async {
    var resource = getIt<CommonService>().resourcesList;
    var vendor = getIt<CommonService>().vendorsList;
    var location = getIt<CommonService>().locationsList;

  }


}