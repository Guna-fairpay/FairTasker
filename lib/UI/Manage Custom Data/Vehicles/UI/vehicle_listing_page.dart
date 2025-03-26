
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Bloc/vehicle_state.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/UI/vehicle_grouping_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/UI/add_vehicle_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VehicleListingUI extends StatelessWidget {
  const VehicleListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) => (context.watch<VehicleBloc>().filteredResponse.isEmpty
          && (state is VehicleLoadedState)) ? const EmptyWidget()
          : Scaffold(
            body: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(
                        onChange: (value) =>
                            context.read<VehicleBloc>().add(SearchVehicleEvent(value)),
                        searchController: context.read<VehicleBloc>().searchController,
                      ),
                    ),
                    Utils.getAddElevatedButton(
                          () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddVehicleUI(),fullscreenDialog: true)),
                    ),
                  ],
                ),
                Expanded(
                        child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 0.5,
                ),
                itemCount: context.watch<VehicleBloc>().filteredResponse.length,
                itemBuilder: (context, index) {
                  final vehicle = context.read<VehicleBloc>().filteredResponse[index];
                  final vehicleId = vehicle['id'];
                  final watch = context.watch<VehicleBloc>();
                  final read = context.read<VehicleBloc>();
                  return SafeArea(
                    minimum: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              side: const BorderSide(
                                  color: AppC.appColor, width: 1),
                              activeColor: const Color(0xff4788ff),
                              value: watch.selectedVehicles[vehicleId] ??
                                  false,
                              onChanged: (bool? value) {
                                read.add(SelectedVehicleEvent(
                                  vehicleId: vehicleId,
                                  isSelected: value ?? false,)
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 4),
                              child: Utils.getText(
                                vehicle['vehicle_name'] ?? '',
                                weight: FontWeight.bold,
                                color: vehicle['vin'].contains("UNASSIGNED") ? AppC.red: AppC.text,
                              ),
                            ),
                          ),
                        ),
                        if (vehicle['rental_status'] == 0)
                          InkWell(
                            onTap:
                                () {
                                  AskPermissionDialog.show(context,
                                      title: "Are you sure?",
                                      description: "Do you want to move this vehicle to a private rental?",
                                      positiveText: "Yes!",
                                      negativeText: "Cancel",
                                      isReasonRequired: false,
                                      onPositivePressed: () => read.add(MoveToPrivateRentalEvent(vehicleData: vehicle),));
                                }, //=> _rentalVehicle(vehicle),
                            child: SvgPicture.asset(
                              Assets.rentalCar,
                              height: 24,
                            ),
                          ),
                        GestureDetector(
                          onTap: (){
                            AskPermissionDialog.show(context,
                                title: "Are you sure?",
                                description: "Do you want to delete this Vehicle?",
                                positiveText: "Yes, delete it!",
                                negativeText: "Cancel",
                                isReasonRequired: false,
                                onPositivePressed: () => read.add(VehicleDeleteEvent(vehicleId: vehicleId.toString()),));
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppC.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                },),
                ),
              ],
            ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            var selectedVehicles = context.read<VehicleBloc>().selectedIds;
            var vehicleList = context.read<VehicleBloc>().apiResponse;
            Navigator.push(context,MaterialPageRoute(builder: (context)=>VehicleGroupingUI(
            selectedVehicleIds: selectedVehicles,
            vehicleList: vehicleList,
          ),),);},
          extendedPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          elevation: 8,
          backgroundColor: AppC.appColor,
          label: Utils.getText('Vehicle Grouping',
              color: AppC.white, weight: FontWeight.bold, size: 16),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
    );
  }
}
