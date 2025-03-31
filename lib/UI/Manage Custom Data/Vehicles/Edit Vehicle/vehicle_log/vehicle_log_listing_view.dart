import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log_bloc/vehicle_log_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleLogListingView extends StatelessWidget {
  const VehicleLogListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogBloc, VehicleLogState>(
      builder: (context, state) => Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                var model = context.watch<VehicleLogBloc>().expenseLogs?[index];
                return ListTile(
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateTime.tryParse(model?['created_at'] ?? "")
                              .toFormat(format: "MM/dd/yy") ??
                          ""),
                      Text(
                        DateTime.tryParse(model?['created_at'] ?? "")
                                .toFormat(format: "hh:mm a") ??
                            "",
                        style: context.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  title: Text("${model?['title'] ?? "Reference"} ${(model?['hasAttachments'] ?? false) ? "(${model?['attachmentLabel']})" : ""}"),
                  subtitle: Text.rich(TextSpan(text: model?['notes'] ?? ""),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  titleTextStyle: context.textTheme.labelLarge,
                  subtitleTextStyle: context.textTheme.labelSmall
                      ?.copyWith(color: AppC.appColor),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(<String>[
                        (model?['user']?['first_name'] ?? ""),
                        (model?['user']?['last_name'] ?? "")
                      ].toInitial, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                      if (model?['hasAttachments'] ?? false)
                        GestureDetector(
                            onTap: () => context.read<VehicleLogBloc>().add(VehicleLogViewAttachmentEvent(model)),
                            child: Padding(padding: 5.horizontalPadding, child: const Icon(Icons.attach_file_rounded,
                                color: AppC.appColor))),
                      GestureDetector(
                          onTap: () => context.read<VehicleLogBloc>().add(VehicleLogDeleteTapEvent(model)),
                          child: Padding(padding: 5.horizontalPadding, child: const Icon(Icons.delete_outline_rounded,
                              color: AppC.red))),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount:
                  context.watch<VehicleLogBloc>().expenseLogs?.length ?? 0)),
    );
  }
}
