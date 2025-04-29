import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog/bloc/tasker_vendor_location_dialog_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog/bloc/tasker_vendor_location_dialog_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';

class TVLDBloc extends Bloc<TVLDEvent, TVLDState> {

  Map<String, dynamic>? _model;
  Map<String, dynamic>? selectedVendor;
  final TextEditingController controller = TextEditingController();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<Map<String, dynamic>> get vendorsList => getIt<CommonService>().vendorsList;
  List<Map<String, dynamic>> get locationsList => getIt<CommonService>().locationsList;

  TVLDBloc() : super(TVLDLoadingState()) {
    _listenBroadcast();
    on<TVLDInitialEvent>(_onInitialEvent);
    on<TVLDSelectEvent>(_onSelectEvent);
    on<TVLDSubmitEvent>(_onSubmitEvent);
    on<TVLDRefreshEvent>(_onRefreshEvent);
  }

  void _listenBroadcast() {
    _broadcast.register(Str.refetchVendorLocation, (value, callback) => add(TVLDRefreshEvent()));
  }

  Future<List<Map<String, dynamic>>> _fetchVendors({bool refresh = false}) async => getIt<CommonService>().getVendorsList(reset: refresh);
  Future<List<Map<String, dynamic>>> _fetchLocations({bool refresh = false}) async => getIt<CommonService>().getLocationsList(reset: refresh);

  void _onInitialEvent(TVLDInitialEvent event, Emitter<TVLDState> emit) async {
    emit(TVLDLoadingState());
    _model = event.model;
    await Future.wait([_fetchVendors(), _fetchLocations()]);
    var locationId = _model?['location_id'];
    var vendorId = _model?['vendor_id'];
    if (locationId != null || vendorId != null) {
      var list = CustomSearchDataConverter.convertVLocation(locations: getIt<CommonService>().locationsList, vendors: getIt<CommonService>().vendorsList);
      selectedVendor = list.firstWhereOrNull((element) => element['id'] == vendorId);
      controller.text = _model?['display']?['vendor_location'];
    }
    emit(TVLDCommonState());
  }

  void _onSelectEvent(TVLDSelectEvent event, Emitter<TVLDState> emit) {
    selectedVendor = event.value;
    controller.text = event.value?['name'];
    emit(TVLDCommonState());
  }


  void _onSubmitEvent(TVLDSubmitEvent event, Emitter<TVLDState> emit) {
    if (selectedVendor != null) {
      if (_model?['display']?['vendor_location'] != controller.text) {
        emit(TVLDSubmitState(selectedVendor ?? {}));
      }
    }
  }

  void _onRefreshEvent(TVLDRefreshEvent event, Emitter<TVLDState> emit) async {
    emit(TVLDLoadingState());
    await Future.wait([_fetchVendors(refresh: true), _fetchLocations(refresh: true)]);
    emit(TVLDCommonState());
  }
}