
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/custom_date_time_picker.dart';
import '../../../../Component/custom_single_selection_field.dart';
import '../../../../Utilities/Utils.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryEditPage extends StatelessWidget {
  final String? id;
  final bool showTotalAmount;
  final double? currentExpenseAmount;
  const VehicleExpenseHistoryEditPage({super.key, required this.id,required this.showTotalAmount,this.currentExpenseAmount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleExpenseHistoryBloc>(
      create: (context) => VehicleExpenseHistoryBloc()
        ..add(GetEditVehicleExpenseHistory(id: id)),
      child:
          BlocListener<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
                builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Expense"),
              foregroundColor: Colors.white,
              backgroundColor: AppC.appColor,
              automaticallyImplyLeading: false,
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
                          .read<VehicleExpenseHistoryBloc>()
                          .add(DeleteVehicleExpenseHistoryEvent(id: id));
                      Future.delayed(
                        const Duration(seconds: 1),
                        () => context.pushReplacement(VehicleExpenseHistoryUI(
                          vin: state.vin,
                          vehicleName: state.vehicleName,
                          showTotalAmount: showTotalAmount,
                          currentExpenseAmount: currentExpenseAmount,
                        )),
                      );
                    });
                  },
                  icon: const Icon(Icons.delete_outline,color: AppC.redAccent,),
                ),
                IconButton(
                  onPressed: () =>
                      context.pushReplacement(VehicleExpenseHistoryUI(
                    vin: state.vin,
                    vehicleName: state.vehicleName,
                        showTotalAmount: showTotalAmount,
                        currentExpenseAmount: currentExpenseAmount,
                  )),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: SafeArea(
              minimum: 20.padding,
              child: Form(
                key: context.read<VehicleExpenseHistoryBloc>().formKey,
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
                                .read<VehicleExpenseHistoryBloc>()
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
                                .read<VehicleExpenseHistoryBloc>()
                                .add(CaptureImageEvent()),
                          ),
                        ),
                      ],
                    ),
                    10.height,
                    if (state.expenseAttachments.isNotEmpty)...[
                      10.height,
                      ImageUploadSection(
                        title: '',
                        borderColor: Colors.blue,
                        onRemove: (file)=> context.read<VehicleExpenseHistoryBloc>().add(RemoveImageEvent(data: file)),
                        images: state.expenseAttachments,
                        logName: "expenseAttachmentsEvent",
                        isRequired: false,
                      ),
                    ],
                    10.height,
                    CustomSingleSelectionField<Map<String, dynamic>>(
                      suggestionsList: state.vehicle,
                      itemAsString: (item) => item['vehicle_name'] ?? '',
                      itemAsSearchString: (item) => "${item['vehicle_name'] ?? ""} ${item['vehicle_number'] ?? ""}" ,
                      selected: state.selectedVehicle,
                      labelText: "Vehicle Name",
                      hintText: "",
                      onSelected: (val) {
                        context
                            .read<VehicleExpenseHistoryBloc>()
                            .add(VehicleEvent(selectedVehicle: val));
                      },
                      controller: context
                          .read<VehicleExpenseHistoryBloc>()
                          .vehicleController,
                      validator: (value) => (value?.isEmpty ?? false) ? 'Please select vehicle' : null,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    10.height,
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if((context.read<VehicleExpenseHistoryBloc>().splitExpenses ?? []).isEmpty)
                        Expanded(
                          child: Utils.getTextFormField(
                            'Amount',
                            context
                                .read<VehicleExpenseHistoryBloc>()
                                .amountController,
                            textType: const TextInputType.numberWithOptions(decimal: true),
                            inputAction: TextInputAction.done,
                            textInputFormatter:[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            validator: (value) => (value?.isEmpty ?? false) ? 'Please enter amount' : null,
                            autoValidate: context.read<VehicleExpenseHistoryBloc>().autoValidateMode,
                          ),
                        ),
                        Expanded(
                            child: Utils.dropdownBox(
                                'Select Payment Method',
                                state.paymentMethods,
                                (value) => context
                                    .read<VehicleExpenseHistoryBloc>()
                                    .add(
                                        SelectedPaymentEvent(paymentType: value)),
                                labelKey: 'name',
                                initialSelection: state.selectedPaymentMethod))
                      ],
                    ),
                    10.height,
                    Utils.getTextFormField(
                      'Description',
                      context
                          .read<VehicleExpenseHistoryBloc>()
                          .descriptionController,
                    ),
                    10.height,
                    Utils.dropdownBox(
                      'Select Category',
                      state.categories,
                        (value) => context.read<VehicleExpenseHistoryBloc>()
                          .add(CategoryListEvent(category: value)),
                        labelKey: 'name',
                        selectedKey: state.selectedCategory,
                        initialSelection: state.selectedCategory,
                      validator: (value) => ((value == null) || (value is Map && value.isEmpty)) ? 'Please select category' : null,
                      autovalidateMode: context.watch<VehicleExpenseHistoryBloc>().autoValidateMode,
                    ),
                    10.height,
                    Utils.dropdownBox('Select SubCategory', state.subCategories,
                        (value) => context
                          .read<VehicleExpenseHistoryBloc>()
                          .add(SubCategoryListEvent(subCategory: value)),
                      labelKey: 'name',
                      selectedKey: state.selectedSubCategory,
                      initialSelection: state.selectedSubCategory,
                      validator: (value) => ((value == null) || (value is Map && value.isEmpty)) ? 'Please select sub category' : null,
                      autovalidateMode: context.watch<VehicleExpenseHistoryBloc>().autoValidateMode,
                    ),
                    10.height,
                    Utils.dropdownBox(
                      'Select Expense To',
                      state.cohorts,
                      (value) => context.read<VehicleExpenseHistoryBloc>().add(CohortListEvent(selectedCohort: value)),
                      labelKey: 'name',
                      selectedKey: state.selectedCohorts,
                      initialSelection: state.selectedCohorts,
                      autovalidateMode: context.watch<VehicleExpenseHistoryBloc>().autoValidateMode,
                      validator: (value) => ((value == null) || (value is Map && value.isEmpty)) ? 'Please select expense to' : null,
                    ),
                    10.height,
                    CustomDateTimePicker<DateTime>(
                      controller: context
                          .read<VehicleExpenseHistoryBloc>()
                          .dateController,
                      format: "dd-MM-yyyy",
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 18, color: context.theme.hintColor),
                      textAlign: TextAlign.center,
                      value: state.selectedDate,
                      onChanged: (value) => context
                          .read<VehicleExpenseHistoryBloc>()
                          .add(DateChangeEvent(selectedDate: value)),
                    ),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SuccessButton(
                          onPressed: () {
                            context.read<VehicleExpenseHistoryBloc>().add(
                                UpdateVehicleExpenseHistoryEvent(id: "${state.editResponse['id']}"));
                            if(context.read<VehicleExpenseHistoryBloc>().formKey.currentState?.validate() ?? false){
                              Future.delayed(const Duration(seconds: 1),
                                      () => context.pushReplacement(VehicleExpenseHistoryUI(
                                    vin: state.vin,
                                    vehicleName: state.vehicleName,
                                    showTotalAmount: showTotalAmount,
                                    currentExpenseAmount: currentExpenseAmount,
                                  )));
                            }

                          },
                          text: 'Update',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
