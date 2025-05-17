
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/Bloc/edit_expense_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/Bloc/edit_expense_vehicle_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/Bloc/edit_expense_vehicle_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/UI/split_expense.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/UI/todo_details_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseVehicleEditUI extends StatelessWidget {
  final String? expenseId;
  final String? vehicleName;
  const ExpenseVehicleEditUI({super.key, required this.expenseId,required this.vehicleName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditExpenseVehicleBloc>(
      create: (context) =>
      EditExpenseVehicleBloc()..add(GetVehicleExpenseEditData(id: expenseId)),
      child: BlocListener<EditExpenseVehicleBloc, EditExpenseVehicleState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if(state.popEditPage) context.pop();
        },
        child:
            BlocBuilder<EditExpenseVehicleBloc, EditExpenseVehicleState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
                title: Text(vehicleName??''),
                titleTextStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppC.white),
                actions: [
                  IconButton(
                      onPressed: () {
                        AskPermissionDialog.show(context,
                            title: "Are you sure?",
                            description: "Do you want to delete this Expense?",
                            positiveText: "Yes, delete it!",
                            negativeText: "Cancel",
                            isReasonRequired: false, onPositivePressed: () {
                          context
                              .read<EditExpenseVehicleBloc>()
                              .add(DeleteExpenseEvent(id: expenseId));
                          // Future.delayed(
                          //   const Duration(seconds: 1),
                          //   () =>context.pop(), //context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 4, message: '',)),
                          // );
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppC.redAccent,
                      )),
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppC.white,
                      ))
                ],
              ),
              body: SafeArea(
                  minimum: 10.padding,
                  child: ListView(
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: SuccessButton(
                              text: 'Upload',
                              icon: Icons.cloud_upload,
                              foregroundColor: AppC.blue,
                              backgroundColor: AppC.trans,
                              isOutline: true,
                              onPressed: () => context
                                  .read<EditExpenseVehicleBloc>()
                                  .add(PickImageEvent()),
                            ),
                          ),
                          Expanded(
                            child: SuccessButton(
                              text: 'Capture',
                              icon: Icons.camera_enhance,
                              foregroundColor: AppC.redAccent,
                              backgroundColor: AppC.trans,
                              isOutline: true,
                              onPressed: () => context
                                  .read<EditExpenseVehicleBloc>()
                                  .add(CaptureImageEvent()),
                            ),
                          ),
                        ],
                      ),
                      if (state.expenseAttachments.isNotEmpty)...[
                        10.height,
                        ImageUploadSection(
                          title: '',
                          borderColor: Colors.blue,
                          onRemove: (file)=> context.read<EditExpenseVehicleBloc>().add(RemoveImageEvent(data: file)),
                          images: state.expenseAttachments,
                          logName: "expenseAttachmentsEvent",
                          isRequired: false,
                        ),
                      ],
                      10.height,
                      CustomSingleSelectionField<Map<String, dynamic>>(
                        suggestionsList: state.vehicleList,
                        itemAsString: (item) => item['vehicle_name'] ?? '',
                        selected: state.selectedVehicle,
                        labelText: "Vehicle Name",
                        hintText: "",
                        onSelected: (val) {
                          context
                              .read<EditExpenseVehicleBloc>()
                              .add(VehicleEvent(selectedVehicle: val));
                        },
                        controller:
                            context.read<EditExpenseVehicleBloc>().vehicleController,
                      ),
                      10.height,
                      Row(
                        spacing: 10,
                        children: [
                          if(state.splitExpense.isEmpty)
                          Expanded(
                            child: Utils.getTextFormField(
                              'Amount in dollars',
                              context.read<EditExpenseVehicleBloc>().amountController,
                              textType: const TextInputType.numberWithOptions(decimal: true),
                              inputAction: TextInputAction.done,
                              textInputFormatter:[
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Utils.dropdownBox(
                              'Select Payment Method',
                              state.paymentType,
                              (value) => context.read<EditExpenseVehicleBloc>().add(
                                  SelectedPaymentEvent(paymentType: value)),
                              labelKey: 'name',
                              initialSelection: state.selectedPaymentType,
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      Utils.getTextFormField(
                        'Enter Description',
                        context.read<EditExpenseVehicleBloc>().descriptionController,
                        inputAction: TextInputAction.done,
                      ),
                      10.height,
                      Utils.dropdownBox(
                        'Select Category',
                        state.categories,
                        (value) => context
                            .read<EditExpenseVehicleBloc>()
                            .add(CategoryListEvent(selectedCategory: value)),
                        labelKey: 'name',
                        initialSelection: state.selectedCategory,
                      ),
                      10.height,
                      Utils.dropdownBox(
                          'Select Sub Category',
                          state.subCategories,
                          (value) => context.read<EditExpenseVehicleBloc>().add(
                              SubCategoryListEvent(selectedSubCategory: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedSubCategory,
                          initialSelection: state.selectedSubCategory),
                      10.height,
                      Utils.dropdownBox(
                        'Select Expense To',
                        state.cohorts,
                        (value) => context.read<EditExpenseVehicleBloc>().add(
                            CohortListEvent(selectedCohort: value)),
                        labelKey: 'name',
                        selectedKey: state.selectedCohorts,
                        initialSelection: state.selectedCohorts,
                      ),
                      10.height,
                      CustomDateTimePicker<DateTime>(
                        controller: context.read<EditExpenseVehicleBloc>().dateController,
                        format: "dd-MM-yyyy",
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 18, color: context.theme.hintColor),
                        textAlign: TextAlign.center,
                        value: state.selectedDate,
                        onChanged: (value) => context
                            .read<EditExpenseVehicleBloc>()
                            .add(DateChangeEvent(selectedDate: value)),
                      ),
                      10.height,
                      Utils.getElevatedButton(() => context.read<EditExpenseVehicleBloc>().add(const UpdateExpenseEvent())),
                      10.height,
                      if(state.todoDetails.isNotEmpty)
                      const TodoDetailsUI(),
                      10.height,
                      if(state.splitExpense.isNotEmpty)
                      const SplitExpenseUI(),
                    ],
                  )));
        }),
      ),
    );
  }
}
