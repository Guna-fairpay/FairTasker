
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_checklist/Bloc/vehicle_status_checklist_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_checklist/Bloc/vehicle_status_checklist_event.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_checklist/Bloc/vehicle_status_checklist_state.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_checklist/UI/vehicle_status_check_list_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/utils.dart';

class VehicleStatusChecklistUI extends StatelessWidget {
  final String? vin;
  final String? vehicleName;
  final dynamic data;
  const VehicleStatusChecklistUI(
      {super.key, required this.vin, required this.vehicleName, this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleStatusChecklistBloc>(
      create: (context) =>
      VehicleStatusChecklistBloc()..add(GetVehicleStatusCheckListData(vin: vin,data: data)),
      child: BlocListener<VehicleStatusChecklistBloc, VehicleStatusChecklistState>(
        listener: (context, state) {
          if (state is VehicleStatusChecklistLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff5B9565),
            title: Utils.getText('${vehicleName ?? ''} - \n${vin ?? ''}',
                color: AppC.white, weight: FontWeight.bold, size: 18),
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          body: const VehicleStatusCheckListBodyUI(),
        ),
      ),
    );
  }
}
