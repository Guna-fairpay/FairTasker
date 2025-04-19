
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_edit_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/Todo/CheckList/check_list_ui.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/event/edit_todo_event.dart';
import 'package:fairpytasker/UI/Todo/maintenance/maintenance_check_list_ui.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/appC.dart';
import '../../Odometer/odometer_view.dart';
import '../../Private Rental Check/private_rental_check_UI.dart';
import '../../todo_edti_expense/ui/edit_todo_expense.dart';
import '../../todo_edti_expense/ui/edit_todo_expense.dart';
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
                  ? TodoExpense(
                      expenseId: state.apiResponse['expense_id'],
                      todoItem: state.apiResponse,
                      selectedParts: state.selectedParts,
                      selectedSupplies: state.selectedSupplies,
                      selectedVendor: state.selectedVLocations,
                  )
                  : state.selectedBottomTap['id'] == 2
                      ? const CreateTodoUI(showHeader: false)
                  :state.selectedBottomTap['id'] == 3
                  ?CheckListUI(todoItems: state.apiResponse, vehicle: state.taskHistory.first,)
                  :state.selectedBottomTap['id'] == 4
                  // ?MaintenanceCheckListUI(todoItems: state.apiResponse, vehicle: state.taskHistory.first,)
                  ?MaintenanceCheckUi(commentsController: context.read<EditToDoBloc>().commentsController, editToDo: state.apiResponse, onClose: context.pop)
                  :state.selectedBottomTap['id'] == 5
                  ?VehicleEditUI(vehicle: state.taskHistory.first,selectedVehicle: state.selectedVehicle, todoItems: state.apiResponse, showHeader: false,)
                  :state.selectedBottomTap['id'] == 6
                  ?PrivateRentalCheckUi(todoItems: state.apiResponse, vehicle: state.taskHistory.first,) //Add by RDB
                  :state.selectedBottomTap['id'] == 7
                  ?OdometerView(todoItems: state.apiResponse, vehicle: state.taskHistory.first, selectedVehicle: state.selectedVehicle)
                  :const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}


