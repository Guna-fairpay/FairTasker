import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/UI/private_rental_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/UI/private_rental_edit_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/UI/private_rental_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/private_rental_list_item.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivateRentalListingPage extends StatelessWidget {
  const PrivateRentalListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateRentalBloc, PrivateRentalState>(
        builder: (context, state) => Column(
                spacing: 10,
                children: [
                  if (!context.watch<PrivateRentalBloc>().isEditing)
                    PrivateRentalAddUI(
                        searchChild: const PrivateRentalSearchView(),
                        rentalData:
                            context.watch<PrivateRentalBloc>().selectedModel),
                  if (context.watch<PrivateRentalBloc>().isEditing)
                    PrivateRentalEditUI(
                        rentalData: context
                            .watch<PrivateRentalBloc>()
                            .selectedModel?['rental'],
                        searchChild: const PrivateRentalSearchView(),
                        onClear: () => context
                            .read<PrivateRentalBloc>()
                            .add(PrivateRentalClearEditEvent())),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(6),
                      2: FlexColumnWidth(3),
                    },
                    border: const TableBorder(
                        horizontalInside: BorderSide(
                            color: AppC.borderColor,
                            width: Num.borderWidthThinField)),
                    children: [
                      TableRow(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(Num.borderRadius)),
                              color: AppC.appbgColor),
                          children: [
                            Padding(
                                padding: 5.sp.padding,
                                child: Text("Vehicle Name",
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp))),
                            Padding(
                                padding: 5.sp.padding,
                                child: Text("Customer",
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp))),
                            Padding(
                                padding: 5.sp.padding,
                                child: SizedBox.shrink()),
                          ]),
                      ...context
                          .watch<PrivateRentalBloc>()
                          .filteredResponse
                          .map((e) => PrivateRentalListItem(
                                vehicle: e,
                                onAdd: () => context
                                    .read<PrivateRentalBloc>()
                                    .add(AddPrivateRentalEvent(vehicleData: e)),
                                onEdit: () => context
                                    .read<PrivateRentalBloc>()
                                    .add(EditPrivateRentalEvent(rentalData: e)),
                                onDelete: () => AskPermissionDialog.show(
                                    context,
                                    title: "Are you sure?",
                                    description:
                                        "Do you want to delete this Vehicle's rental?",
                                    positiveText: "Yes, delete it!",
                                    negativeText: "Cancel",
                                    isReasonRequired: false,
                                    onPositivePressed: () => context
                                        .read<PrivateRentalBloc>()
                                        .add(
                                          DeletePrivateRentalEvent(
                                              vehicleId: e['id'].toString()),
                                        )),
                              ))
                          .toList()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      color: AppC.blue50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.getText('Vehicle Name',
                                      weight: FontWeight.bold),
                                ],
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Utils.getText('Customer',
                                    weight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      height: 0.5,
                    ),
                    itemCount: context
                        .watch<PrivateRentalBloc>()
                        .filteredResponse
                        .length,
                    itemBuilder: (context, index) {
                      final vehicle = context
                          .watch<PrivateRentalBloc>()
                          .filteredResponse[index];
                      final vehicleId = vehicle['id'];
                      final customer = (vehicle['customer'] is Map &&
                              vehicle['customer'] != null)
                          ? vehicle['customer']
                          : {};
                      return SafeArea(
                        minimum: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => vehicle['rental'] != null
                                    ? context.read<PrivateRentalBloc>().add(
                                        EditPrivateRentalEvent(
                                            rentalData: vehicle))
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                Utils.getText(
                                    "${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}"),
                              ],
                            )),
                            if (vehicle['rental'] == null)
                              InkWell(
                                onTap: () => context
                                    .read<PrivateRentalBloc>()
                                    .add(AddPrivateRentalEvent(
                                        vehicleData: vehicle)),
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
                                      description:
                                          "Do you want to delete this Vehicle's rental?",
                                      positiveText: "Yes, delete it!",
                                      negativeText: "Cancel",
                                      isReasonRequired: false,
                                      onPositivePressed: () =>
                                          context.read<PrivateRentalBloc>().add(
                                                DeletePrivateRentalEvent(
                                                    vehicleId:
                                                        vehicleId.toString()),
                                              ));
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
                  ),*/
                  CompactPagination(
                      totalPages: context.watch<PrivateRentalBloc>().totalPages,
                      currentPage:
                          context.watch<PrivateRentalBloc>().currentPage,
                      onPageChanged: (value) => context
                          .watch<PrivateRentalBloc>()
                          .add(PrivateRentalPaginationEvent(value)))
                ],
              ));
  }
}
