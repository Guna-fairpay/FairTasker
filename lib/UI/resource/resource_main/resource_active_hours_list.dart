import 'package:fairpytasker/UI/resource/resource_main/component/resource_emp_working_hour_table_row.dart';
import 'package:fairpytasker/UI/resource/resource_main/bloc/resource_check_in_out_bloc.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ResourceActiveHoursList extends StatelessWidget {
  const ResourceActiveHoursList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCheckInOutBloc, ResourceCheckInOutState>(builder: (context, state) => Table(
      border: const TableBorder(horizontalInside: BorderSide(width: Num.borderWidthThinField, color: AppC.fieldBase)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1),
      },
      children: [
        const TableHeaderRow(labels: ["Employee", "Active", "Hours", "Task", "#"], textAlign: TextAlign.center, firstTextAlign: TextAlign.start),
        ...(context.watch<ResourceCheckInOutBloc>().employeeWorkHours?.map((e) => EmployeeWorkingRow(model: e, textAlign: TextAlign.center, onHours: () => context.read<ResourceCheckInOutBloc>().add(ViewHoursDetailsEvent(e)))).toList() ?? [])
      ],
    ));
  }
}
