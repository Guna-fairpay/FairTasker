
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/UI/private_rental_listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PrivateRentalMainPage extends StatelessWidget {
  const PrivateRentalMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrivateRentalBloc>(
      create: (context) => PrivateRentalBloc()..add(PrivateRentalInitialEvent()),
      child: BlocListener<PrivateRentalBloc, PrivateRentalState>(
        listener: (context, state) {
          if (state is PrivateRentalLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
           // if (state is AddPrivateRentalState) context.push(const AddVehicleUI(),fullscreenDialog: true);
           // if (state is EditPrivateRentalState) context.push(VehicleEditTabBar(vehicle: state.vehicleData));
          }
        },
        child: const PrivateRentalListingPage(),
      ),
    );
  }
}

