import 'package:fairpytasker/Component/vehicle_trip_type_card.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/vehicle_status_card.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class VehicleStatusCarListing extends StatelessWidget {
  const VehicleStatusCarListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
      buildWhen: (previous, current) => (current != previous),
      builder: (context, state) => (context
              .watch<VehicleStatusBloc>()
              .showMiscellaneous)
          ? (context.read<VehicleStatusBloc>().miscellaneousVehicles.isEmpty)
              ? const EmptyWidget()
              : Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var model = context
                            .read<VehicleStatusBloc>()
                            .miscellaneousVehicles[index];
                        return Material(
                          elevation: 2,
                          child: ListTile(
                            dense: true,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Num.borderRadiusLarge)),
                            tileColor: context.theme.cardColor,
                            contentPadding: 10.padding,
                            minLeadingWidth: 0,
                            minVerticalPadding: 0,
                            minTileHeight: 0,
                            title: Text("${model['vehicle_name'] ?? ""}"),
                            trailing: Text.rich(TextSpan(children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.sports_basketball_rounded,
                                size: 14,
                                color: AppC().base,
                              )),
                              TextSpan(
                                  text:
                                      "\t\$ ${(model['wholesale_amount'] ?? 0).toStringAsFixed(2)}")
                            ])),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 5.height,
                      itemCount: context
                          .read<VehicleStatusBloc>()
                          .miscellaneousVehicles
                          .length))
          : (context.watch<VehicleStatusBloc>().showRentalCategories)
              ? (context
                      .read<VehicleStatusBloc>()
                      .filteredVehicleStatus
                      .isEmpty)
                  ? const EmptyWidget()
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var model = context
                                .read<VehicleStatusBloc>()
                                .filteredVehicleStatus[index];
                            return VehicleStatusCard(
                                model: model,
                                onComplete:()async{
                                  if(model['vehicle_status']==5){
                                    context.read<VehicleStatusBloc>().add(VehicleOnCompleteEvent(model: model));
                                  }else{
                                    context.read<VehicleStatusBloc>().add(VehicleStatusCompletedPopupEvent(model: model));
                                  }
                                  return false;
                                  },
                                onPrevious: () async {
                                  context.read<VehicleStatusBloc>().add(VehicleStatusPreviousPopupEvent(model: model));
                                  return false;
                                },
                                onPressed: (type) => context
                                    .read<VehicleStatusBloc>()
                                    .add(VehicleStatusOnTapEvent(
                                        model: model, type: type)),
                                dismissDirection: [1, 4, 5].contains(context
                                        .read<VehicleStatusBloc>()
                                        .selectedCategory?['id'])
                                    ? DismissDirection.horizontal
                                    : [7].contains(context
                                            .read<VehicleStatusBloc>()
                                            .selectedCategory?['id'])
                                        ? DismissDirection.none
                                        : DismissDirection.startToEnd,
                                categoryId: context
                                    .read<VehicleStatusBloc>()
                                    .selectedCategory?['id']);
                          },
                          itemCount: context
                              .watch<VehicleStatusBloc>()
                              .filteredVehicleStatus
                              .length),
                    )
              : (context.read<VehicleStatusBloc>().filteredTrips.isEmpty)
                  ? const EmptyWidget()
                  : Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var model = context
                                .read<VehicleStatusBloc>()
                                .filteredTrips[index];
                            return VehicleTripTypeCard(model: model);
                          },
                          separatorBuilder: (context, index) => const Divider(
                                thickness: Num.borderWidthThinField,
                                height: Num.borderWidthThinField,
                                color: AppC.borderColor,
                              ),
                          itemCount: context
                              .read<VehicleStatusBloc>()
                              .filteredTrips
                              .length)),
    );
  }
}
