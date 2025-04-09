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
    var border = OutlineInputBorder(borderRadius: BorderRadius.circular(Num.borderRadius), borderSide: const BorderSide(color: AppC.text, width: Num.borderWidthThinField));
    return BlocBuilder<VehicleLogBloc, VehicleLogState>(
        builder: (context, state) => Expanded(
          flex: 3,
          child: TextField(
            controller: context.read<VehicleLogBloc>().searchController,
            textInputAction: TextInputAction.search,
            onChanged: (value) => context
                .read<VehicleLogBloc>()
                .add(VehicleLogSearchEvent(value)),
            onSubmitted: (value) => context
                .read<VehicleLogBloc>()
                .add(VehicleLogSearchEvent(value)),
            keyboardType: TextInputType.text,
            maxLines: 1,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            style: context.textTheme.titleSmall?.copyWith(color: AppC.appColor),
            decoration: InputDecoration(
              isDense: true,
              hintText: "Search...",
              contentPadding: 7.padding,
              prefixIconConstraints: const BoxConstraints(),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              hintStyle: context.textTheme.titleSmall?.copyWith(color: AppC.text),
              prefixIcon: Padding(padding: 10.horizontalPadding, child: const Icon(Icons.search_rounded, color: AppC.text)),
            ),
          ),
        ));
  }
}
