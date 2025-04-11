import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/UI/edit_private_rental_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PrivateRentalEditUI extends StatelessWidget {
  final dynamic rentalData;
  final Widget? searchChild;
  final VoidCallback? onClear;
  const PrivateRentalEditUI({super.key,required this.rentalData, this.searchChild, this.onClear});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPrivateRentalBloc>(
      create: (context)=>EditPrivateRentalBloc()..add(EditPrivateRentalInitialEvent(rentalData: rentalData)),
      child: BlocListener<EditPrivateRentalBloc, EditPrivateRentalState>(
        listener: (context, state) {
          if (state is EditPrivateRentalLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is EditPrivateRentalCompletedState) onClear?.call();
          }
        },
        child: EditPrivateRentalBody(searchChild: searchChild, onClear: onClear),
      ),
    );
  }
}