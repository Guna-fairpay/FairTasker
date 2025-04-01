
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditVehicleUI extends StatelessWidget {
  final dynamic vehicleData;
  const EditVehicleUI({super.key,required this.vehicleData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditVehicleBloc>(
      create: (context) => EditVehicleBloc()..add(EditVehicleInitialEvent(vehicleData: vehicleData)),
      child: BlocListener<EditVehicleBloc, EditVehicleState>(
        listener: (context, state) {
          if (state is EditVehicleLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is EditCompletedState) Navigator.pop(context);
          }
        },
        child:  Scaffold(
          body:  SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal:15,vertical: 10),
            child: EditVehicleBody(vehicleData: vehicleData),
          ),
        ),
      ),
    );
  }
}

