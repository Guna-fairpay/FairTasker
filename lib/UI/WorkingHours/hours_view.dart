import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class HoursViewUI extends StatefulWidget {
  final Map<String, String> employee;

  const HoursViewUI({super.key, required this.employee});

  @override
  State<HoursViewUI> createState() => _HoursViewUIState();
}

class _HoursViewUIState extends State<HoursViewUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Adjust the height here
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utils.getText(widget.employee['Name'] ?? '',
                    size: 16, weight: FontWeight.bold),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close_sharp, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Headers Row
            Container(
              color: AppC.appColor.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Utils.getText('Date', weight: FontWeight.bold)),
                    Expanded(
                        flex: 2,
                        child: Utils.getText('In', weight: FontWeight.bold)),
                    Expanded(
                        flex: 2,
                        child: Utils.getText('Out', weight: FontWeight.bold)),
                    Expanded(
                        flex: 2,
                        child: Utils.getText('Total', weight: FontWeight.bold)),
                    Expanded(
                        flex: 1,
                        child: Utils.getText('#', weight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Data Row
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Utils.getText('09-03-24')),
                  Expanded(
                      flex: 2,
                      child: Utils.getText(widget.employee['Active'] ?? '')),
                  Expanded(
                      flex: 2,
                      child: Utils.getText(widget.employee['Hours'] ?? '')),
                  Expanded(
                      flex: 2,
                      child: Utils.getText(widget.employee['Task'] ?? '')),
                  Expanded(
                      flex: 1,
                      child: Utils.getText(widget.employee['No'] ?? '')),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
