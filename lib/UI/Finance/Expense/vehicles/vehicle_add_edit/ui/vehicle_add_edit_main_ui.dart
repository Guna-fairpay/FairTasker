import 'package:fairpytasker/Component/choice_box_widget.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/icon_with_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_add_edit/bloc/vehicle_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'vehicle_add_edit_listing_ui.dart';
part 'vehicle_add_edit_form_field_ui.dart';
part 'vehicle_split_expense_ui.dart';
part 'vehicle_todo_details_ui.dart';
part 'todo_task_view_ui.dart';

class VehicleAddEditMainUI extends StatelessWidget {
  final dynamic editModel;
  final dynamic addModel;
  const VehicleAddEditMainUI({super.key, this.editModel, this.addModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => VehicleAddEditBloc()..add(InitialEvent(editModel: editModel, addModel: addModel,)),
      child: BlocListener<VehicleAddEditBloc, VehicleAddEditState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else{
            if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case TodoTaskViewSate(): context.push(TodoTaskViewUI(todoDetails: state.model,)); break;
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState():{
                Toaster.showSuccess(state.message);
                context.pop();
              } break;
              default: break;
            }
          }
        },
        child: const VehicleAddEditListingUI(),
      ),
    );
  }
}
