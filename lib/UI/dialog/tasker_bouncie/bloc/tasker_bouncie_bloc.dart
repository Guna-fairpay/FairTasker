import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/bloc/tasker_bouncie_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/bloc/tasker_bouncie_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

class TaskerBouncieBloc extends Bloc<TaskerBouncieEvent, TaskerBouncieState> {
  final APiRepository _aPiRepository = APiRepository();
  Map<String, dynamic>? _model;
  dynamic _vin;
  dynamic displayErrorMsg;
  dynamic address;
  dynamic lastUpdated;
  dynamic fuelLevel;
  dynamic batteryLevel;
  bool hasData = false;
  final MapController mapController = MapController();
  LatLng latLng = LatLng(0.0, 0.0);
  TaskerBouncieBloc() : super(TaskerBouncieLoadingState()) {
    on<TaskerBouncieInitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(TaskerBouncieInitialEvent event, Emitter<TaskerBouncieState> emit) async {
    try {
      emit(TaskerBouncieLoadingState());
      _model = event.model;
      _vin = List.from(_model?['display']?['vins'] ?? []).firstOrNull;
      Console.of.log(_vin, name: "VIN");
      if (_vin.toString().isNotNullOrEmpty) {
        var response = await _aPiRepository.getOdometerValue(vin: _vin);
        if (response?['status'] == 200) {
          hasData = true;
          latLng = LatLng(double.tryParse("${response?['data']?['stats']?['location']?['lat'] ?? 0.0}") ?? 0.0, double.tryParse("${response?['data']?['stats']?['location']?['lon'] ?? 0.0}") ?? 0.0);
          address = response?['data']?['stats']?['location']?['address'] ?? "";
          fuelLevel = response?['data']?['stats']?['fuelLevel'] ?? "";
          batteryLevel = response?['data']?['stats']?['battery']?['status'] ?? "";
          lastUpdated = DateTime.parse(response?['data']?['stats']?['lastUpdated'] ?? "").toFormat(format: "MM-dd-yyyy hh:mm a");
        } else {
          hasData = false;
          displayErrorMsg = response?['message'] ?? "";
        }
      }
      emit(TaskerBouncieCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerBouncieErrorState(e));
    }
  }
}