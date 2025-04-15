import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/attendance_table_values.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/dialogs/attendance_individual_report_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBodyView extends StatelessWidget {
  const AttendanceBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) => Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
            borderRadius: BorderRadius.circular(Num.borderRadius),
            width: Num.borderWidthThinField,
            color: AppC.borderColor),
        children: [
          TableRow(
              decoration: BoxDecoration(
                  color: AppC.grey.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Num.borderRadius))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Name",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Lato"),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Daily\n(Idle Hours)",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Lato"),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Weekly\n(Idle Hours)",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Lato"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
          ...context.watch<AttendanceBloc>().resources?.map((e) => AttendanceTableValues(context,
              name: "${e['first_name'] ?? ""} ${e['last_name'] ?? ""}", daily: e['daily']?['totalHours'].toString(), weekly: e['weekly_hours'].toString())).toList() ?? [],
        ],
      ),
    );
  }
}
