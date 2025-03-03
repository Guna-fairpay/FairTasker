
import 'dart:developer';

import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_edit_ui.dart';
import 'package:fairpytasker/UI/Todo/check_list_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/event/edit_todo_event.dart';
import 'package:fairpytasker/UI/Todo/maintenance/maintenance_check_list_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../todo_edti_expense/ui/edit_todo_expense.dart';
import '../bloc/edit_todo_bloc.dart';
import '../state/edit_todo_state.dart';

class EditTodoBottomTabs extends StatelessWidget {

  const EditTodoBottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
     // buildWhen: (previous, current) => previous.apiResponse['id'] != current.apiResponse['id'],
      builder: (context, state) {
        log(" ${state.selectedBottomTap['id']} :  ${state.apiResponse}", name: "BOTTOM_TAB");
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
              ),
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.bottomTapData.map((tab) {
                    return FeedbackTabButton(
                        buttonText: tab['title'],
                        value: tab['id'],
                        selectedValue: state.selectedBottomTap['id'],
                        onPressed: (val) => context.read<EditToDoBloc>().add(EditToDoBottomTapEvent(tab)));
                  }).toList(),
                ),
              ),
            ),
            Container(
              child: state.selectedBottomTap['id'] == 1
                  ?TodoExpense(expenseId: state.apiResponse['expense_id'], todoItem: state.apiResponse)
                  :state.selectedBottomTap['id'] == 2
                  ?const Placeholder()
                  :state.selectedBottomTap['id'] == 3
                  ?CheckListUI(checkListData: state.selectedTask, todoItems: {})
                  :state.selectedBottomTap['id'] == 4
                  ?const MaintenanceCheckListUI(maintenance: [], todoItems: {})
                  :state.selectedBottomTap['id'] == 5
                  ?VehicleEditUI(vehicle: {}, todoItems: {},)
                  :const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}


