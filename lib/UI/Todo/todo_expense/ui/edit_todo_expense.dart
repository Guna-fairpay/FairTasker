import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_bloc.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_event.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/bloc/todo_edit_expense_state.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/ui/edit_todo_expense_attachment.dart';
import 'package:fairpytasker/UI/Todo/todo_expense/ui/edit_todo_split_expense_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'invoice_preview_dialog.dart';

class TodoExpense extends StatelessWidget {
  final dynamic expenseId;
  final dynamic todoItem;
  final List<dynamic>? selectedParts;
  final List<dynamic>? selectedSupplies;
  final dynamic selectedVendor;

  const TodoExpense(
      {super.key,
      required this.expenseId,
      this.todoItem,
      this.selectedParts,
      this.selectedSupplies,
      this.selectedVendor});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoEditExpenseBloc>(
      create: (context) => TodoEditExpenseBloc()
        ..add(GetTodoExpenseInitialEvent(
            expenseId: expenseId,
            todoItem: todoItem,
            selectedParts: selectedParts,
            selectedSupplies: selectedSupplies,
            selectedVendor: selectedVendor)),
      child: BlocListener<TodoEditExpenseBloc, TodoExpenseState>(
          listener: (context, state) {
        state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
      }, child: BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
              builder: (context, state) {
        return Form(
          key: context.read<TodoEditExpenseBloc>().formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              if (state.vehicleList.length == 1)
                InkWell(
                  onTap: () => context.push(VehicleExpenseHistoryUI(
                    vin: state.vehicleList.firstOrNull['vin'],
                    vehicleName: state.vehicleList.firstOrNull['vehicle_name'],
                    showTotalAmount: false,
                  )),
                  child: Utils.getText(
                    'Expense Summary - ${state.selectedVehicle?['vehicle_name']}',
                    color: AppC().base,
                  ),
                ),
              if (state.vehicleList.length > 1)
                Utils.dropdownBox(
                  'Select Vehicle',
                  state.vehicleList,
                  (selectedValue) =>
                  context.read<TodoEditExpenseBloc>().add(
                       SelectedVehicleEvent(selectedVehicle: selectedValue)),
                  labelKey: 'vehicle_name',
                  initialSelection: state.selectedVehicle,
                  autovalidateMode: context.watch<TodoEditExpenseBloc>().autoValidateMode,
                  validator: (value) => (value == null) ? 'Select Vehicle' : null,
                ),
              EditTodoExpenseAttachment(
                attachments: state.expenseAttachments,
                pickImageEvent: () => context.read<TodoEditExpenseBloc>().add(PickImageEvent()),
                captureImageEvent: () => context.read<TodoEditExpenseBloc>().add(CaptureImageEvent()),
                invoiceEvent: () async {
                  context.read<TodoEditExpenseBloc>().add(InvoiceEvent());
                  await Future.delayed(Durations.short1);
                  InvoiceDialog.show(context);
                },
                removeImageEvent: (data) => context.read<TodoEditExpenseBloc>().add(RemoveImageEvent(data: data)),
                vendorList: state.vendorList,
              ),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.partsList.isEmpty && state.suppliesList.isEmpty)
                    Expanded(
                      child: Utils.getTextFormField(
                        'Amount in dollars',
                        textType: TextInputType.number,
                        context.read<TodoEditExpenseBloc>().amountController,
                        inputAction: TextInputAction.done,
                        autoValidate: context.watch<TodoEditExpenseBloc>().autoValidateMode,
                        validator: (value) => (context.read<TodoEditExpenseBloc>().requireAllFields && (value!.isEmpty)) ? 'Please Enter Amount' : null,
                      ),
                    ),
                  Expanded(
                    child: Utils.dropdownBox(
                      'Select Payment Method',
                      state.paymentMethods,
                      (value) => context
                          .read<TodoEditExpenseBloc>()
                          .add(SelectedPaymentEvent(paymentType: value)),
                      labelKey: 'name',
                      initialSelection: state.selectedPayment,
                    ),
                  ),
                ],
              ),
              Utils.getTextFormField(
                'Enter Description',
                context.read<TodoEditExpenseBloc>().descriptionController,
                inputAction: TextInputAction.done,
              ),
              if (state.partsList.isNotEmpty || state.suppliesList.isNotEmpty)
                const TodoSplitExpenseUI(),
              Utils.dropdownBox('Select Category', state.mainCategories,
                    (selectedValue) {
                context.read<TodoEditExpenseBloc>().add(CategoryListEvent(mainCategory: selectedValue));
                Future.microtask(() => Utils.dismissKeyboard(context));
                },
                selectedKey: state.selectedMainCategory,
                initialSelection: state.selectedMainCategory,
                labelKey: 'name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value == null) ? 'Please Select Category' : null,
              ),
              Utils.dropdownBox(
                'Select SubCategory', state.subCategories,
                    (selectedValue) {
                context.read<TodoEditExpenseBloc>().add(SubCategoryListEvent(subCategory: selectedValue));
                Future.microtask(() => Utils.dismissKeyboard(context));
              },
                selectedKey: state.selectedSubCategory,
                initialSelection: state.selectedSubCategory,
                labelKey: 'name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value == null) ? 'Please Select SubCategory' : null,
              ),
              Utils.getTextFormField(
                'Odometer',
                context.read<TodoEditExpenseBloc>().odometerController,
                textType: TextInputType.number,
                suffixIcon: GestureDetector(
                  onTap: () => context.read<TodoEditExpenseBloc>().add(
                      GetOdometerEvent(
                          vin: state.vehicleList.firstOrNull?['vin'])),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(
                      Icons.speed,
                      color: Colors.red,
                    ),
                  ),
                ),
                inputAction: TextInputAction.done,
              ),
              if (state.odometerMessage!.isNotEmpty)
                Utils.getText(state.odometerMessage ?? '', color: AppC.redAccent),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SuccessButton(
                    text: 'save',
                    onPressed: () => context
                        .read<TodoEditExpenseBloc>()
                        .add(const SaveExpenseEvent()),
                  ),
                  if (context.read<TodoEditExpenseBloc>().isSaveCategory)
                    SuccessButton(
                      text: 'Save Category',
                      onPressed: ()=>context.read<TodoEditExpenseBloc>().add(SaveCategoryEvent()),
                      backgroundColor: AppC.appColor,
                    ),
                ],
              ),
            ],
          ),
        );
      })),
    );
  }
}
