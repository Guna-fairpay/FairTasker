import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_state.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Component/swap_popup.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/UI/vehicle_status_config_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/utils.dart';

class VehicleStatusConfigUI extends StatelessWidget {
  final String? vin;
  final String? vehicleName;
  const VehicleStatusConfigUI(
      {super.key, required this.vin, required this.vehicleName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleStatusConfigBloc>(
      create: (context) =>
          VehicleStatusConfigBloc()..add(GetVehicleStatusConfigData(vin: vin)),
      child: BlocListener<VehicleStatusConfigBloc, VehicleStatusConfigState>(
        listener: (context, state) {
          if (state is VehicleStatusConfigLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if(state is ShowSwapDialogState) {
              SwapIndexPopUp.show(
                /*data: state.data,*/
                context,
                onReorderUpdate: (value)=>context.read<VehicleStatusConfigBloc>().add(SwapIndexSaveEvent(data:value)));
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppC.appColor,
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
          body: const VehicleStatusConfigBody(),
        ),
      ),
    );
  }
}
