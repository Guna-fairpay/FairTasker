import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/appC.dart';
import 'create_invoice_ui.dart';

class InvoiceViewUI extends StatefulWidget {
  const InvoiceViewUI({super.key});

  @override
  State<InvoiceViewUI> createState() => _InvoiceViewUIState();
}

class _InvoiceViewUIState extends State<InvoiceViewUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Utils.getText(
                  'Invoice History',
                  size: 20,
                  weight: FontWeight.bold,
                )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateInVoiceUI()));
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(width: 5),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.indigo[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Utils.getText(
                      'Details',
                      size: 15,
                      weight: FontWeight.bold,
                    ),
                    Utils.getText(
                      '\$',
                      size: 15,
                      weight: FontWeight.bold,
                    ),
                    Utils.getText(
                      '+',
                      size: 15,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
