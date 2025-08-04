import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/resource/resource_main/bloc/resource_check_in_out_bloc.dart';
import 'package:fairpytasker/UI/resource/resource_main/component/resource_working_hour_table_row.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResourceWorkHoursList extends StatelessWidget {
  const ResourceWorkHoursList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCheckInOutBloc, ResourceCheckInOutState>(builder: (context, state) => Table(
      border: const TableBorder(horizontalInside: BorderSide(width: Num.borderWidthThinField, color: AppC.fieldBase)),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableHeaderRow(labels: ["User", "CheckIn", "CheckOut", "Active", "Total"], textAlign: TextAlign.center),
        ...(context.watch<ResourceCheckInOutBloc>().workingHours?.map((e) => WorkingHourRow(model: e, textAlign: TextAlign.center)).toList() ?? [])
      ],
    ));
  }
}
