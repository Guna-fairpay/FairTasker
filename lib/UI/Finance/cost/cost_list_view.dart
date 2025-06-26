import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Finance/cost/bloc/cost_bloc.dart';
import 'package:fairpytasker/UI/Finance/cost/component/cost_table_row.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CostListView extends StatelessWidget {
  final dynamic model;
  const CostListView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CostBloc()..add(InitialEvent(model)),
      child: BlocConsumer<CostBloc, CostState>(
        listener: (context, state) {},
        builder: (context, state) => Skeletonizer(
            enabled: (state is LoadingState),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.spMin,
            children: [
              RowTile(
                expandTitle: true,
                title: CompactText("Total: \$${context.watch<CostBloc>().totalAmount}", textAlign: TextAlign.end, fontWeight: FontWeight.w900, color: AppC.lightDark, styleType: TextStyleType.titleMedium),
              ),
              Expanded(child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0 : IntrinsicColumnWidth(),
                  1 : FlexColumnWidth(2),
                  2: IntrinsicColumnWidth(),
                },
                border: const TableBorder(horizontalInside: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton)),
                children: [
                  TableHeaderRow(labels: const ["Date", "Category", "Amount"], backgroundColor: AppC.appbgColor, borderRadius: BorderRadius.vertical(top: Radius.circular(5.sp)), padding: 7.spMin.padding),
                  ...List.generate((state is LoadingState) ? 10 : 0, (index) => <String, dynamic>{}).map((e) => CostTableRow(context, e)).toList() ?? [],
                  ...context.watch<CostBloc>().filteredData?.map((e) => CostTableRow(context, e)).toList() ?? [],
                ],
              )),
              CompactPagination(totalPages: context.watch<CostBloc>().totalPages, currentPage: context.watch<CostBloc>().currentPage, onPageChanged: (value) => context.read<CostBloc>().add(PaginationEvent(value))),
            ],
          )
        ),
      ),
    );
  }
}
