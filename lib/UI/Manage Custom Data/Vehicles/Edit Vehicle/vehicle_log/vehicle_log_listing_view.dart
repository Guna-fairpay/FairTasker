import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/vehicle_log_list_item.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class VehicleLogListingView extends StatelessWidget {
  const VehicleLogListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogBloc, VehicleLogState>(
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var model = context.watch<VehicleLogBloc>().expenseLogs?[index];
            return VehicleLogListItem(model: model, onAttachmentTap: () => context.read<VehicleLogBloc>().add(VehicleLogViewAttachmentEvent(model)),
            onDeleteTap: () => context.read<VehicleLogBloc>().add(VehicleLogDeleteTapEvent(model)),
            onNotesTap: () => context.read<VehicleLogBloc>().add(VehicleLogNotesTapEvent(model)));
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount:
              context.watch<VehicleLogBloc>().expenseLogs?.length ?? 0),
    );
  }
}
