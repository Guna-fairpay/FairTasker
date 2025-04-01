import 'package:fairpytasker/Component/header.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/attendance_table_values.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/dialogs/attendance_individual_report_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              contentPadding: EdgeInsets.zero,
              title: Utils.getText('Attendance',
                  size: 20, weight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border:
                    TableBorder.all(borderRadius: BorderRadius.circular(10), width: 0.5, color: Theme.of(context).hintColor),
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          color: AppC.grey.withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Name",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontFamily: "Lato"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Daily\n(Idle Hours)",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontFamily: "Lato"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Weekly\n(Idle Hours)",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontFamily: "Lato"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                  AttendanceTableValues(context, name: "Hidayath Suleiman", daily: null, weekly: null),
                  AttendanceTableValues(context, name: "Abdhullah Khan", daily: null, weekly: null),
                  AttendanceTableValues(context, name: "Mudassir Iqbal", daily: "00:00", weekly: "33:18", onTap: (val) => AttendanceIndividualReport.dialog.show(context, isDaily: val),),

                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
