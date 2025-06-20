
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'voice_to_text_event.dart';
part 'voice_to_text_state.dart';

class VoiceToTextBloc extends Bloc<VoiceToTextEvent, VoiceToTextState>{
  final APiRepository _apiRepository = APiRepository();
  TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> voiceData = [];
  List<Map<String, dynamic>> filteredData = [];
  String? startDate;
  String? endDate;
  DateRange? selectedDateRange = DateRange(
    DateTime.now().subtract(const Duration(days: 7)),
    DateTime.now(),
  );

  VoiceToTextBloc() : super(VoiceToTextLoadingState()){

    on<VoiceToTextInitialEvent>((event, emit) async {
      try{
        emit(VoiceToTextLoadingState());
        if (event.startDate != null && event.endDate != null) {
          startDate = event.startDate;
          endDate = event.endDate;
        } else {
          startDate = DateTime.now()
              .subtract(const Duration(days: 7))
              .toFormat(format: 'yyyy-MM-dd');
          endDate = DateTime.now().toFormat(format: 'yyyy-MM-dd');
        }
        Console.of.log("$startDate $endDate", name: "VoiceToTextBloc");

        var response = await getVoiceTextList(startDate: startDate,endDate: endDate);
        voiceData = List.from(response?['data'] ?? []);
        filteredData.clear();
        filteredData = voiceData;
        emit(VoiceToTextLoadedState());
      }catch(e){
        emit(VoiceToTextLoadedState());
        Console.of.error(e.toString());
      }
    });

    on<ChangeDateRangeEvent>((event, emit) {
      selectedDateRange = event.selectedRange;
    });

  }

  ///GET VOICE TEXT LIST
  Future<Map<String, dynamic>?> getVoiceTextList({String? startDate, String? endDate}) async =>
      await _apiRepository.getVoiceToTextData(startDate: startDate, endDate: endDate);

}
