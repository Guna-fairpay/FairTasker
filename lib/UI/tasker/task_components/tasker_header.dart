import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_header.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_hours_view.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_search_bar.dart';
import 'package:flutter/material.dart';

class TaskerHeader extends StatelessWidget {
  const TaskerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        spacing: 2,
        children: [
          TodoTopHeader(),
          TodoTopHoursView(),
          TodoTopSearchBar(),
        ],
      ),
    );
  }
}
