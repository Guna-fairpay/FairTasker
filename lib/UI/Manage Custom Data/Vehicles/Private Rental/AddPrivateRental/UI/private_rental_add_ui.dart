
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/UI/add_private_rental_body.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PrivateRentalAddUI extends StatelessWidget {
  final dynamic rentalData;
  final Widget? searchChild;
  const PrivateRentalAddUI({super.key, this.rentalData, this.searchChild});

  @override
  Widget build(BuildContext context) {
    Console.of.log(rentalData);
    return BlocProvider<AddPrivateRentalBloc>(
      create: (context)=> AddPrivateRentalBloc()..add(AddPrivateRentalInitialEvent(rentalData: rentalData)),
      child: BlocListener<AddPrivateRentalBloc, AddPrivateRentalState>(
        listener: (context, state) {
          if (state is AddPrivateRentalLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            // if (state is AddPrivateRentalCompleteState) Navigator.pop(context);
          }
        },
        child: AddPrivateRentalBody(searchChild: searchChild),
      ),
    );
  }
}
