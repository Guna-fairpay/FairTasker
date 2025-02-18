import 'package:fairpytasker/Component/custom_wrap_choice.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoTaskManagerForm extends StatelessWidget {
  const AddTodoTaskManagerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state)  {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Utils.getText('Task Manager', weight: FontWeight.bold),
            CustomWrapChoice<dynamic>(items: state.persons,
              itemAsString: (item) => item['first_name']+"\t${item['last_name']}",
              selectedItems: state.selectedTaskPersons,
              onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(AddToDoPersonTapEvent(value, isChecked)),
            ),
            if (state.selectedTaskPersons.isEmpty)
            Utils.getText('Please select task manager',
                align: TextAlign.start,
                style: context.textTheme.labelSmall
                    ?.copyWith(color: context.theme.colorScheme.error))
          ],
        );
      }
    );
  }
}
