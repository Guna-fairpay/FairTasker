import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/log/bloc/log_bloc.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/UI/log/component/log_table_row.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogsTable extends StatelessWidget {
  const LogsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) => SafeArea(
        minimum: 10.sp.padding,
        child: Column(
          children: [
            if (context.watch<LogBloc>().filteredResponse.isNotEmpty)
              Expanded(
                  child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(1),
                },
                    border: const TableBorder(
                      horizontalInside: BorderSide(width: Num.borderWidthThinField, color: AppC.borderColor)
                    ),
                children: [
                  const TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: Text("Title"),
                        )),
                        TableCell(child: Icon(Icons.image_outlined)),
                        TableCell(child: Icon(Icons.perm_identity_outlined)),
                        TableCell(child: SizedBox.shrink()),
                        TableCell(child: SizedBox.shrink()),
                      ],
                      decoration: BoxDecoration(
                          color: Color(0xffbdc9e8),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Num.borderRadius)))),
                  ...context
                      .watch<LogBloc>()
                      .filteredResponse
                      .map((e) => LogTableRow(
                          model: e,
                          onEdit: () => Console.of.log("Edit"),
                          onAttachment: () => Console.of.log("Attachment"),
                          onDelete: () => Console.of.log("Delete")))
                      .toList()
                ],
              ))
            else
              EmptyWidget(
                  withExpand: true,
                  onRefresh: () =>
                      context.read<LogBloc>().add(LogRefreshEvent())),
            CompactPagination(
              totalPages: context.watch<LogBloc>().totalPage,
              currentPage: context.watch<LogBloc>().currentPage,
              onPageChanged: (value) =>
                  context.read<LogBloc>().add(LogPaginationEvent(value)),
            )
          ],
        ),
      ),
    );
  }
}
