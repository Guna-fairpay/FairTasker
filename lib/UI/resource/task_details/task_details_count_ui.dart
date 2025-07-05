import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/resource/task_details/bloc/task_details_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailsCountUi extends StatelessWidget {
  const TaskDetailsCountUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(builder: (context, state) => Row(
      spacing: 10.spMin,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.spMin),
              border: Border.all(color: Colors.white)
          ),
          padding: 10.spMin.horizontalPadding,
          child: CompactText("${context.watch<TaskDetailsBloc>().configs?.map((e) => e['task_count'].toString().toNumeric).sum ?? 0}", styleType: TextStyleType.titleMedium, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        if (getIt<CommonService>().isHasnath)
        GestureDetector(
          onTap: () => context.read<TaskDetailsBloc>().add(ViewAmountSummaryEvent()),
          child: CompactText("\$${(context.watch<TaskDetailsBloc>().configs?.where((element) => !element['task_name'].toString().toLowerCase().contains("other")).map((e) => e['total'].toString().toNumeric).sum ?? 0) + (context.watch<TaskDetailsBloc>().configs?.where((element) => element['task_name'].toString().toLowerCase().contains("other")).map((e) => e['hour_amount'].toString().toNumeric).sum ?? 0)}", styleType: TextStyleType.titleMedium, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    ));
  }
}
