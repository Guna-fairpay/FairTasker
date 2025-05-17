import 'package:fairpytasker/Component/badge_button.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusCategoriesUi extends StatelessWidget {
  const VehicleStatusCategoriesUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
      buildWhen: (previous, current) => (current is VehicleStatusLoadedState),
      builder: (context, state) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var model = context
                          .watch<VehicleStatusBloc>()
                          .vehicleStatusCategories[index];
                      return BadgeButton(
                        value: model,
                        label: "${model['category_name']}",
                        count: model['count'] ?? 0,
                        selectedValue: context.watch<VehicleStatusBloc>().selectedCategory,
                        showBadge: true,
                        onPressed: (value) => context.read<VehicleStatusBloc>().add(VehicleStatusCategoryChangeEvent(value)),
                        padding: 10.padding,
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        // textStyle: context.textTheme.labelMedium,
                      );
                    },
                    separatorBuilder: (context, index) => 10.width,
                    itemCount: context
                        .watch<VehicleStatusBloc>()
                        .vehicleStatusCategories
                        .length),
              )),
          GestureDetector(
            onTap: () => context.read<VehicleStatusBloc>().add(VehicleStatusMiscEvent()),
            child: Padding(padding: 10.horizontalPadding, child: const Icon(Icons.keyboard_double_arrow_right, color: AppC.red),),
          ),
          GestureDetector(
            onTap: () => context.read<VehicleStatusBloc>().add(VehicleStatusShowHideSearcherEvent()),
            child: Image.asset(Assets.vehicleFilterIcon, height: 24, width: 30, color: ((context.watch<VehicleStatusBloc>().showSearcher)) ? AppC.red : AppC().base,),
          ),
        ],
      ),
    );
  }
}
