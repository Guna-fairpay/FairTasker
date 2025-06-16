import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {

  TextEditingController vendorController = TextEditingController();
  AutovalidateMode? autoValidate;

  VendorBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<VendorTypeEvent>(_onVendorTypeEvent);
    on<AddressEvent>(_onAddressEvent);
    on<PickImageEvent>(_onPickImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<VendorState> emit) {
    emit(CommonState());
  }

  void _onVendorTypeEvent(VendorTypeEvent event, Emitter<VendorState> emit) {
    emit(CommonState());
  }

  void _onAddressEvent(AddressEvent event, Emitter<VendorState> emit) {
    emit(CommonState());
  }

  void _onPickImageEvent(PickImageEvent event, Emitter<VendorState> emit) {
    emit(CommonState());
  }

  void _onRemoveImageEvent(RemoveImageEvent event, Emitter<VendorState> emit) {
    emit(CommonState());
  }


}