import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/UI/add_vehicle_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_listing_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_seach_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleAddEditListUi extends StatelessWidget {
  const VehicleAddEditListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(builder: (context, state) => Column(
      children: [
        if (context.watch<VehicleBloc>().selectedVehicle == null)
          const AddVehicleUI(searchChild: VehicleMainSearchView())
        else
          EditVehicleUI(vehicleData: context.watch<VehicleBloc>().selectedVehicle, searchChild: const VehicleMainSearchView(), onClear: () => context.read<VehicleBloc>().add(VehicleClearEditEvent())),
        const VehicleListingUI()
      ],
    ));
  }
}
