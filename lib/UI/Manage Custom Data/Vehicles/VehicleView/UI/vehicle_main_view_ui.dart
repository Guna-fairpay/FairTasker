import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/UI/add_vehicle_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Bloc/vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_listing_page.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_tab_content_view_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_tab_view_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class VehicleMainViewUi extends StatelessWidget {
  const VehicleMainViewUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle"),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
      ),
      body: BlocProvider<VehicleBloc>(
        create: (context) => VehicleBloc()..add(VehicleInitialEvent()),
        child: BlocListener<VehicleBloc, VehicleState>(
          listener: (context, state) {
            if (state is VehicleLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: SafeArea(
            minimum: 16.sp.padding,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                const VehicleMainTabViewUi(),
                10.sp.height,
                const VehicleMainTabContentViewUi(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
