import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';

class PrivateRentalListingPage extends StatelessWidget {
  const PrivateRentalListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateRentalBloc, PrivateRentalState>(
        builder: (context, state) => (context.watch<PrivateRentalBloc>().filteredResponse.isEmpty && (state is PrivateRentalLoadedState))
            ? const EmptyWidget()
            : Scaffold(
          body: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Utils.getSearchBarUI(
                      onChange: (value) => context.read<PrivateRentalBloc>().add(SearchPrivateRentalEvent(value)),
                      searchController: context.read<PrivateRentalBloc>().searchController,
                    ),
                  ),
                  Utils.getAddElevatedButton(() => context.read<PrivateRentalBloc>().add(AddPrivateRentalEvent()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  color: AppC.blue50,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.getText('Vehicle Name', weight: FontWeight.bold),
                            ],
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.getText('Customer', weight: FontWeight.bold),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(height: 0.5,),
                  itemCount: context.watch<PrivateRentalBloc>().filteredResponse.length,
                  itemBuilder: (context, index) {
                    final vehicle = context.watch<PrivateRentalBloc>().filteredResponse[index];
                    final vehicleId = vehicle['id'];
                    final customer = (vehicle['customer'] is Map && vehicle['customer'] != null)
                        ? vehicle['customer']
                        : {};
                    final watch = context.watch<PrivateRentalBloc>();
                    final read = context.read<PrivateRentalBloc>();
                    return SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => vehicle['rental'] != null
                                  ? context.read<PrivateRentalBloc>().add(EditPrivateRentalEvent(vehicleData: vehicle))
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      vehicle['vehicle_name'] ?? '',
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          10.width,
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.getText("${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}"),
                                ],
                              )),
                          if (vehicle['rental'] == null)
                            InkWell(
                              onTap: () => context.read<PrivateRentalBloc>().add(AddPrivateRentalEvent()),
                              child: const Icon(
                                Icons.add,
                                color: AppC.green,
                              ),
                            ),
                          if (vehicle['rental'] != null)
                            GestureDetector(
                              onTap: () {
                                AskPermissionDialog.show(context,
                                    title: "Are you sure?",
                                    description: "Do you want to delete this Vehicle's rental?",
                                    positiveText: "Yes, delete it!",
                                    negativeText: "Cancel",
                                    isReasonRequired: false,
                                    onPositivePressed: () => read.add(DeletePrivateRentalEvent(vehicleId: vehicleId.toString()),));
                                },
                              child: const Icon(
                                Icons.delete_outline,
                                color: AppC.redAccent,
                              ),
                            ),
                        ],
                      ),
                    );
                    },
                ),
              ),
            ],
          ),
        )
    );
  }
}
