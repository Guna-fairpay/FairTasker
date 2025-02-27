
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../todo_edti_expense/ui/Test.dart';
import '../bloc/edit_todo_bloc.dart';
import '../state/edit_todo_state.dart';

class EditTodoBottomTabs extends StatelessWidget {

  const EditTodoBottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) {
        return Column(
          children: [
            TodoExpense(expenseId: state.apiResponse['expense_id'],),
          ],
        );
      },
    );
  }
}


