import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/subcategory_list_item.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryListingUi extends StatelessWidget {
  const SubcategoryListingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryBloc, SubCategoryState>(
        builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
                  border: const TableBorder(
                      horizontalInside: BorderSide(
                          color: AppC.borderColor,
                          width: Num.borderWidthThinField)),
                  children: [
                    TableRow(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(Num.borderRadiusLarge)),
                            color: Color(0xFFf0f0f0)),
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "Sub Category",
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "Category",
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "Action",
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ))),
                        ]),
                    ...context
                        .watch<SubCategoryBloc>()
                        .filteredResponse
                        .map((e) => SubCategoryListItem(
                            model: e,
                            onEdit: () => context
                                .read<SubCategoryBloc>()
                                .add(SubCategoryEditEvent(e)),
                            onDelete: () => context
                                .read<SubCategoryBloc>()
                                .add(SubCategoryDeleteTapEvent(e))))
                        .toList(),
                  ],
                ),
                CompactPagination(
                    totalPages: context.watch<SubCategoryBloc>().totalPages,
                    currentPage: context.watch<SubCategoryBloc>().currentPage,
                    onPageChanged: (value) => context
                        .read<SubCategoryBloc>()
                        .add(SubCategoryPageEvent(value)))
              ],
            ));
  }
}
