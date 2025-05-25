import 'package:fairpytasker/UI/dialog/resource_check_in_out/check_in_out_hours_details/check_in_out_hours_details_dialog.dart';
import 'package:fairpytasker/UI/dialog/resource_check_in_out/task_count_details/task_count_details_dialog.dart';
import 'package:fairpytasker/UI/resource/resource_main/bloc/resource_check_in_out_bloc.dart';
import 'package:fairpytasker/UI/resource/resource_main/resource_active_hours_list.dart';
import 'package:fairpytasker/UI/resource/resource_main/resource_history_date_picker.dart';
import 'package:fairpytasker/UI/resource/resource_main/resource_work_hours_list.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class ResourceCheckInOutUi extends StatelessWidget {
  const ResourceCheckInOutUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Check In/Out"),
        automaticallyImplyLeading: false,
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocProvider(create: (context) => ResourceCheckInOutBloc()..add(InitialEvent()),
        child: BlocListener<ResourceCheckInOutBloc, ResourceCheckInOutState>(listener: (context, state) {
          if (state is LoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState(): Toaster.showSuccess(state.message); break;
              case ViewHoursDetailsState(): CheckInHoursDialog.show(context, model: state.model, dateRange: state.dateRange); break;
              case TaskComponentState(): /*INSERT YOUR PAGE*/ break;
              case ViewTaskDetailsState(): /*INSERT YOUR PAGE*/ break;
              case ViewTaskCountState(): TaskCountDetailsDialog.show(context, model: state.model, dateRange: state.dateRange); break;
            }
          }
        },
        child: ListView(
            padding: 10.sp.padding,
            children: const [
              ResourceWorkHoursList(),
              ResourceHistoryDatePicker(),
              ResourceActiveHoursList(),
            ]),),
      ),
    );
  }
}
