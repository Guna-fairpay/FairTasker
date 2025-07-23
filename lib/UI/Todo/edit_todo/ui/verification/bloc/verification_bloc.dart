import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState>{

  final APiRepository apiRepository = APiRepository();
  final TextEditingController notesController = TextEditingController();

  List<dynamic> licenseCheckList = [];
  List<dynamic> addressCheckList = [];
  List<dynamic> agreementCheckList = [];
  List<dynamic> licenseAttachments = [];
  List<dynamic> addressAttachments = [];
  List<dynamic> agreementAttachments = [];

  dynamic bookingDetails;
  dynamic model;

  String? token;

  int selectedValue = 1;


  Future<Map<String, dynamic>?> getCheckList({dynamic bookingId}) async => await apiRepository.rentalCheckList(bookingId: bookingId);
  Future<Map<String, dynamic>?> getToken() async => await apiRepository.getRentalToken();

  VerificationBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<TabChangeEvent>(_onTabChangeEvent);
    on<CheckListEvent>(_onCheckListEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VerificationState> emit) async {
    try {
      model = event.data;
      bookingDetails = model?['bookingDetails'];
      var tokenRes = await getToken();
      token = tokenRes?['data'];
      var response = await getCheckList(bookingId: model['bookingDetails']?['id']);
      if(response != null){
        licenseCheckList = List.from(response['data']?['license'] ?? []);
        addressCheckList = List.from(response['data']?['address_proof'] ?? []);
        agreementCheckList = List.from(response['data']?['agreement'] ?? []);
      }
      licenseAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
          .where((element) => element['label'] == 'driving_license')
          .map((element) => (element['file_url']))
          .toList();
      addressAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
          .where((element) => element['label'] == 'address_proof')
          .map((element) => (element['file_url']))
          .toList();
      agreementAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
          .where((element) => element['label'] == 'agreement')
          .map((element) => (element['file_url']))
          .toList();

      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onTabChangeEvent(TabChangeEvent event, Emitter<VerificationState> emit){
    try {
      selectedValue = event.value;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onCheckListEvent(CheckListEvent event, Emitter<VerificationState> emit) async {
    try {
      //var response = await getCheckList(bookingId: model['bookingDetails']?['id']);
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<VerificationState> emit){
    Console.of.log(error);
    emit(ErrorState(error));
  }

}