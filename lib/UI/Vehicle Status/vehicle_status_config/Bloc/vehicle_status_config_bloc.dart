
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_state.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusConfigBloc extends Bloc<VehicleStatusConfigEvent, VehicleStatusConfigState>{

  final APiRepository _apiRepository = APiRepository();
  List<dynamic> vehicleConfigData = [];
  String? vin;
  final FBroadcast _fBroadcast = FBroadcast.instance();
  List<int> categoryIdList = [];
  dynamic matchedData={};

  VehicleStatusConfigBloc() : super(VehicleStatusConfigLoadingState()) {

    on<GetVehicleStatusConfigData>((event, emit) async{
      try {
        emit(VehicleStatusConfigLoadingState());
        vin = event.vin;
        var response = await _getVehicleConfig(vin: vin);
        vehicleConfigData = List.from(response?['categories'] ?? []);
        emit(VehicleStatusConfigCommonState());
      }catch (e) {
        emit(VehicleStatusConfigLoadedState());
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

    on<CheckListSelectedEvent>((event, emit) async{
      try {
        _fBroadcast.broadcast("vehicleStatus",value: true);
        Console.of.debug('event.data: ${event.isChecked} ${event.data}');
        var response = await _apiRepository.vehicleConfigCheckList(body: {
          'categoryIds':[event.data['category_id']] ,
          'category_id': event.data['category_id'],
          'checkbox_value': event.isChecked,
          'checklist_id': event.data['id'],
          'isApi': 1,
          'vin': vin,
        });
        Console.of.debug('response: $response');
       if (response != null) {
          vehicleConfigData.forEach((element) {
            if (element['id'] == event.data['category_id']) {
              element['checklists'].forEach((checklist) {
                if (checklist['id'] == event.data['id']) {
                  checklist['checked'] = event.isChecked ?? 0;
                }
              });
            }
          });
        }

        emit(VehicleStatusConfigCommonState());
      }catch (e) {
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

    on<AllCheckListSelectedEvent>((event, emit) async{
      try {
        _fBroadcast.broadcast("vehicleStatus",value: true);
        Console.of.debug('event.data: ${event.isAllChecked} ${event.data}');
        var response = await _apiRepository.vehicleConfigCheckList(body: {
          'category_id': event.data['id'],
          'checkbox_value': event.isAllChecked,
          'isApi': 1,
          'type': 'all',
          'vin': vin,
        });
        var ids = [];
        if (event.data is Map) {
          ids.add(event.data['id']);
        } else {
          ids = event.data.map((e) => e['id']).toList();
        }
       if(response != null) {
          vehicleConfigData.forEach((element) {
            if (ids.contains(element['id'])) {
              element['checklists'].forEach((checklist) {
                checklist['checked'] = event.isAllChecked ?? 0;
              });
              element['checked'] = event.isAllChecked ?? 0;
            }
          });
        }
        emit(VehicleStatusConfigCommonState());
      }catch (e) {
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

    on<SwapIndexSaveEvent>((event, emit) async{
      try {
        emit(VehicleStatusConfigLoadingState());
        categoryIdList=List.from(event.data.map((e) => e['id']).toList());
        var id = event.data[0]['category_id'];
        var response = await _apiRepository.vehicleCheckListSwap(body: {
          'categoryId': id,
          'orderChecklist':categoryIdList,
          'vin':vin,
        });
        if(response?['checklists'] == "success"){
          vehicleConfigData.where((element) => element['id'] == id).toList()
              .first['checklists'] = event.data;
        }else{
          Toaster.showError(response?['message']);
        }
        emit(VehicleStatusConfigCommonState());
      }catch (e) {
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

    on<InitialDialogData>((event, emit) async{
      if(event.data != null ){
        matchedData = vehicleConfigData.firstWhereOrNull((element) => element['id'] == event.data['id']);
      }
      Console.of.debug('matchedData: $matchedData');
      emit(ShowSwapDialogState());
    });

  }

  ///EDIT VEHICLE NOTES API CALL
  Future<Map<String, dynamic>?> _getVehicleConfig({String? vin}) async =>
      await _apiRepository.getVehicleStatusConfig(vin: vin);

}