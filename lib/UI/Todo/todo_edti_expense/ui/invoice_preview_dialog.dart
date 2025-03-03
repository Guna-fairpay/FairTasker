
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../bloc/todo_edit_expense_bloc.dart';

class InvoiceDialog extends StatelessWidget {
  final TodoEditExpenseBloc bloc;
  const InvoiceDialog({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppC.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: ListView(
          children: [
            Row(
              children: [
                Utils.getText('Invoice Preview', weight: FontWeight.bold),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppC.grey),
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
                          spacing: 10,
                          children: [
                            Utils.getText('TITLE', weight: FontWeight.w900),
                            Utils.getText(
                              'Super 8 by Wyndham Irving DFW Airport/South 4245 West Airport Freeway,'
                              ' Irving, Texas 75062',
                            ),
                            Utils.getText('Phone: 9544326351'),
                            Utils.getText('TO', weight: FontWeight.w900),
                            Utils.getText(
                              'Super 8 by Wyndham Irving DFW Airport/South 4245 West Airport Freeway, Irving, Texas 75062',
                            ),
                            Utils.getText('Phone: 9544326351'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.getText('Invoice', weight: FontWeight.w900),
                            Utils.getText('INVOICE INV35454'),
                            Utils.getText('DATE:'),
                            Utils.getText('CAR PLATE:'),
                            Utils.getText('CAR NAME:'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Utils.getText('S.NO', weight: FontWeight.w900),
                          Utils.getText('1'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Utils.getText('Description', weight: FontWeight.w900),
                          Utils.getText(bloc.invoiceData?['description']),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Utils.getText('Qty', weight: FontWeight.w900),
                          Utils.getText('1'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Utils.getText('Rate', weight: FontWeight.w900),
                          Utils.getText('\$${((bloc.invoiceData?['part_name'].toString())?.isEmpty ?? false) ? '0.00' : bloc.invoiceData?['part_name']}'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Utils.getText('Total', weight: FontWeight.w900),
                          Utils.getText("\$${bloc.invoiceData?['total']}"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Sub Total : ', weight: FontWeight.w900),
                      Utils.getText("\$${bloc.invoiceData?['sub_total']??''}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Sales Tax : ', weight: FontWeight.w900),
                      Utils.getText("\$${bloc.invoiceData?['tax']??''}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Shipping  & Handling : ', weight: FontWeight.w900),
                      Utils.getText("\$${((bloc.invoiceData?['shipping'].toString())?.isEmpty??false) ? '0.00' : bloc.invoiceData?['shipping']}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Total Amount : ', weight: FontWeight.w900),
                      Utils.getText("\$${bloc.invoiceData?['total']??''}"),
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
                        'If you have any questions concerning this invoice, contact ',
                    color: AppC.blue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Utils.getElevatedButton((){},text: 'Generate Invoice',icon: Icons.print),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
