import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/UI/import_task/import_task_main_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusFilterUi extends StatelessWidget {
  const VehicleStatusFilterUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
      builder: (context, state) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          if ((context.watch<VehicleStatusBloc>().selectedCategory?['id'] ==
              3)) ...[
            Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value:
                        context.watch<VehicleStatusBloc>().showRentalCategories,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) => context
                        .read<VehicleStatusBloc>()
                        .add(VehicleStatusDisplayRentalCategories()),
                  ),
                ),
                Text(
                  "Status",
                  style: context.textTheme.labelLarge,
                ),
              ],
            ),
            5.width,
            IconButton.filled(
              onPressed: () => context.push(const ImportTaskMainUi(fixedPage: 1), fullscreenDialog: true),
              icon: const Icon(Icons.upload_rounded),
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Num.borderRadiusLarge)))),
            )
          ],
          GestureDetector(
              onTapDown: (val) => context.read<VehicleStatusBloc>().add(VehicleStatusShowSortingEvent(val)),
              child: Padding(
                  padding: 10.rightPadding,
                  child: Icon(Icons.filter_alt_outlined, color: AppC().base)))
        ],
      ),
    );
  }
}
