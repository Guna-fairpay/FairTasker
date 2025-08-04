import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleTripTypeCard extends StatelessWidget {
  final Map<String, dynamic> model;
  const VehicleTripTypeCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
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
                  "${((model['clean_task'] != null) && (model['clean_task'] is Map) && (model['clean_task']['vehicle_name'] ?? "").toString().isNotEmpty) ? (model['clean_task']['vehicle_name'] ?? "") : (model['vehicle_name'].toString().isNotEmpty ? model['vehicle_name'] : (getIt<CommonService>().activeVehicleList.firstWhereOrNull((element) => element['vin'] == model['vin'])?['vehicle_name'] ?? "") ?? "")}"),
              const TextSpan(text: "\t \t"),
              TextSpan(
                  text: "(${model['vehicle_status'] ?? "STATUS"})",
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
  }
}
