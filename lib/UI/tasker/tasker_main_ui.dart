import 'package:fairpytasker/Component/todo_task_card.dart';
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
          child: ListView.builder(
            itemCount: 2,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            addSemanticIndexes: false,
            itemBuilder: (context, index) => TodoTaskCard(index: index),
            // separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    ));
  }
}
