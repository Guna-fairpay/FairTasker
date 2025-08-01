part of 'edit_todo_ui.dart';

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
              2 => TaskerAddToDo(
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
                  selectedVehicle: state.selectedVehicle),
              8 =>  CheckOutMainUI(
                model: state.apiResponse,
              ),
              _ => const SizedBox(),
            },
          ),
        ],
      ),
    );
  }
}
