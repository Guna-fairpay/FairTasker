import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class WorkTimeTaskViewUI extends StatefulWidget {
  final Map<String, String> employee;

  const WorkTimeTaskViewUI({super.key, required this.employee});

  @override
  State<WorkTimeTaskViewUI> createState() => _WorkTimeTaskViewUIState();
}

class _WorkTimeTaskViewUIState extends State<WorkTimeTaskViewUI> {
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
            // Employee Information Section
            Container(
              decoration: BoxDecoration(
                color: AppC.appColor,
                borderRadius: BorderRadius.circular(4),
              ),
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Utils.getText(
                        widget.employee['name'] ?? '',
                        size: 16,
                        weight: FontWeight.bold,
                        color: AppC.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Utils.getText('54', color: AppC.white),
                    const SizedBox(width: 20),
                    Utils.getText('\$55', color: AppC.white),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close_sharp,
                        size: 18,
                        color: AppC.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: Utils.getText('Drop Car',
                        size: 16, weight: FontWeight.bold),
                    children: [
                      ListTile(
                        title: Utils.getText('Task 1'),
                        subtitle: Utils.getText('Task Description'),
                        onTap: () {
                          // Handle Task 1 tap
                        },
                      ),
                      ListTile(
                        title: Utils.getText('Task 2'),
                        subtitle: Utils.getText('Task Description'),
                        onTap: () {
                          // Handle Task 2 tap
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Utils.getText('Pickup Car',
                        size: 16, weight: FontWeight.bold),
                    children: [
                      ListTile(
                        title: Utils.getText('Profile'),
                        onTap: () {
                          // Handle Profile tap
                        },
                      ),
                      ListTile(
                        title: Utils.getText('Account'),
                        onTap: () {
                          // Handle Account tap
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Utils.getText('Clean Car',
                        size: 16, weight: FontWeight.bold),
                    children: [
                      ListTile(
                        title: Utils.getText('Report 1'),
                        onTap: () {
                          // Handle Report 1 tap
                        },
                      ),
                      ListTile(
                        title: Utils.getText('Report 2'),
                        onTap: () {
                          // Handle Report 2 tap
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Utils.getText('Other Task',
                        size: 16, weight: FontWeight.bold),
                    children: [
                      ListTile(
                        title: Utils.getText('Report 1'),
                        onTap: () {
                          // Handle Report 1 tap
                        },
                      ),
                      ListTile(
                        title: Utils.getText('Report 2'),
                        onTap: () {
                          // Handle Report 2 tap
                        },
                      ),
                    ],
                  ),
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
