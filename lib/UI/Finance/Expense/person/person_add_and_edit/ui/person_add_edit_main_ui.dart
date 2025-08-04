import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/person/person_add_and_edit/bloc/person_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'person_add_edit_form_field.dart';

class PersonAddEditMainUI extends StatelessWidget {
  final dynamic model;
  const PersonAddEditMainUI({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonAddEditBloc()..add(InitialEvent(model: model)),
        child: BlocListener<PersonAddEditBloc, PersonAddEditState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            }else{
              if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState():
                  Toaster.showError(state.message);
                  break;
                case SuccessState():{
                  Toaster.showSuccess(state.success);
                  context.pop();
                }
                break;
                default:
                  break;
              }
            }
          },
            child: const PersonAddEditFormField()));
  }
}
