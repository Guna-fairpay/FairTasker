import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Dialog/expense_summery/ui/expense_summery_main_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_add_edit/ui/vehicle_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/bloc/vehicle_view_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/category_change_dialog/ui/category_dialog.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/cohort_change_dialog/ui/cohort_change_dialog.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/dummy_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'vehicle_list_item.dart';
part 'vehicle_list_body.dart';

class VehicleViewMainUI extends StatelessWidget {
  const VehicleViewMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleExpenseViewBloc()..add(InitialEvent()),
        child: BlocListener<VehicleExpenseViewBloc, VehicleExpenseViewState>(
          listener: (context, state) {
            if(state is LoadingState){
              if(!EasyLoading.isShow) EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ShowCohortState():  CohortChangeDialog.show(context, cohort: state.data,); break;
                case ShowCategoryState(): CategoryDialog.show(context, expenseData: state.data,); break;
                default: break;
              }
            }
          },
            child: const VehicleListBody(),
        ));
  }
}
