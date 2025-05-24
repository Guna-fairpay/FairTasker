import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:flutter/material.dart';

class ResourceWorkHoursList extends StatelessWidget {
  const ResourceWorkHoursList({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
      },
      children: [
        const TableHeaderRow(labels: ["User", "CheckIn", "CheckOut", "Active", "Total"]),
      ],
    );
  }
}
