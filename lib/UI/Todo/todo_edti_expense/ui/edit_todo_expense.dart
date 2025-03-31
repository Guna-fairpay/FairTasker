
import 'dart:io';
import 'package:fairpytasker/UI/Todo/todo_edti_expense/ui/split_expense_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/close_badge.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import '../../../Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/todo_edit_expense_bloc.dart';
import '../event/todo_edit_expense_event.dart';
import '../state/todo_edit_expense_state.dart';
import 'invoice_preview_dialog.dart';

class TodoExpense extends StatelessWidget {
  final dynamic expenseId;
  final dynamic todoItem;
  final List<dynamic> selectedParts;
  final List<dynamic> selectedSupplies;
  final dynamic selectedVendor;

  const TodoExpense(
      {super.key,
      required this.expenseId,
      required this.todoItem,
      required this.selectedParts,
      required this.selectedSupplies,
      required this.selectedVendor});

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
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            if (state.vehicleList.length == 1)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleExpenseHistoryUI(
                                    vin: state.vehicleList.firstOrNull['vin'],
                                    vehicleName: state
                                        .vehicleList.firstOrNull['vehicle_name'],
                                showTotalAmount: false,
                                  )
                          )
                      );
                    },
                    child: Utils.getText(
                      'Expense Summary - ${state.vehicleList.firstOrNull['vehicle_name']}',
                      color: AppC().base,
                      align: TextAlign.end,
                    ),
                  ),
                ],
              ),
            if (state.vehicleList.length > 1)
              Utils.dropdownBox(
                'Select Vehicle',
                state.vehicleList,
                (selectedValue) {
                  context.read<TodoEditExpenseBloc>().add(
                      SelectedVehicleEvent(selectedVehicle: selectedValue));
                },
                labelKey: 'vehicle_name',
              ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context
                        .read<TodoEditExpenseBloc>()
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
                              color: AppC.blue, weight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context
                        .read<TodoEditExpenseBloc>()
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
                              color: AppC.redAccent, weight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.vendorList.isNotEmpty)
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        context.read<TodoEditExpenseBloc>().add(InvoiceEvent());
                        await Future.delayed(const Duration(seconds: 1));
                        var blo = context.read<TodoEditExpenseBloc>();
                        InvoiceDialog.show(
                          context,
                          invoiceData: blo.invoiceData,
                          onGenerate: () => blo.add(GenerateInvoiceEvent()),
                        );
                      },
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
                            const Icon(Icons.receipt_long, color: AppC.blue),
                            const SizedBox(width: 5),
                            Utils.getText('Invoice',
                                color: AppC.blue, weight: FontWeight.bold),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, mainAxisSpacing: 10),
                  itemBuilder: (context, index) => CloseBadge(
                      onTapView: () {
                        ShowAttachmentsDialog.of.show(context,
                            attachments: state.expenseAttachments,
                            title: "",
                            currentAttachment: state.expenseAttachments[index]);
                      },
                      onTapDelete: () {
                        AskPermissionDialog.show(context,
                            title: "Are you sure?",
                            description: "Do you want to delete this Expense Image?",
                            positiveText: "Yes, delete it!",
                            negativeText: "Cancel",
                            isReasonRequired: false,
                            onPositivePressed: () =>
                                context.read<TodoEditExpenseBloc>().add(
                                    RemoveImageEvent(
                                        data: state.expenseAttachments[index])));
                      },
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.sizeOf(context).height,
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
                                  !((state.expenseAttachments[index] as Object)
                                      .isImage),
                            ),
                          ),
                          if ((state.expenseAttachments[index] as Object).isPDF)
                          Container(
                            decoration: BoxDecoration(
                              color: AppC.green,
                              borderRadius: BorderRadius.circular(16),

                            ),
                            child: InkWell(
                              onTap: () {
                                var data = (state.expenseAttachments[index] is File) ? (state.expenseAttachments[index] as File).path : state.expenseAttachments[index];
                                Console.of.log(data);
                                Utils.openURL(data, isFile: (state.expenseAttachments[index] is File));
                              },child:Padding(
                              padding: 4.padding,
                              child: const Icon(Icons.remove_red_eye_outlined,color: AppC.white,size: 15,),
                            ),),
                          ),
                        ],
                      )),
                ),
              ),
            Row(
              spacing: 10,
              children: [
                if (state.partsList.isEmpty && state.suppliesList.isEmpty)
                  Expanded(
                    child: Utils.getTextFormField(
                      'Amount in dollars',
                      textType: TextInputType.number,
                      context.read<TodoEditExpenseBloc>().amountController,
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
              const SplitExpenseUI(),
            Utils.dropdownBox('Select Category', state.mainCategories,
                (selectedValue) {
              context
                  .read<TodoEditExpenseBloc>()
                  .add(CategoryListEvent(mainCategory: selectedValue));
              Future.microtask(() => Utils.dismissKeyboard(context));
            },
                selectedKey: state.selectedMainCategory,
                initialSelection: state.selectedMainCategory,
                labelKey: 'name'),
            Utils.dropdownBox(
                'Select SubCategory',
                state.subCategories,
                (selectedValue) {
              context
                  .read<TodoEditExpenseBloc>()
                  .add(SubCategoryListEvent(subCategory: selectedValue));
              Future.microtask(() => Utils.dismissKeyboard(context));
            },
                selectedKey: state.selectedSubCategory,
                initialSelection: state.selectedSubCategory,
                labelKey: 'name'),
            Utils.getTextFormField(
              'Odometer',
              context.read<TodoEditExpenseBloc>().odometerController,
              textType: TextInputType.number,
              suffixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(
                  Icons.speed,
                  color: Colors.red,
                ),
              ),
              inputAction: TextInputAction.done,
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Utils.getElevatedButton(
                  () {
                    if((state.partsList.isEmpty && state.suppliesList.isEmpty) && context.read<TodoEditExpenseBloc>().amountController.text.isEmpty) {
                      return Toaster.showError("Please enter amount");
                    }
                    if(state.selectedMainCategory.isEmpty) {
                      return Toaster.showError("Please select category");
                    }
                    if(/*state.subCategories.isNotEmpty && */state.selectedSubCategory.isEmpty) {
                      return Toaster.showError("Please select subCategory");
                    }
                    context.read<TodoEditExpenseBloc>().add(const SaveExpenseEvent());
                    },
                ),
                Utils.getElevatedButton(
                  () {
                    // _save();
                  },
                  text: 'Save Category',
                  bgColor: AppC.green,
                ),
              ],
            ),
          ],
        );
      })),
    );
  }
}
