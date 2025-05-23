

import 'dart:developer';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Add/Bloc/add_expense_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Add/Bloc/add_expense_vehicle_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Add/Bloc/add_expense_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ExpenseVehicleAddUI extends StatelessWidget {
  final dynamic model;
  const ExpenseVehicleAddUI({super.key,this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddExpenseVehicleBloc>(
      create: (context) => AddExpenseVehicleBloc()..add(GetVehicleExpenseAddData(model:model)),
      child: BlocListener<AddExpenseVehicleBloc, AddExpenseVehicleState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if(state.popAddPagePop){
            Navigator.pop(context);
          }
          log("${state.popAddPagePop}");
        },
        child: BlocBuilder<AddExpenseVehicleBloc, AddExpenseVehicleState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
                title: const Text('Add Expense'),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppC.white,
                      ))
                ],
              ),
              body: SafeArea(
                  minimum: 10.padding,
                  child: Form(
                    key: context.read<AddExpenseVehicleBloc>().formKey,
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
                                onPressed: () => context.read<AddExpenseVehicleBloc>().add(PickImageEvent()),
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
                                    .read<AddExpenseVehicleBloc>()
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
                            onRemove: (file)=> context.read<AddExpenseVehicleBloc>().add(RemoveImageEvent(data: file)),
                            images: state.expenseAttachments,
                            logName: "expenseAttachmentsEvent",
                            isRequired: false,
                          ),
                        ],
                        10.height,
                        CustomSingleSelectionField<Map<String, dynamic>>(
                          suggestionsList: state.vehicleList,
                          itemAsString: (item) => item['vehicle_name'] ?? '',
                          itemAsSearchString: (item) => "${item['vehicle_name'] ?? ""} ${item['vehicle_number'] ?? ""}" ,
                          selected: state.selectedVehicle,
                          labelText: "Vehicle Name",
                          hintText: "",
                          onSelected: (val) => context.read<AddExpenseVehicleBloc>().add(VehicleEvent(selectedVehicle: val)),
                          controller: context.read<AddExpenseVehicleBloc>().vehicleController,
                          validator: (value) => (value?.isEmpty ?? false) ? 'Please select vehicle' : null,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        10.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Utils.getTextFormField(
                                'Amount in dollars',
                                context.read<AddExpenseVehicleBloc>().amountController,
                                textType: const TextInputType.numberWithOptions(decimal: true),
                                inputAction: TextInputAction.done,
                                textInputFormatter:[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                                ],
                                autoValidate: context.read<AddExpenseVehicleBloc>().autoValidateMode,
                                validator: (value) => (value?.isEmpty ?? false) ? 'Please enter amount' : null,
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Utils.dropdownBox(
                                  'Select Payment Method',
                                  state.paymentType,
                                  (value) => context.read<AddExpenseVehicleBloc>().add(
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
                          context.read<AddExpenseVehicleBloc>().descriptionController,
                          inputAction: TextInputAction.done,
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Category',
                          state.categories,
                          (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(CategoryListEvent(selectedCategory: value)),
                          labelKey: 'name',
                          initialSelection: state.selectedCategory,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null) ? 'Please select category' : null,
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Sub Category',
                          state.subCategories,
                          (value) => context.read<AddExpenseVehicleBloc>().add(
                              SubCategoryListEvent(selectedSubCategory: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedSubCategory,
                          initialSelection: state.selectedSubCategory,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (state.selectedSubCategory == null ||
                                  ((state.selectedSubCategory is Map) && ((state.selectedSubCategory as Map).isEmpty))) {
                                return 'Please select a SubCategory';
                              }
                              return null;
                            }
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Expense To',
                          state.cohorts,
                          (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(CohortListEvent(selectedCohort: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedCohorts,
                          initialSelection: state.selectedCohorts,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (state.selectedCohorts == null ||
                                  ((state.selectedCohorts is Map) && ((state.selectedCohorts as Map).isEmpty))) {
                                return 'Please select a expense to';
                              }
                              return null;
                            }
                        ),
                        10.height,
                        CustomDateTimePicker<DateTime>(
                          controller:
                              context.read<AddExpenseVehicleBloc>().dateController,
                          format: "dd-MM-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded,
                              size: 18, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: state.selectedDate,
                          onChanged: (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(DateChangeEvent(selectedDate: value)),
                        ),
                        10.height,
                        Utils.getTextFormField('Odometer Reading',
                            context.read<AddExpenseVehicleBloc>().odometerController,
                            textType: TextInputType.number,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.speed,
                                color: AppC.redAccent,
                              ),
                            )),
                        10.height,
                        SuccessButton(
                          text: "Save",
                          onPressed: () => context.read<AddExpenseVehicleBloc>().add(SaveExpenseEvent()),
                        )
                      ],
                    ),
                  )));
        }),
      ),
    );
  }
}
