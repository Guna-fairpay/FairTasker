import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleLogSearchView extends StatelessWidget {
  const VehicleLogSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogBloc, VehicleLogState>(
        builder: (context, state) => Padding(
          padding: 10.padding,
          child: Expanded(
            child: SearchBar(
              controller: context.read<VehicleLogBloc>().searchController,
              textInputAction: TextInputAction.search,
              // maxLines: 1,
              onChanged: (value) => context
                  .read<VehicleLogBloc>()
                  .add(VehicleLogSearchEvent(value)),
              onSubmitted: (value) => context
                  .read<VehicleLogBloc>()
                  .add(VehicleLogSearchEvent(value)),
              side: const WidgetStatePropertyAll(BorderSide.none),
              elevation: const WidgetStatePropertyAll(2),
              padding: WidgetStatePropertyAll(5.padding.copyWith(left: 10, right: 10)),
              hintText: "Search...",
              keyboardType: TextInputType.text,
              trailing: [GestureDetector(child: const Icon(Icons.add_circle_outline_rounded, color: AppC.appColor) ,onTap: () => context
                  .read<VehicleLogBloc>()
                  .add(AddVehicleLogEvent()),)],
              leading: const Icon(Icons.search_rounded, color: AppC.text),
              textStyle: WidgetStatePropertyAll(context.textTheme.titleSmall?.copyWith(color: AppC.text)),
              shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.borderRadiusXLarge))),
            ),
          ),
        ));
  }
}
