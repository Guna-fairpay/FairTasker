import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:flutter/material.dart';

class ResourceActiveHoursList extends StatelessWidget {
  const ResourceActiveHoursList({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1),
      },
      children: [
        const TableHeaderRow(labels: ["Employee", "Active", "Hours", "Task", "#"]),
      ],
    );
  }
}
