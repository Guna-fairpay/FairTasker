import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleMainTabViewUi extends StatelessWidget {
  const VehicleMainTabViewUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(builder: (context, state) => Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: Num.borderWidthThinField)
          ),
      ),
      height: 35.spMin,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          CustomTabButton(buttonText: "Vehicles", value: 0, selectedValue: context.watch<VehicleBloc>().selectedTab, onPressed: (val) => context.read<VehicleBloc>().add(VehicleTabChangeEvent(tabIndex: val))),
          if (context.watch<VehicleBloc>().selectedVehicle != null)
            ...[
              CustomTabButton(buttonText: "Expenses", value: 1, selectedValue: context.watch<VehicleBloc>().selectedTab, onPressed: (val) => context.read<VehicleBloc>().add(VehicleTabChangeEvent(tabIndex: val))),
              CustomTabButton(buttonText: "Repair & ..", value: 2, selectedValue: context.watch<VehicleBloc>().selectedTab, onPressed: (val) => context.read<VehicleBloc>().add(VehicleTabChangeEvent(tabIndex: val))),
              CustomTabButton(buttonText: "Log", value: 3, selectedValue: context.watch<VehicleBloc>().selectedTab, onPressed: (val) => context.read<VehicleBloc>().add(VehicleTabChangeEvent(tabIndex: val))),
            ],
          CustomTabButton(buttonText: "PR", value: 4, selectedValue: context.watch<VehicleBloc>().selectedTab, onPressed: (val) => context.read<VehicleBloc>().add(VehicleTabChangeEvent(tabIndex: val))),
          // if (context.watch<VehicleBloc>().selectedVehicle == null)
          // const Spacer(),
        ],
      ),
    ));
  }
}
