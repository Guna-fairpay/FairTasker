
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/checkbox_with_text.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Todo/set_vehicles/bloc/set_vehicles_bloc.dart';
import 'package:fairpytasker/UI/Todo/set_vehicles/component/sparekey_popup.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/formatter/upper_case_formatter.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'set_vehicle_form_field_ui.dart';

class SetVehiclesMainUI extends StatelessWidget {
  final dynamic todoItems;
  final dynamic selectedVehicle;
  const SetVehiclesMainUI({super.key, this.todoItems, this.selectedVehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SetVehiclesBloc()..add(InitialEvent(todoItems: todoItems, vehicle: selectedVehicle)),
      child: BlocListener<SetVehiclesBloc, SetVehiclesState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else{
            if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case SuccessState(): Toaster.showSuccess(state.message); break;
              case ErrorState(): Toaster.showError(state.message); break;
              case PopupState(): SpareKeyDialog.show(context, save: (value) => context.read<SetVehiclesBloc>().add(SaveVehicle(overRide: value))); break;
              default: break;
            }
            if (state is SuccessState) context.pop();
          }
        },
        child: const SetVehicleFormFieldUI(),
      ));
  }
}
