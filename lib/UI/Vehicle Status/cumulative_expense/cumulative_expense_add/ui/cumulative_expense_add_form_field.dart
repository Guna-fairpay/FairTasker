
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CumulativeExpenseAddFormField extends StatelessWidget {
  const CumulativeExpenseAddFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CumulativeExpenseAddBloc, CumulativeExpenseAddState>(
      builder: (context,state) {
        return SafeArea(
            minimum: 12.sp.padding,
            child: Form(
              key: context.read<CumulativeExpenseAddBloc>().formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                 CustomDateTimePicker<DateTime>(
                   controller:context.read<CumulativeExpenseAddBloc>().dateController,
                   value: context.watch<CumulativeExpenseAddBloc>().selectedDate,
                   onChanged:(val)=> context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddDatePickEvent(selectedDate: val)),
                   format: 'MM-dd-yyyy',
                   suffixIcon: Icon(Icons.calendar_month_outlined,size: 12.sp,),
                   labelText: 'mm-dd-yyyy',
                   padding: 8.sp.padding,
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                   validator: (value) => (value == null) ? "Please select date" : null,
                 ),
                  12.sp.height,
                  Utils.dropdownBox(
                      'Select Cohort',
                      context.read<CumulativeExpenseAddBloc>().cohort,
                      (value)=>context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddCohortEvent(selectedCohort: value)),
                      labelKey: 'cohort',
                    initialSelection: context.read<CumulativeExpenseAddBloc>().selectedCohort,
                    selectedKey: context.read<CumulativeExpenseAddBloc>().selectedCohort,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null) ? "Please select cohort" : null,
                  ),
                  12.sp.height,
                  Utils.dropdownBox(
                    'Select Vehicle',
                    context.read<CumulativeExpenseAddBloc>().vehicleList,
                        (value)=>context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddVehicleEvent(selectedVehicle: value)),
                    labelKey: 'vehicle_name',
                    initialSelection: context.read<CumulativeExpenseAddBloc>().selectedVehicle,
                    selectedKey: context.read<CumulativeExpenseAddBloc>().selectedVehicle,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null) ? "Please select vehicle" : null,
                  ),
                  12.sp.height,
                  Utils.dropdownBox(
                    'Select Category',
                    context.read<CumulativeExpenseAddBloc>().categoryList,
                        (value)=>context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddCategoryEvent(selectedCategory: value)),
                    labelKey: 'name',
                    initialSelection: context.read<CumulativeExpenseAddBloc>().selectedCategory,
                    selectedKey: context.read<CumulativeExpenseAddBloc>().selectedSubCategory,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null) ? "Please select category" : null,
                  ),
                  12.sp.height,
                  Utils.dropdownBox(
                    'Select Sub Category',
                    context.read<CumulativeExpenseAddBloc>().subCategoryList,
                        (value)=>context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddSubCategoryEvent(selectedSubCategory: value)),
                    labelKey: 'name',
                    initialSelection: context.read<CumulativeExpenseAddBloc>().selectedSubCategory,
                    selectedKey: context.read<CumulativeExpenseAddBloc>().selectedSubCategory,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null) ? "Please select sub category" : null,
                  ),
                  12.sp.height,
                  Utils.getTextFormField(
                    'Amount in dollars',
                    context.read<CumulativeExpenseAddBloc>().amountController,
                    textType: const TextInputType.numberWithOptions(decimal: true),
                    textInputFormatter:[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    autoValidate: context.watch<CumulativeExpenseAddBloc>().autoValidateMode,
                    validator: (value) => (value == null || value.isEmpty) ? "Please enter amount" : null,
                  ),
                  12.sp.height,
                  Utils.getTextFormField(
                    'Enter Description',
                    context.read<CumulativeExpenseAddBloc>().descriptionController,
                    inputAction: TextInputAction.done,
                  ),
                  12.sp.height,
                  SuccessButton(
                    onPressed: ()=>context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddReceiptEvent()),
                    text: 'Receipt',
                    isOutline: true,
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppC.grey,
                  ),
                  12.sp.height,
                  ImageUploadSection(
                    title: '',
                    isDeleteDialog: false,
                    borderColor: Colors.blue,
                    onRemove: (file)=> context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddRemoveAttachmentEvent(data:file)),
                    images: context.watch<CumulativeExpenseAddBloc>().files,
                    logName: "CumulativeExpenseAddRemoveAttachmentEvent",
                    isRequired: false,
                  ),
                  20.sp.height,
                  SuccessButton(
                    onPressed: ()=> context.read<CumulativeExpenseAddBloc>().add(CumulativeExpenseAddSaveEvent()),
                    text: 'Save',
                  ),
                ],
              ),
            ));
      }
    );
  }
}
