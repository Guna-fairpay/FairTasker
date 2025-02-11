import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_end_after_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoRecurringSubForm extends StatelessWidget {
  const AddTodoRecurringSubForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      children: [
        AddTodoRecurringEndAfterField()
      ],
    ),);
  }
}
