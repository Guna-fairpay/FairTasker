
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/dialog/task_cohort_filter/bloc/task_cohort_filter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class  TaskCohortFilterMainPage {
  TaskCohortFilterMainPage._();
  static void show(
      BuildContext context, {
        List<dynamic>? cohortIdList,
        Function(List<dynamic>)? onChanged,
      }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _CohortFilterPopView(
        cohortIdList: cohortIdList,
        onChanged: onChanged,
      ),
    );
  }
  }

class _CohortFilterPopView extends StatelessWidget {
  final List<dynamic>? cohortIdList;
  final Function(List<dynamic>)? onChanged;
  const _CohortFilterPopView({
    Key? key,
    this.onChanged,
    this.cohortIdList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCohortFilterBloc()
        ..add(TaskCohortFilterInitialEvent(cohortIdList: cohortIdList)),
      child: BlocListener<TaskCohortFilterBloc, TaskCohortFilterState>(
        listener: (context, state) {
          if (state is TaskCohortFilterLoadingState){ EasyLoading.show();
          }else{
            EasyLoading.dismiss();
            if (state is EmitValueState) onChanged?.call(state.value);
          }
        },
        child: BlocBuilder<TaskCohortFilterBloc, TaskCohortFilterState>(
            builder: (context, state) {
              return AlertDialog(
                  alignment: Alignment.center,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
                  backgroundColor: AppC.white,
                  insetPadding: 10.sp.padding,
                  titlePadding: EdgeInsets.zero,
                  contentPadding: 5.sp.padding.copyWith(left: 15.sp, right: 20.sp, bottom: 15.sp),
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: ()=>context.pop(), icon: const Icon(Icons.close_rounded, color: AppC.redAccent,)),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckboxListTile(title: Utils.getText(
                            'All',
                            weight: FontWeight.bold,
                            size: 13.sp),
                          value: context.watch<TaskCohortFilterBloc>().allSelected,
                          onChanged: (value) => context.read<TaskCohortFilterBloc>().add(TaskCohortFilterSelectAllEvent()),isCheckboxOnRight: true,),
                        Divider(color: AppC.borderColor,height: 1, thickness: 1.sp),
                        ListView.builder(
                          itemCount: context.watch<TaskCohortFilterBloc>().cohortList?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                            var model = context.watch<TaskCohortFilterBloc>().cohortList?[index];
                            return CustomCheckboxListTile(
                                title: Utils.getText(model['cohort'], weight: FontWeight.bold, size: 13.sp),
                                value: (context.watch<TaskCohortFilterBloc>().cohortIdList?.contains(model?['id']) ?? false),
                                onChanged: (value) => context.read<TaskCohortFilterBloc>().add(TaskCohortFilterSingleSelectionEvent(selectedCohort: model)));
                          }
                        )
                      ],
                    ),
                  ));
            }
          ),
        ),
    );
  }
}

