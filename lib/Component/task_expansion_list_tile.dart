
import 'package:flutter/material.dart';

import '../UI/CheckIn CheckOut/UI/reason_employee_task_history.dart';
import '../Utilities/Utils.dart';

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
    return ListTile(
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
            color: timeTextColor,
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
    );
  }
}
