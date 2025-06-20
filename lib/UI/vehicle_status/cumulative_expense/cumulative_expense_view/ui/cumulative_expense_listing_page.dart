
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/ui/cumulative_expense_add_main_page.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_event.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_state.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/ui/cumulative_expense_table_view.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class CumulativeExpenseListingPage extends StatelessWidget {
  const CumulativeExpenseListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CumulativeExpenseBloc, CumulativeExpenseState>(
      builder: (context,state) {
        return SafeArea(
          minimum: 10.padding,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.centerRight,
                  child: SuccessButton(
                    text: 'Add Expense',
                    foregroundColor:AppC.green,
                    isOutline: true,
                    backgroundColor: AppC.white,
                    onPressed:()=> context.push(CumulativeExpenseAddMainPage(model:context.read<CumulativeExpenseBloc>().data,)),),
              ),
              10.sp.height,
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(5),
                  2: IntrinsicColumnWidth(),
                  3: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border:   const TableBorder(
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
                            child: Text("Date",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp))),
                        Padding(
                            padding: 5.sp.padding.copyWith(left: 10.sp, right: 10.sp),
                            child: Text("Category",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp))),
                        Padding(
                            padding: 5.sp.padding.copyWith(left: 10.sp, right: 10.sp),
                            child: Text("Amount",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp))),
                        Padding(
                            padding: 5.sp.padding.copyWith(left: 10.sp, right: 10.sp),
                            child: Text("#",style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppC.trans,
                                fontSize: 12.sp))),

                      ]),
                  ...context
                      .watch<CumulativeExpenseBloc>()
                      .filteredResponse
                      .map((e) => CumulativeExpenseTableView(context,
                    model: e,
                    onDelete: () {
                      AskPermissionDialog.show(context,
                        title: "Are you sure?",
                        description: "Do you want to delete this Expense?",
                        positiveText: "Yes, delete it!",
                        negativeText: "Cancel",
                        isReasonRequired: false,
                        onPositivePressed:()=> context
                            .read<CumulativeExpenseBloc>()
                            .add(CumulativeExpenseDeleteEvent(data:e)),
                      );},
                  )).toList()
                ],
              ),
              const Divider(height: 0.5,thickness: 0.1,),
              Align(
                  alignment: Alignment.centerRight,
                  child: Utils.getText('Total : \$${context.watch<CumulativeExpenseBloc>().total?.toStringAsFixed(2) ?? ''}',color: const Color(0xff495057),weight: FontWeight.bold)),
              CompactPagination(
                currentPage: context.watch<CumulativeExpenseBloc>().currentIndex,
                totalPages: (context.watch<CumulativeExpenseBloc>().totalCount /
                    context.watch<CumulativeExpenseBloc>().itemsPerPage)
                    .ceil(),
                onPageChanged: (value) => context
                    .read<CumulativeExpenseBloc>()
                    .add(CumulativeExpensePaginationEvent(page: value)),
              ),
            ],
          ),
        );
      }
    );
  }
}
