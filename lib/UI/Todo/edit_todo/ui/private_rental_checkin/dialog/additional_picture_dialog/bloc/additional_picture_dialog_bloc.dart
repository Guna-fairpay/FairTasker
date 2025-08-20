import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'additional_picture_dialog_event.dart';
part 'additional_picture_dialog_state.dart';

class AdditionalPictureDialogBloc extends Bloc<AdditionalPictureDialogEvent, AdditionalPictureDialogState> {

  List<dynamic> additionalPictures = [];
  List<dynamic> selectedAdditionalPictures = [];

  AdditionalPictureDialogBloc() : super(CommonState()){
    on<InitialEvent>(_onInitialEvent);
    on<CheckEvent>(_onCheckEvent);
    on<UploadEvent>(_onUploadEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<AdditionalPictureDialogState> emit) {
    try {
      additionalPictures = event.precheckImages ?? [];
      for (var image in additionalPictures) {
        image['isCheck'] = false;
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onCheckEvent(CheckEvent event, Emitter<AdditionalPictureDialogState> emit) {
    try {
      for (var image in additionalPictures) {
        if(image['id'] == event.data['id']){
          image['isCheck'] = !image['isCheck'];
          if(image['isCheck'] == true){
            selectedAdditionalPictures.add(image);
          }else{
            selectedAdditionalPictures.remove(image);
          }
        }
      }
      emit(CommonState());
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onUploadEvent(UploadEvent event, Emitter<AdditionalPictureDialogState> emit) {
    try {
      emit(SuccessState('Success'));
    }catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<AdditionalPictureDialogState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }
}