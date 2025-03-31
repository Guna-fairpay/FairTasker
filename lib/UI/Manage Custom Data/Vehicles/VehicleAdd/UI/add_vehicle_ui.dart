
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'add_vehicle_body.dart';

class AddVehicleUI extends StatelessWidget {
  const AddVehicleUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddVehicleBloc>(
      create: (context) => AddVehicleBloc()..add(AddVehicleInitialEvent()),
      child: BlocListener<AddVehicleBloc, AddVehicleState>(
        listener: (context, state) {
          if (state is AddVehicleLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Vehicle'),
            automaticallyImplyLeading: false,
            foregroundColor: AppC.white,
            backgroundColor: AppC.appColor,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context,);
                },
                icon: const Icon(Icons.close),
              )
            ]
          ),
          body:  const SafeArea(
            minimum: EdgeInsets.symmetric(horizontal:15,vertical: 10),
            child: AddVehicleBody(),
          ),
        ),
      ),
    );
  }
}

