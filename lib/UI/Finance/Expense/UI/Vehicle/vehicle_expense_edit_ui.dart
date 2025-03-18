
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/expense_bloc.dart';
import '../../State/expense_state.dart';

class ExpenseVehicleEditUI extends StatelessWidget {
  const ExpenseVehicleEditUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc()..add(const GetVehicleExpenseAddData()),
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context,state) {
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
                    child: ListView(
                      children: [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    context.read<ExpenseBloc>().add(PickImageEvent()),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.blue,
                                      width: Num.borderWidthField,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(Num.subradiusButton),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.cloud_upload,
                                        color: AppC.blue,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Utils.getText('Upload',
                                          color: AppC.blue, weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<ExpenseBloc>()
                                    .add(CaptureImageEvent()),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.redAccent,
                                      width: Num.borderWidthField,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(Num.subradiusButton),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_enhance,
                                        color: AppC.redAccent,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Utils.getText('Capture',
                                          color: AppC.redAccent,
                                          weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.expenseAttachments.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: state.expenseAttachments.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1, mainAxisSpacing: 10),
                              itemBuilder: (context, index) => CloseBadge(
                                  onTapView: () {
                                    ShowAttachmentsDialog.of.show(context,
                                        attachments: state.expenseAttachments,
                                        title: "",
                                        currentAttachment:
                                        state.expenseAttachments[index]);
                                  },
                                  onTapDelete: () {
                                    AskPermissionDialog.show(context,
                                        title: "Are you sure?",
                                        description:
                                        "Do you want to delete this Expense Image?",
                                        positiveText: "Yes, delete it!",
                                        negativeText: "Cancel",
                                        isReasonRequired: false,
                                        onPositivePressed: () => context
                                            .read<ExpenseBloc>()
                                            .add(RemoveImageEvent(
                                            data: state
                                                .expenseAttachments[index])));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight:
                                          MediaQuery.sizeOf(context).height,
                                          minWidth: MediaQuery.sizeOf(context).width,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: AppC.grey.withValues(alpha: 0.2)),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: ImageViewer(
                                          fit: BoxFit.cover,
                                          imageInput: state.expenseAttachments[index],
                                          isNotImage:
                                          !((state.expenseAttachments[index]
                                          as Object)
                                              .isImage),
                                        ),
                                      ),
                                      if ((state.expenseAttachments[index] as Object)
                                          .isPDF)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppC.green,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Utils.openURL(
                                                  state.expenseAttachments[index]);
                                            },
                                            child: Padding(
                                              padding: 4.padding,
                                              child: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppC.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )),
                            ),
                          ),
                        10.height,
                        CustomSingleSelectionField<Map<String, dynamic>>(
                          suggestionsList: state.vehicleList,
                          itemAsString: (item) => item['vehicle_name'] ?? '',
                          selected: state.selectedVehicle,
                          labelText: "Vehicle Name",
                          hintText: "",
                          onSelected: (val) {
                            context
                                .read<ExpenseBloc>()
                                .add(VehicleEvent(selectedVehicle: val));
                          },
                          controller: context
                              .read<ExpenseBloc>()
                              .vehicleController,
                        ),
                        10.height,
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField(
                                'Amount in dollars',
                                context.read<ExpenseBloc>().amountController,
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Utils.dropdownBox(
                                  'Select Payment Method', state.paymentType,
                                      (value) =>
                                      context.read<ExpenseBloc>().add(SelectedPaymentEvent(paymentType:value)),
                                  labelKey: 'name'),
                            ),
                          ],
                        ),
                        10.height,
                        Utils.getTextFormField(
                          'Enter Description',
                          context.read<ExpenseBloc>().descriptionController,
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Category',
                          state.categories,
                              (value)=>context.read<ExpenseBloc>().add(CategoryListEvent(selectedCategory:value)),
                          labelKey: 'name',
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Sub Category',
                          state.subCategories,
                              (value)=>context.read<ExpenseBloc>().add(SubCategoryListEvent(selectedSubCategory:value)),
                          labelKey: 'name',
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Expense To',
                          [],
                              (value)=>context.read<ExpenseBloc>().add(SubCategoryListEvent(selectedSubCategory:value)),
                          labelKey: '',
                        ),
                        10.height,
                        CustomDateTimePicker<DateTime>(
                          controller: context
                              .read<ExpenseBloc>()
                              .dateController,
                          format: "dd-MM-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded,
                              size: 18, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: state.selectedDate,
                          onChanged: (value) => context
                              .read<ExpenseBloc>()
                              .add(DateChangeEvent(selectedDate: value)),
                        ),
                        10.height,
                        Utils.getTextFormField(
                            'Odometer Reading',
                            context.read<ExpenseBloc>().odometerController,
                            textType: TextInputType.number,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal:10.0),
                              child: Icon(Icons.speed,color: AppC.redAccent,),
                            )
                        ),
                        10.height,
                        Utils.getElevatedButton((){})
                      ],
                    )));
          }
      ),
    );
  }
}
