
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_bloc.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_event.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_state.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/ui/invoice_table.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class InvoiceDialog {
  InvoiceDialog._();

  static void show(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<TodoEditExpenseBloc>(context),
          child: const _InvoiceDialog())
    );
  }
}

class _InvoiceDialog extends StatelessWidget {
  const _InvoiceDialog();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
        builder: (context,state) {
          var invoiceData = context.read<TodoEditExpenseBloc>().invoiceData;
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Dialog(
                backgroundColor: AppC.white,
                insetPadding: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Utils.getText('Invoice Preview', weight: FontWeight.w900,size: 15.sp),
                          const Spacer(),
                          InkWell(
                            onTap: () => context.pop(),
                            child: const Icon(Icons.close_outlined,color: AppC.grey,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppC.grey,width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 18.sp,
                                    children: [
                                      Utils.getText(invoiceData?['title']??'', weight: FontWeight.w900,size: 16.sp),
                                      Utils.getText(invoiceData?['address']??'',),
                                      Utils.getText('Phone: ${invoiceData?['phone']??''}'),
                                      Utils.getText('TO', weight: FontWeight.w900,size: 16.sp),
                                      Utils.getText(
                                        'Hasanath Mohammed,\n'
                                            'FairPY INC,\n'
                                            '4443 Zahir Ct,\n'
                                            'Irving TX, 75061',
                                      ),
                                      Utils.getText('Phone: 5025921994'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    spacing: 18.sp,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.getText('Invoice', weight: FontWeight.w900,size: 16.sp),
                                      Utils.getText('INVOICE ${invoiceData?['invoiceId']}'),
                                      Utils.getText('DATE : ${invoiceData?['date']}'),
                                      Utils.getText('CAR PLATE : ${invoiceData?['plateNo']??''}'),
                                      Utils.getText('CAR NAME : ${invoiceData?['vehicleName']??''}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Table(
                              columnWidths: const {
                                0: IntrinsicColumnWidth(),
                                1: FlexColumnWidth(3),
                                2: IntrinsicColumnWidth(),
                                3: FlexColumnWidth(2),
                                4: FlexColumnWidth(2),
                              },
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              border:   const TableBorder(
                                  horizontalInside: BorderSide(
                                      color: AppC.borderColor,
                                      width: Num.borderWidthThinField)),
                              children: [
                                TableRow(
                                    children: [
                                      Padding(
                                          padding: 5.sp.padding.copyWith(left: 0.sp, right: 10.sp),
                                          child: Text("S.NO",
                                              style: context.textTheme.labelLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp))),
                                      Padding(
                                          padding: 5.sp.padding.copyWith(left: 5.sp, right: 10.sp),
                                          child: Text("Description",
                                              style: context.textTheme.labelLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp))),
                                      Padding(
                                          padding: 5.sp.padding.copyWith(left: 5.sp, right: 10.sp),
                                          child: Text("Qty",
                                              style: context.textTheme.labelLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp))),
                                      Padding(
                                          padding: 5.sp.padding.copyWith(left: 5.sp, right: 10.sp),
                                          child: Text("Rate",
                                              style: context.textTheme.labelLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp))),
                                      Padding(
                                          padding: 5.sp.padding.copyWith(left: 5.sp, right: 10.sp),
                                          child: Text("Total",
                                              style: context.textTheme.labelLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp))),
                                    ]),
                                ...List.from(invoiceData?['itemList'] ??[])
                                    .map((e) => InvoiceTable(
                                  model: e,
                                  index: List.from(invoiceData?['itemList'] ?? []).indexOf(e),
                                )).toList()
                              ],
                            ),
                            Row(
                              children: [
                                Utils.getText('Sub Total : ', weight: FontWeight.w900),
                                Utils.getText("\$ ${((invoiceData?['sub_total'].toString())?.isEmpty??false) ? '0.00' : invoiceData?['sub_total']}"),
                              ],
                            ),
                            Row(
                              children: [
                                Utils.getText('Sales Tax : ', weight: FontWeight.w900),
                                Utils.getText("\$ ${((invoiceData?['tax'].toString())?.isEmpty??false) ? '0.00' : invoiceData?['tax']}"),
                              ],
                            ),
                            Row(
                              children: [
                                Utils.getText('Shipping  & Handling : ', weight: FontWeight.w900),
                                Utils.getText("\$ ${((invoiceData?['shipping'].toString())?.isEmpty??false) ? '0.00' : invoiceData?['shipping']}"),
                              ],
                            ),
                            Row(
                              children: [
                                Utils.getText('Total Amount : ', weight: FontWeight.w900),
                                Utils.getText("\$ ${((invoiceData?['total'].toString())?.isEmpty??false) ? '0.00' : invoiceData?['total']}"),
                              ],
                            ),
                            Utils.getText('NOTES', weight: FontWeight.bold,color: AppC.grey),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.shade100),
                                borderRadius: BorderRadius.circular(4),
                                color: AppC.blue50
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Utils.getText('Make all checks payable to '
                                  'If you have any questions concerning this invoice, contact', /*${invoiceData?['title']??''}*/
                              color: AppC.blue),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Utils.getElevatedButton(() => context.read<TodoEditExpenseBloc>().add(GenerateInvoiceEvent()),text: 'Generate Invoice',icon: Icons.print_outlined),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
