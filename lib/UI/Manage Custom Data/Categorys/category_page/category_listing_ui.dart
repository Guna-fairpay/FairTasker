import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/component/category_list_item.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryListingUi extends StatelessWidget {
  const CategoryListingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) => Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(5),
                    1: FlexColumnWidth(2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: const TableBorder(
                      horizontalInside: BorderSide(
                          color: AppC.borderColor,
                          width: Num.borderWidthThinField)),
                  children: [
                    TableRow(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(Num.borderRadius)),
                            color: AppC.appbgColor),
                        children: [
                          Padding(
                              padding: 5.sp.padding.copyWith(left: 10.sp, right: 10.sp),
                              child: Text("Category",
                                  style: context.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp))),
                          Padding(
                              padding: 5.sp.padding.copyWith(left: 10.sp, right: 10.sp),
                              child: Text("Actions",
                                  style: context.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp))),
                        ]),
                    ...context
                        .watch<CategoryBloc>()
                        .filteredResponse
                        .map((e) => CategoryListItem(
                            model: e,
                            onEdit: () => context
                                .read<CategoryBloc>()
                                .add(CategoryEditEvent(e)),
                            onDelete: () => context
                                .read<CategoryBloc>()
                                .add(CategoryDeleteTapEvent(e))))
                        .toList()
                  ],
                ),
                CompactPagination(
                    totalPages: context.watch<CategoryBloc>().totalPages,
                    currentPage: context.watch<CategoryBloc>().currentPage,
                    onPageChanged: (value) => context
                        .read<CategoryBloc>()
                        .add(CategoryPaginationEvent(value)))
              ],
            ));
  }
}
