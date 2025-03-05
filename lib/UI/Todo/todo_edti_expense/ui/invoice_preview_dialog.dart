
import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class InvoiceDialog {
  InvoiceDialog._();

  static void show(BuildContext context,
      {Map<String, dynamic>? invoiceData, required VoidCallback onGenerate}) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => _InvoiceDialog(invoiceData: invoiceData, onGenerate: onGenerate)
    );
  }
}

class _InvoiceDialog extends StatelessWidget {
  final Map<String, dynamic>? invoiceData;
  final VoidCallback onGenerate;
  const _InvoiceDialog({required this.invoiceData, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    log("Invoice Data : ${jsonEncode(invoiceData)}", name: "InvoiceDialog");
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
                            Utils.getText(invoiceData?['title']??'', weight: FontWeight.w900),
                            Utils.getText(invoiceData?['address']??'',),
                            Utils.getText('Phone: ${invoiceData?['phone']??''}'),
                            Utils.getText('TO', weight: FontWeight.w900),
                            Utils.getText(
                              'Hasanath Mohammed,\n'
                                  'FairPY INC,\n'
                                  '4443 Zahir Ct,\n'
                                  'Irving TX, 75061\n',
                            ),
                            Utils.getText('Phone: 5025921994'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.getText('Invoice', weight: FontWeight.w900),
                            Utils.getText('INVOICE ${invoiceData?['invoiceId']}'),
                            Utils.getText('DATE : ${invoiceData?['date']}'),
                            Utils.getText('CAR PLATE : ${invoiceData?['plateNo']??''}'),
                            Utils.getText('CAR NAME : ${invoiceData?['vehicleName']??''}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: Utils.getText('S.NO', weight: FontWeight.w900)
                      ),

                      Expanded(
                          flex: 2,
                          child: Utils.getText('Description', weight: FontWeight.w900)),
                      10.width,
                      Expanded(child: Utils.getText('Qty', weight: FontWeight.w900)),
                      10.width,
                      Expanded(
                          flex: 1,
                          child: Utils.getText('Rate', weight: FontWeight.w900)),
                      10.width,
                      Expanded(
                          child: Utils.getText('Total', weight: FontWeight.w900)),
                    ],
                  ),
                  Divider(height: 0.5,color: Colors.grey.shade300,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invoiceData?['itemList']?.length ?? 0,
                  itemBuilder: (context, index) {
                    var item = invoiceData?['itemList'][index];
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Utils.getText('${index + 1}', weight: FontWeight.w900)),
                            Expanded(
                                flex: 2,
                                child: Utils.getText(item?['name'] ?? '')),
                            Expanded(
                                flex: 1,
                                child: Utils.getText('1', weight: FontWeight.w900)),
                            Expanded(
                                flex: 1,
                                child: Utils.getText('\$${item?['rate'] ?? '0.00'}', weight: FontWeight.w900)),
                            Expanded(
                                child: Utils.getText('\$${item?['rate'] ?? '0.00'}', weight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                  Row(
                    children: [
                      Utils.getText('Sub Total : ', weight: FontWeight.w900),
                      Utils.getText("\$${invoiceData?['sub_total']??''}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Sales Tax : ', weight: FontWeight.w900),
                      Utils.getText("\$${invoiceData?['tax']??''}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Shipping  & Handling : ', weight: FontWeight.w900),
                      Utils.getText("\$${((invoiceData?['shipping'].toString())?.isEmpty??false) ? '0.00' : invoiceData?['shipping']}"),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText('Total Amount : ', weight: FontWeight.w900),
                      Utils.getText("\$${invoiceData?['total']??''}"),
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
                      Utils.getElevatedButton(onGenerate,text: 'Generate Invoice',icon: Icons.print),
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
