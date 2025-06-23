import 'package:fairpytasker/UI/Vehicle/vehicle_history_detail/vehicle_history_details_ui.dart';
import 'package:fairpytasker/UI/dialog/task_cohort_filter/ui/task_cohort_filter_main_page.dart';
import 'package:fairpytasker/UI/dialog/task_hour_summery_dialog/ui/task_hour_summery_main.dart';
import 'package:fairpytasker/UI/resource/task_details/task_details_count_ui.dart';
import 'package:fairpytasker/UI/resource/task_details/task_details_filter_ui.dart';
import 'package:fairpytasker/UI/resource/task_details/task_details_list_ui.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:fairpytasker/UI/resource/task_details/bloc/task_details_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TaskDetailsUi extends StatelessWidget {
  final Map<String, dynamic>? model;
  final DateRange? dateRange;
  const TaskDetailsUi({super.key, required this.model, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TaskDetailsBloc()..add(InitialEvent(model: model, dateRange: dateRange)),
        child: BlocListener<TaskDetailsBloc, TaskDetailsState>(
            listener: (context, state) {
              if (state is LoadingState) {
                if (!EasyLoading.isShow) EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch(state) {
                  case ErrorState(): Toaster.showError(state.message); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  case ViewFilterState(): TaskCohortFilterMainPage.show(context, cohortIdList: state.model, onChanged: (value) => context.read<TaskDetailsBloc>().add(FilterCohortEvent(model: value))); break;
                  case ViewAmountSummaryState(): TaskHourSummeryMain.show(context, hourSummeryData: state.model, name: state.name); break;
                  case ViewTaskDetailsState(): VehicleHistoryDetailsUiDialog.show(context, mapData: state.model, showAsDialog: false); break;
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(model?['name'] ?? ""),
                automaticallyImplyLeading: false,
                backgroundColor: AppC.appColor,
                foregroundColor: AppC.white,
                actions: [
                  const TaskDetailsCountUi(),
                  IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              body: Column(
                spacing: 10.sp,
                children: const [
                  TaskDetailsFilterUi(),
                  TaskDetailsListUi()
                ],
              ),
            )));
  }
}
