
import 'package:flutter/material.dart';

import '../UI/CheckIn CheckOut/UI/reason_employee_task_history.dart';
import '../Utilities/Utils.dart';
import '../Utilities/appC.dart';

class TaskExpansionListTile extends StatelessWidget {
  final String leadingText;
  final String dateText;
  final String timeText;
  final Color timeTextColor;

  const TaskExpansionListTile({Key? key,required this.leadingText,
    required this.dateText,
    required this.timeText,
    this.timeTextColor = Colors.black,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Background color
        border: Border( // Use Border for specific sides
          bottom: BorderSide( // Only bottom border
            color: Color(0xFFD6D6D6), // Border color
            width: 1, // Border width
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Utils.getText(leadingText),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Utils.getText(dateText),
            Utils.getText(
              timeText,
              color: AppC.red,
            ),
          ],
        ),
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReasonEmployeeTaskHistory())
          );
        },
      ),
    );
  }
}
