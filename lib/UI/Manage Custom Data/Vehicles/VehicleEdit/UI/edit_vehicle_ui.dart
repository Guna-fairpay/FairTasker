
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_body.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditVehicleUI extends StatelessWidget {
  final dynamic vehicleData;
  final Widget? searchChild;
  final VoidCallback? onClear;
  const EditVehicleUI({super.key,required this.vehicleData, this.searchChild, this.onClear});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditVehicleBloc>(
      create: (context) => EditVehicleBloc()..add(EditVehicleInitialEvent(vehicleData: vehicleData)),
      child: BlocListener<EditVehicleBloc, EditVehicleState>(
        listener: (context, state) {
          if (state is EditVehicleLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (state is! EditCompletedState) if (EasyLoading.isShow) EasyLoading.dismiss();
            // if (state is EditCompletedState) onClear?.call();
            switch(state) {
              case EditVehicleSuccessState(): Toaster.showSuccess(state.message, context: context); break;
              case EditVehicleErrorState(): Toaster.showError(state.message, context: context); break;
              case EditCompletedState(): onClear?.call(); break;
            }
          }
        },
        child: SafeArea(
          child: EditVehicleBody(vehicleData: vehicleData, searchChild: searchChild, onClear: onClear),
        ),
      ),
    );
  }
}

