import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class VehicleMainSearchView extends StatelessWidget {
  const VehicleMainSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) => Expanded(
          flex: 3,
          child: Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
                children: [
                  CompactIconButton(
                    icon: Icons.add_rounded,
                    backgroundColor: AppC.bouncieButtonColor,
                    onPressed: () => context.read<VehicleBloc>().add(VehicleGroupingTapEvent()),
                  ),
                  Expanded(child: CompactSearchView(
                    controller: context.read<VehicleBloc>().searchController,
                    onChanged: (value) => context.read<VehicleBloc>().add(SearchVehicleEvent(value)),
                  ))
                ],
              ),
        ));
  }
}
