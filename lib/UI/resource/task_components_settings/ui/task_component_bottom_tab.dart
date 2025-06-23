import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_bloc.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_event.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_state.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/ui/hourly_based_table.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/ui/task_based_table.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskComponentBottomTab extends StatelessWidget {
  const TaskComponentBottomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskComponentBloc, TaskComponentState>(
      builder: (context, state) =>
          Column(
            children: [
              Container(
                decoration:  const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: Num.borderWidthThinField)
                    ),
                ),
                child:  Row(
                  children: [
                    CustomTabButton(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppC.appColor),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                      ),
                        buttonText: 'Task based',
                        value: 0,
                        selectedValue: context.watch<TaskComponentBloc>().selectedTab,
                        onPressed:(val)=> context.read<TaskComponentBloc>().add(TaskComponentTabBarEvent(tabIndex: val))
                    ),
                    CustomTabButton(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppC.appColor),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Num.borderRadius), topRight: Radius.circular(Num.borderRadius)),
                        ),
                        buttonText: 'Hourly based',
                        value: 1,
                        selectedValue: context.watch<TaskComponentBloc>().selectedTab,
                        onPressed:(val)=> context.read<TaskComponentBloc>().add(TaskComponentTabBarEvent(tabIndex: val))
                    ),
                  ],
                ),
              ),
              10.sp.height,
              if(context.read<TaskComponentBloc>().selectedTab == 0)
                const TaskBasedTable(),
              if(context.read<TaskComponentBloc>().selectedTab == 1)
                const HourlyBasedTable(),
            ],
          ),
    );
  }
}
