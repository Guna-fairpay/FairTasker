
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_checklist/Bloc/vehicle_status_checklist_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_checklist/Bloc/vehicle_status_checklist_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusChecklistBloc extends Bloc<VehicleStatusChecklistEvent, VehicleStatusChecklistState>{

  final APiRepository _apiRepository = APiRepository();
  List<dynamic> vehicleConfigData = [];
  String? vin;
  dynamic data;
  double percentage =0.0;
  final FBroadcast _fBroadcast = FBroadcast.instance();
  String? get _userId => Session.of.getString(Str.userIdPrefText);

  VehicleStatusChecklistBloc() : super(VehicleStatusChecklistLoadingState()) {

    on<GetVehicleStatusCheckListData>((event, emit) async{
      try {
        emit(VehicleStatusChecklistLoadingState());
        vin = event.vin;
        data = event.data;
        var response = await _getVehicleCheckList(vin: vin);
        vehicleConfigData = List.from(response?['categories'] ?? []);
        percentage = double.tryParse("${response?['percentage']}") ?? 0.0;
        emit(VehicleStatusChecklistCommonState());
      }catch (e) {
        emit(VehicleStatusChecklistCommonState());
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

    on<CheckListSelectedEvent>((event, emit) async{
      try {
       emit(VehicleStatusChecklistLoadingState());
        Console.of.debug('event.data: ${event.isChecked} ${data}');
        var response = await _apiRepository.createChecklistTodo(body: {
          'category_id': event.data['category_id'],
          'checkbox_value': event.isChecked,
          'checklist_id': event.data['checklist_id'],
          'cohort_id': data['cohort_id'],
          'cohort_name': data['cohort'],
          'config_id': event.data['id'],
          'task_name': event.data['task_name'],
          'user_id': _userId,
          'vehicle_name': data['vehicle_name'],
          'vehicle_image': data['images'][0]['path']??'',
          'vin':  event.data['vin'],
        });
        Console.of.debug('response: $response');
        var percentageResponse = await _apiRepository.vehicleStatusChecklist(body: {
          'category_id': event.data['category_id'],
          'checkbox_value': event.isChecked,
          'checklist_id': event.data['checklist_id'],
          'config_id': event.data['id'],
          'vin':  event.data['vin'],
        });
        Console.of.debug('percentageResponse: $percentageResponse');
        if(percentageResponse != null){
          percentage = double.tryParse("${percentageResponse['percentage']}") ?? 0.0;
        }
        if(event.data['category_id'].toString() != data['vehicle_status'].toString()) {
          var response = await _apiRepository.vehicleStatusUpdate(body: {
            'vehicle_status': event.data['category_id'],
            'vehicle_status_update': DateTime.now().toFormat(format: "yyyy-MM-dd"),
            'vin': event.data['vin'],
          });
          Console.of.debug('vehicle-response: $response');
        }
        if ((response?['status']==200)) {
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
        _fBroadcast.broadcast("vehicleStatus",value: true);
        emit(VehicleStatusChecklistCommonState());
      } catch (e) {
        Toaster.showError(e);
        Console.of.error(e);
      }
    });

  }

  ///EDIT VEHICLE NOTES API CALL
  Future<Map<String, dynamic>?> _getVehicleCheckList({String? vin}) async =>
      await _apiRepository.vehicleStatusCheckList(vin: vin);

}