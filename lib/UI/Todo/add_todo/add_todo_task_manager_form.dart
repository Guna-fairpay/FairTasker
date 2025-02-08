import 'package:fairpytasker/Component/custom_wrap_choice.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class AddTodoTaskManagerForm extends StatelessWidget {
  const AddTodoTaskManagerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Utils.getText('Task Manager', weight: FontWeight.bold),
          CustomWrapChoice<Map<String, dynamic>>(items: [],),
          Utils.getText('Please select task manager',
              color: const Color(0xffd01601))
        ],
      ),
    );
  }
}
