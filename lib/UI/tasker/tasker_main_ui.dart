import 'package:fairpytasker/UI/tasker/task_components/tasker_header.dart';
import 'package:flutter/material.dart';

class TaskerMainUi extends StatelessWidget {
  const TaskerMainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const TaskerHeader(),
        Expanded(
          child: ListView.separated(
            itemCount: 100,
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              title: Text("Index $index"),
            ), separatorBuilder: (BuildContext context, int index) => (index %2 == 0) ? TextField() : Container(),
          ),
        ),
      ],
    ));
  }
}
