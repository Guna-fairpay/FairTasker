
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/UI/split_expense.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Edit/UI/todo_details_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Vehicle_List/Bloc/expense_bloc.dart';
import '../../Vehicle_List/Bloc/expense_state.dart';

class ExpenseVehicleEditUI extends StatelessWidget {
  final String? expenseId;
  final String? vehicleName;
  const ExpenseVehicleEditUI({super.key, required this.expenseId,required this.vehicleName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) =>
          ExpenseBloc(listenBroadcast: false)..add(GetVehicleExpenseEditData(id: expenseId)),
      child: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
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
                              .read<ExpenseBloc>()
                              .add(DeleteExpenseEvent(id: expenseId,isEditPage: true));
                          Future.delayed(
                            const Duration(seconds: 1),
                            () => context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 4, message: '',)),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppC.white,
                      )),
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
                              onTap: () => context
                                  .read<ExpenseBloc>()
                                  .add(PickImageEvent()),
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
                                        color: AppC.blue,
                                        weight: FontWeight.bold),
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
                      10.height,
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
                                        minWidth:
                                            MediaQuery.sizeOf(context).width,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color:
                                              AppC.grey.withValues(alpha: 0.2)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: ImageViewer(
                                        fit: BoxFit.cover,
                                        imageInput:
                                            state.expenseAttachments[index],
                                        isNotImage:
                                            !((state.expenseAttachments[index]
                                                    as Object)
                                                .isImage),
                                      ),
                                    ),
                                    if ((state.expenseAttachments[index]
                                            as Object)
                                        .isPDF)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppC.green,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Utils.openURL(state
                                                .expenseAttachments[index]);
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
                        controller:
                            context.read<ExpenseBloc>().vehicleController,
                      ),
                      10.height,
                      Row(
                        spacing: 10,
                        children: [
                          if(state.splitExpense.isEmpty)
                          Expanded(
                            child: Utils.getTextFormField(
                              'Amount in dollars',
                              context.read<ExpenseBloc>().amountController,
                              textType: TextInputType.numberWithOptions(decimal: true),
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
                              (value) => context.read<ExpenseBloc>().add(
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
                        context.read<ExpenseBloc>().descriptionController,
                        inputAction: TextInputAction.done,
                      ),
                      10.height,
                      Utils.dropdownBox(
                        'Select Category',
                        state.categories,
                        (value) => context
                            .read<ExpenseBloc>()
                            .add(CategoryListEvent(selectedCategory: value)),
                        labelKey: 'name',
                        initialSelection: state.selectedCategory,
                      ),
                      10.height,
                      Utils.dropdownBox(
                          'Select Sub Category',
                          state.subCategories,
                          (value) => context.read<ExpenseBloc>().add(
                              SubCategoryListEvent(selectedSubCategory: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedSubCategory,
                          initialSelection: state.selectedSubCategory),
                      10.height,
                      Utils.dropdownBox(
                        'Select Expense To',
                        state.cohorts,
                        (value) => context.read<ExpenseBloc>().add(
                            CohortListEvent(selectedCohort: value)),
                        labelKey: 'name',
                        selectedKey: state.selectedCohorts,
                        initialSelection: state.selectedCohorts,
                      ),
                      10.height,
                      CustomDateTimePicker<DateTime>(
                        controller: context.read<ExpenseBloc>().dateController,
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
                      Utils.getElevatedButton(() {
                        if(state.selectedVehicle.isEmpty) {
                          return Toaster.showError("Please select vehicle");
                        }
                        if(context.read<ExpenseBloc>().amountController.text.isEmpty) {
                          return Toaster.showError("Please enter amount");
                        }
                        if(state.selectedCategory.isEmpty) {
                          return Toaster.showError("Please select category");
                        }
                        if(state.subCategories.isNotEmpty && state.selectedSubCategory.isEmpty) {
                          return Toaster.showError("Please select subCategory");
                        }
                        if(state.selectedCohorts.isEmpty) {
                          return Toaster.showError("Please select subCategory");
                        }
                        context.read<ExpenseBloc>().add(const UpdateExpenseEvent());
                        Future.delayed(const Duration(seconds: 1),
                          () => context.pop(),
                        );
                      }),
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
