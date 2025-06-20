import 'package:fairpytasker/UI/Todo/private_rental/UI/private_rental_check_list_page.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_ui.dart';
import 'package:fairpytasker/UI/Todo/set_vehicles/ui/set_vehicles_main_ui.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/ui/edit_todo_expense.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_event.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_state.dart';
import 'package:fairpytasker/UI/Todo/pre_checks/ui/precheck_main_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/Todo/Odometer/odometer_view.dart';
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditTodoBottomTabs extends StatelessWidget {
  const EditTodoBottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) => Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: AppC.borderColor, width: Num.borderWidthButton)),
            ),
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.bottomTapData
                    .map((tab) => FeedbackTabButton(
                        buttonText: tab['title'],
                        value: tab['id'],
                        selectedValue: state.selectedBottomTap['id'],
                        overrideTextColor: (tab['title'] == "Set Vehicle")
                            ? AppC.redAccent
                            : null,
                        onPressed: (val) => context
                            .read<EditToDoBloc>()
                            .add(EditToDoBottomTapEvent(tab))))
                    .toList(),
              ),
            ),
          ),
          Container(
            child: switch (state.selectedBottomTap['id']) {
              1 => TodoExpense(
                  expenseId: state.apiResponse['expense_id'],
                  todoItem: state.apiResponse,
                  selectedParts: state.selectedParts,
                  selectedSupplies: state.selectedSupplies,
                  selectedVendor: state.selectedVLocations),
              2 => CreateTodoUI(
                  showHeader: false,
                  isNextTask: true,
                  selectedDate: state.selectedDate,
                  selectedVPerson:
                      context.read<EditToDoBloc>().vehiclePersonList),
              3 => PreCheckMainUi(
                  model: state.apiResponse,
                  selectedVehicle: state.selectedVehicle),
              4 => MaintenanceCheckUi(
                  commentsController:
                      context.read<EditToDoBloc>().commentsController,
                  editToDo: state.apiResponse,
                  onClose: context.pop,
                  selectedVehicle: state.selectedVehicle),
              // 5 => SetVehicleUi(
              //     todoItems: state.apiResponse,
              //     selectedVehicle: state.selectedVehicle),
              5 => SetVehiclesMainUI(
                  todoItems: state.apiResponse,
                  selectedVehicle: state.selectedVehicle),
              6 => PrivateRentalCheckMainPage(todoData: state.apiResponse),
              7 => OdometerView(
                  todoItems: state.apiResponse,
                  vehicle: state.taskHistory.firstOrNull,
                  selectedVehicle: state.selectedVehicle), //Add by RDB
              _ => const SizedBox(),
            },
          ),
        ],
      ),
    );
  }
}
