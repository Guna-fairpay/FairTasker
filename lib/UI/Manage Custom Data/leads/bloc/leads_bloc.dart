import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leads_event.dart';
part 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  TextEditingController customerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController plateNoController = TextEditingController();
  TextEditingController partOrFullTimeController = TextEditingController();
  TextEditingController availableDaysController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController driverRatingController = TextEditingController();
  TextEditingController satisfactionRateController = TextEditingController();
  TextEditingController acceptanceRateController = TextEditingController();
  TextEditingController cancellationRateController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController totalTripsController = TextEditingController();
  TextEditingController uberProController = TextEditingController();
  TextEditingController appliedAtController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController rentalModelController = TextEditingController();
  TextEditingController inviteStatusController = TextEditingController();
  TextEditingController backgroundCheckController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();

  bool showMore = false;

  List<dynamic> activeStatus =[{'id': 1, 'name': 'Active'}, {'id': 2, 'name': 'Inactive'}];

  dynamic selectedStatus;

  LeadsBloc() : super(LoadingState()){
   on<InitialEvent>(_onInitialEvent);
   on<ShowMoreEvent>(_onShowMoreEvent);
   on<ActiveStatesEvent>(_onActiveStatesEvent);
   on<SearchEvent>(_onSearchEvent);
   on<SaveEvent>(_onSaveEvent);
   on<CloseEvent>(_onCloseEvent);
   on<DeleteEvent>(_onDeleteEvent);
   on<PaginationEvent>(_onPaginationEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onShowMoreEvent(ShowMoreEvent event, Emitter<LeadsState> emit) async {
    try{
      showMore = !showMore;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onActiveStatesEvent(ActiveStatesEvent event, Emitter<LeadsState> emit) async {
    try{
      selectedStatus = event.status;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onSearchEvent(SearchEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());

      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onCloseEvent(CloseEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  Future<void> _onPaginationEvent(PaginationEvent event, Emitter<LeadsState> emit) async {
    try{
      emit(LoadingState());
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<LeadsState> emit){
    Console.of.error(error);
    emit(ErrorState(error));
  }

}