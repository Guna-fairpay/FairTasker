import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_expense_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_rm_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/TabBarPages/vehicle_log.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_add_edit_list_ui.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleMainTabContentViewUi extends StatelessWidget {
  const VehicleMainTabContentViewUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(builder: (context, state) => Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: Num.borderWidthThinField)
          )
      ),
      child: switch(context.watch<VehicleBloc>().selectedTab) {
        0 => const VehicleAddEditListUi(),
        1 => EditVehicleExpenseDetailsUI(vin: context.watch<VehicleBloc>().selectedVehicle?['vin']),
        2 => VehicleRMUI(vin: context.watch<VehicleBloc>().selectedVehicle?['vin']),
        3 => VehicleLogUI(vin: context.watch<VehicleBloc>().selectedVehicle?['vin']),
        4 => Container(padding: 10.padding, color: Colors.black),
        _ => Container(padding: 10.padding, color: Colors.blue),
      },
    ));
  }
}
