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
              .showRentalCategories)
          ? Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var model = context
                        .read<VehicleStatusBloc>()
                        .filteredVehicleStatus[index];
                    return VehicleStatusCard(
                        model: model,
                        onComplete: () async {
                          context.read<VehicleStatusBloc>().add(VehicleOnCompleteEvent(model: model));
                          return false;
                        },
                        onPrevious: () async {
                          context.read<VehicleStatusBloc>().add(VehicleOnPreviousEvent(model: model));
                          return false;
                        },
                        onPressed: (type) => context.read<VehicleStatusBloc>().add(VehicleStatusOnTapEvent(model: model, type: type)),
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
          : Expanded(
              child: (context.read<VehicleStatusBloc>().filteredTrips.isEmpty)
                  ? const Center(
                      child: EmptyWidget(),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        var model = context
                            .read<VehicleStatusBloc>()
                            .filteredTrips[index];
                        return Padding(
                          padding: 10.padding,
                          child: Column(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${((model['clean_task'] != null) && (model['clean_task'] is Map) && (model['clean_task']['vehicle_name'] ?? "").toString().isNotEmpty) ? (model['clean_task']['vehicle_name'] ?? "") : (model['vehicle_name'])}"),
                                  const TextSpan(text: "\t \t"),
                                  TextSpan(
                                      text: "(${model['vehicle_status']})",
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: context
                                                  .read<VehicleStatusBloc>()
                                                  .vehicleStatusColor(
                                                      model['vehicle_status'] ??
                                                          ""))),
                                ]),
                                style: context.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text.rich(TextSpan(children: [
                                TextSpan(text: "${model['trim_label'] ?? ""}"),
                                const TextSpan(text: "\t\u29bf\t"),
                                TextSpan(
                                    text: "${model['license_plate'] ?? ""}"),
                              ])),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(TextSpan(children: [
                                    const TextSpan(text: "Last trip:\t"),
                                    TextSpan(
                                        text: "${model['trip_date'] ?? ""}"),
                                  ])),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(text: "${(model['ratings'].toString().isEmpty) ? 0 : (model['ratings'] ?? 0)}"),
                                    const TextSpan(text: "\t\u2605\t"),
                                    TextSpan(
                                        text:
                                            "(${ (model['trip_count'].toString().isEmpty) ? 0 : (model['trip_count'] ?? 0)} trips)"),
                                  ])),
                                ],
                              )
                            ],
                          ),
                        );
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
