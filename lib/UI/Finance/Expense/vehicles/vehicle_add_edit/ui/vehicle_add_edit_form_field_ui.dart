part of 'vehicle_add_edit_main_ui.dart';

class VehicleAddEditFormFieldUI extends StatelessWidget {
  const VehicleAddEditFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleAddEditBloc, VehicleAddEditState>(
      builder: (context, state) {
        return Form(
          key: context.watch<VehicleAddEditBloc>().formKey,
          child: Column(
            spacing: 10.spMin,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () => context.read<VehicleAddEditBloc>().add(PickImageEvent()),
                    ),
                  ),
                  Expanded(
                    child: SuccessButton(
                      text: 'Capture',
                      icon: Icons.camera_enhance,
                      foregroundColor: AppC.redAccent,
                      backgroundColor: AppC.trans,
                      isOutline: true,
                      onPressed: () => context.read<VehicleAddEditBloc>().add(CaptureImageEvent()),
                    ),
                  ),
                  if(context.watch<VehicleAddEditBloc>().todoItems?['vendor_id'] != null)
                    Expanded(
                    child: SuccessButton(
                      text: 'Invoice',
                      icon: Icons.receipt_long_rounded,
                      foregroundColor: AppC.blue,
                      backgroundColor: AppC.trans,
                      isOutline: true,
                      onPressed: () => context.read<VehicleAddEditBloc>().add(CaptureImageEvent()),
                    ),
                  ),
                ],
              ),
              if (context.watch<VehicleAddEditBloc>().attachmentList.isNotEmpty)
                ImageUploadSection(
                  title: '',
                  borderColor: Colors.blue,
                  onRemove: (file)=> context.read<VehicleAddEditBloc>().add(RemoveImageEvent(data: file)),
                  images: context.watch<VehicleAddEditBloc>().attachmentList,
                  logName: "expenseAttachmentsEvent",
                  isRequired: false,
                ),
              CustomSingleSelectionField<Map<String, dynamic>>(
                suggestionsList: context.read<VehicleAddEditBloc>().vehicleList,
                itemAsString: (item) => item['vehicle_name'] ?? '',
                itemAsSearchString: (item) => "${item['vehicle_name'] ?? ""} ${item['vehicle_number'] ?? ""}" ,
                selected: context.watch<VehicleAddEditBloc>().selectedVehicle,
                labelText: "Vehicle Name",
                hintText: "",
                onSelected: (val) => context.read<VehicleAddEditBloc>().add(SelectVehicleEvent(val)),
                controller: context.read<VehicleAddEditBloc>().vehicleController,
                validator: (value) => (value?.isEmpty ?? false) ? 'Select vehicle' : null,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  if(context.read<VehicleAddEditBloc>().splitExpense.isEmpty)
                    Expanded(
                      child: Utils.getTextFormField(
                        'Amount in dollars',
                        context.read<VehicleAddEditBloc>().amountController,
                        textType: const TextInputType.numberWithOptions(decimal: true),
                        inputAction: TextInputAction.done,
                        textInputFormatter:[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (value) => (value?.isEmpty ?? false) ? 'Enter amount' : null,
                        autoValidate: context.read<VehicleAddEditBloc>().autoValidateMode,
                      ),
                    ),
                  Expanded(
                    child: Utils.dropdownBox(
                      'Select Payment Method',
                      context.read<VehicleAddEditBloc>().paymentMethod,
                      (value) => context.read<VehicleAddEditBloc>().add(SelectPaymentEvent(value)),
                      labelKey: 'name',
                      initialSelection: context.read<VehicleAddEditBloc>().selectedPaymentMethod,
                    ),
                  ),
                ],
              ),
              Utils.getTextFormField(
                'Enter Description',
                context.read<VehicleAddEditBloc>().descriptionController,
                inputAction: TextInputAction.done,
              ),
              Utils.dropdownBox(
                'Select Category',
                context.read<VehicleAddEditBloc>().categoryList,
                    (value) => context.read<VehicleAddEditBloc>().add(SelectCategoryEvent(value)),
                labelKey: 'name',
                initialSelection: context.read<VehicleAddEditBloc>().selectedCategory,
                validator: (value) => (value == null) ? 'Select Sub Category' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Utils.dropdownBox(
                'Select Sub Category',
                context.watch<VehicleAddEditBloc>().subCategoryList,
                    (value) => context.read<VehicleAddEditBloc>().add(SelectSubCategoryEvent(value)),
                labelKey: 'name',
                selectedKey: context.watch<VehicleAddEditBloc>().selectedSubCategory,
                initialSelection: context.watch<VehicleAddEditBloc>().selectedSubCategory,
                validator: (value) => (value == null) ? "Select Sub Category" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Utils.dropdownBox(
                'Select Expense To',
                context.watch<VehicleAddEditBloc>().expenseTo,
                    (value) => context.read<VehicleAddEditBloc>().add(SelectExpenseToEvent(value)),
                labelKey: 'name',
                selectedKey: context.watch<VehicleAddEditBloc>().selectedExpenseTo,
                initialSelection: context.watch<VehicleAddEditBloc>().selectedExpenseTo,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value == null) ? "Select ExpenseTo" : null,
              ),
              CustomDateTimePicker<DateTime>(
                controller: context.read<VehicleAddEditBloc>().dateController,
                format: "dd-MM-yyyy",
                suffixIcon: Icon(Icons.calendar_month_rounded, size: 18.spMin, color: context.theme.hintColor),
                textAlign: TextAlign.center,
                value: context.read<VehicleAddEditBloc>().selectedDate,
                onChanged: (value) => context.read<VehicleAddEditBloc>().add(DatePickedEvent(value)),
              ),
              if(!context.read<VehicleAddEditBloc>().isEdit)
              Utils.getTextFormField('Odometer Reading',
                  context.read<VehicleAddEditBloc>().odometerController,
                  textType: const TextInputType.numberWithOptions(decimal: true),
                  inputAction: TextInputAction.done,
                  textInputFormatter:[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  suffixIcon: GestureDetector(
                    onTap: ()=> context.read<VehicleAddEditBloc>().add(GetOdometerEvent()),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                        Icons.speed,
                        color: AppC.redAccent,
                      ),
                    ),
                  )),
              if(context.watch<VehicleAddEditBloc>().bouncieMessage != null)
                Utils.getText(context.watch<VehicleAddEditBloc>().bouncieMessage ?? '', color: AppC.redAccent),
              Row(
                children: [
                  Expanded(
                    child: SuccessButton(
                        text: context.read<VehicleAddEditBloc>().isEdit ? 'Update' : 'Save',
                        onPressed: () => context.read<VehicleAddEditBloc>().add(SaveEvent()),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
