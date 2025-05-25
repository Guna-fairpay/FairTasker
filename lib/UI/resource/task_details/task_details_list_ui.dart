import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/resource/task_details/bloc/task_details_bloc.dart';
import 'package:fairpytasker/UI/resource/task_details/component/task_expansion_tile.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailsListUi extends StatelessWidget {
  const TaskDetailsListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(builder: (context, state) => Expanded(child: ListView.separated(
          shrinkWrap: true,
          padding: 16.sp.horizontalPadding.copyWith(bottom: 20.sp),
          itemCount: context.watch<TaskDetailsBloc>().tasks?.length ?? 0,
          separatorBuilder: (context, index) => 10.sp.height,
          itemBuilder: (context, index) => TaskExpansionTile(styleType: TextStyleType.labelLarge, model: (context.read<TaskDetailsBloc>().tasks?[index]), onTap: (value) => context.read<TaskDetailsBloc>().add(ViewTaskDetailsEvent(model: value)))),
    ));
  }
}
