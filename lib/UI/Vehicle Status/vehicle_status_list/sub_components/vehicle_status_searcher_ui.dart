import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusSearcherUi extends StatelessWidget {
  const VehicleStatusSearcherUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
      buildWhen: (previous, current) =>
          (current is VehicleStatusShowSearcherState) ||
          (previous is VehicleStatusShowSearcherState) && (current != previous),
      builder: (context, state) =>
          (context.watch<VehicleStatusBloc>().showSearcher)
              ? Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child: CustomDropdown(
                        items: context.watch<VehicleStatusBloc>().cohortsData,
                        itemAsString: (item) => item['cohort'].toString(),
                        value: context.watch<VehicleStatusBloc>().selectedCohort,
                        onChanged: (value) => context
                            .read<VehicleStatusBloc>()
                            .add(VehicleStatusCohortChangeEvent(value)),
                        contentPadding: 5.padding,
                      )),
                      Expanded(
                          child: Utils.getSearchBarUI(
                              searchController: context
                                  .read<VehicleStatusBloc>()
                                  .searchController)),
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            side: const WidgetStatePropertyAll(BorderSide())),
                      )
                    ],
                  ),
              )
              : const SizedBox.shrink(),
    );
  }
}
