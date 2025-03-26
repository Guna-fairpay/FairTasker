
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/UI/vehicle_listing_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
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
          }
        },
        child: const VehicleListingUI(),
      ),
    );
  }
}
