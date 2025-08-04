import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/bloc/other_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherAddEditListingPage extends StatelessWidget {
  const OtherAddEditListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherAddEditBloc, OtherAddEditState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CompactAppBar(
            titleText: (context.watch<OtherAddEditBloc>().id).isNullOrEmpty ? 'Add Other Expense' : 'Edit Other Expense',
            onClose: context.pop,
            actionWidgets: [
              (context.watch<OtherAddEditBloc>().id).isNullOrEmpty ?
              const SizedBox.shrink(): IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent),
                    onPressed: (){
                      AskPermissionDialog.show(context,
                          title: "Are you sure?",
                          description: "Do you want to delete this Expense?",
                          positiveText: "Yes, delete it!",
                          negativeText: "Cancel",
                          isReasonRequired: false,
                          onPositivePressed: () => context.read<OtherAddEditBloc>().add(DeleteEvent()));
                    },
                  ),
              IconButton(
                icon: const Icon(Icons.close, color: AppC.white),
                onPressed: ()=> context.pop(),
              )

            ],
          ),
          body: SafeArea(
            minimum: 15.spMin.padding,
            child: Form(
              key: context.read<OtherAddEditBloc>().formKey,
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Expanded(
                        child: CustomDateTimePicker<DateTime>(
                          controller:
                          context.read<OtherAddEditBloc>().dateController,
                          format: "dd-MM-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded,
                              size: 18, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: context.read<OtherAddEditBloc>().selectedDate,
                          onChanged: (value) => context
                              .read<OtherAddEditBloc>()
                              .add(DateChangeEvent(selectedDate: value)),
                        ),
                      ),
                      Expanded(
                          child: Utils.getTextFormField(
                            "Expense Amount",
                            context.read<OtherAddEditBloc>().amountController,
                            textType: const TextInputType.numberWithOptions(decimal: true),
                            inputAction: TextInputAction.done,
                            textInputFormatter:[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            validator: (value) =>(value!.isEmpty) ? "Enter Expense Amount" : null,
                            autoValidate: context.watch<OtherAddEditBloc>().autoValidateMode,
                          ),
                      ),
                    ],
                  ),
                  15.spMin.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Expanded(
                          child: Utils.dropdownBox(
                            "Select Category",
                            context.read<OtherAddEditBloc>().categories,
                                (value) => context.read<OtherAddEditBloc>().add(
                                CategoryEvent(
                                    selectedCategory: value)),
                            labelKey: 'name',
                            initialSelection: context.watch<OtherAddEditBloc>().selectedCategory,
                            validator: (value) => value == null ? "Select Category" : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          )),
                      Expanded(
                          child: Utils.dropdownBox(
                            "Select Sub Category",
                            context.read<OtherAddEditBloc>().subCategories,
                            (value) => context.read<OtherAddEditBloc>().add(SubCategoryEvent(selectedSubCategory: value)),
                            labelKey: 'name',
                            initialSelection: context.watch<OtherAddEditBloc>().selectedSubCategory,
                            validator: (value) => value == null ? "Select Sub Category" : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          )),
                    ],
                  ),
                  15.spMin.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Expanded(
                          child: Utils.dropdownBox(
                              "Select Payment Type",
                              context.read<OtherAddEditBloc>().paymentType,
                                  (value) => context.read<OtherAddEditBloc>().add(
                                  PaymentEvent(paymentType: value)),
                              labelKey: 'name',
                              initialSelection: context.watch<OtherAddEditBloc>().selectedPaymentType,
                          )),
                      Expanded(
                          child: Utils.dropdownBox(
                            "Select Approved Status",
                            context.read<OtherAddEditBloc>().approved,
                                (value) => context.read<OtherAddEditBloc>().add(
                                ApprovedEvent(
                                    selectedApproved: value)),
                            labelKey: 'name',
                            initialSelection: context.watch<OtherAddEditBloc>().selectedApproved,
                            validator: (value) => value == null ? "Select Approved Status" : null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          )),
                    ],
                  ),
                  15.spMin.height,
                  Utils.getTextFormField("Description",
                      context.read<OtherAddEditBloc>().descriptionController),
                  15.spMin.height,
                    ImageUploadSection(
                      title: 'Upload',
                      onUpload: ()=> context.read<OtherAddEditBloc>().add(PickImageEvent()),
                      borderColor: Colors.blue,
                      onRemove: (file)=> context.read<OtherAddEditBloc>().add(RemoveImageEvent(data: file)),
                      images: context.read<OtherAddEditBloc>().attachments,
                      logName: "expenseAttachmentsEvent",
                      isRequired: true,
                    ),
                  SuccessButton(
                      text: (context.watch<OtherAddEditBloc>().id).isNullOrEmpty ? 'Save' : 'Update',
                      onPressed: ()=> context.read<OtherAddEditBloc>().add(SaveOrUpdateEvent()),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

