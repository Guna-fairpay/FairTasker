
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bill_list_item.dart';

class BillListingPage extends StatelessWidget {
  const BillListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
        builder: (context,state) {
          return Column(
            spacing: 10,
            children: [
              Row(
                spacing: 20.spMin,
                children: [
                  Expanded(
                    flex: 2,
                    child: DateRangePicker(
                      selectedDateRange: context
                          .watch<BillBloc>()
                          .selectedDateRange,
                      onDateRangeSelected: (range) {
                        context.read<BillBloc>().add(DateRangeEvent(range));
                      },
                    ),
                  ),
                  const Spacer(flex: 1,)
                ],
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: IntrinsicColumnWidth(),
                  2: FlexColumnWidth(5),
                  3: IntrinsicColumnWidth(),
                  4: IntrinsicColumnWidth(),
                  5: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border:  const TableBorder(
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
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: const SizedBox.shrink()),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: Align( alignment: Alignment.center, child: Icon(Icons.calendar_month_rounded,size: 16.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: Text("Title",
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.spMin))),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: Icon(Icons.image_outlined,size: 16.spMin,)),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: Icon(Icons.person_2_rounded,size: 16.spMin,)),
                        Padding(
                            padding: 5.spMin.padding.copyWith(left: 10.spMin, right: 10.spMin),
                            child: Text("#",style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.spMin))),

                      ]),
                  ...context
                      .watch<BillBloc>()
                      .apiResponse
                      .map((e) => BillListItem(
                      model: e,
                      onViewAttachment:()=> ShowAttachmentsDialog.of.show(context,
                          attachments: e['billimages'].map((e) => e['path'].toString().toAttachmentURL).toList(),
                          title: e['title']),
                      isCheck: context.read<BillBloc>().isCheck,
                      onEdit: ()=> context
                          .read<BillBloc>()
                          .add(LoadEditValueEvent(value: e)),
                      onPass:()=> context.read<BillBloc>().add(PassBillToExpenseEvent(value: e)),
                      onDelete: () {
                        AskPermissionDialog.show(context,
                            title: "Are you sure?",
                            description: "Do you want to delete this Bill?",
                            positiveText: "Yes, delete it!",
                            negativeText: "Cancel",
                            isReasonRequired: false,
                            onPositivePressed:()=> context
                                .read<BillBloc>()
                                .add(DeleteBillEvent(value:e)),
                        );},
                  )).toList()
                ],
              ),
            ],
          );
        }
    );
  }
}
