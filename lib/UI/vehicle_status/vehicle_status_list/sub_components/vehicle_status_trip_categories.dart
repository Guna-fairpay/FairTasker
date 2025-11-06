import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusTripCategories extends StatelessWidget {
  const VehicleStatusTripCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
      builder: (context, state) => (context
              .watch<VehicleStatusBloc>()
              .showRentalCategories || (context
          .read<VehicleStatusBloc>()
          .selectedCategory?['id'] != 3))
          ? const SizedBox.shrink()
          : Wrap(
              spacing: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 5,
              children: context
                  .read<VehicleStatusBloc>()
                  . tripStatusCategories
                  .map((e) => FilterChip(
                        label: Text("${e['name'] ?? ""}"),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        elevation: 2,
                        deleteIconBoxConstraints: const BoxConstraints(),
                        deleteIcon: Text(
                          "(${e['count'] ?? 0})",
                          style: context.textTheme.labelSmall?.copyWith(
                              color: ((context
                                          .read<VehicleStatusBloc>()
                                          .selectedTripCategory['id'] ==
                                      e['id'])
                                  ? Colors.white
                                  : null),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato"),
                        ),
                        onDeleted: () => context
                            .read<VehicleStatusBloc>()
                            .add(VehicleStatusOnChangeTripCategory(e)),
                        selected: (context
                                .read<VehicleStatusBloc>()
                                .selectedTripCategory['id'] ==
                            e['id']),
                        onSelected: (value) => context
                            .read<VehicleStatusBloc>()
                            .add(VehicleStatusOnChangeTripCategory(e)),
                      ))
                  .toList(),
            ),
    );
  }
}
