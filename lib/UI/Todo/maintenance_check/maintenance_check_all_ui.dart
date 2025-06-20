import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_bloc.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_events.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_states.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckAllUi extends StatelessWidget {
  const MaintenanceCheckAllUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceCheckBloc, MaintenanceCheckState>(
      builder: (context, state) => Column(
        spacing: 10.sp,
        children: [
          const SizedBox.shrink(),
          CustomCheckboxListTile(
            activeColor: Colors.grey,
            title: Text("Is all maintenance check done", style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500)),
            mainAxisSize: MainAxisSize.min,
            padding: EdgeInsets.zero,
            spacing: 5.sp,
            value: context.watch<MaintenanceCheckBloc>().isMandatory,
            onChanged: (value) => context.read<MaintenanceCheckBloc>().add(MaintenanceCheckAllCheckEvent(value)),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
