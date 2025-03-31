
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/UI/add_vehicle_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/TabBarPages/Vehicle_edit_tab_bar.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_listing_page.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class VehicleMainPage extends StatelessWidget {
  const VehicleMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleBloc>(
      create: (context) => VehicleBloc()..add(VehicleInitialEvent()),
      child: BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is AddVehicleState) context.push(const AddVehicleUI(),fullscreenDialog: true);
            if (state is EditVehicleTabState) context.push(VehicleEditTabBar(vehicle: state.vehicleData));
          }
        },
        child: const VehicleListingUI(),
      ),
    );
  }
}
