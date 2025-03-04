
import 'package:fairpytasker/UI/Todo/todo_edti_expense/ui/split_expense_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/close_badge.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/todo_edit_expense_bloc.dart';
import '../event/todo_edit_expense_event.dart';
import '../state/todo_edit_expense_state.dart';
import 'invoice_preview_dialog.dart';

class TodoExpense extends StatelessWidget {
  final dynamic expenseId;
  final dynamic todoItem;
  const TodoExpense({super.key, required this.expenseId,required this.todoItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoEditExpenseBloc>(
      create: (context) => TodoEditExpenseBloc()
        ..add(GetTodoExpenseInitialEvent(expenseId: expenseId, todoItem: todoItem)),
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
            if(state.vehicleList.length <= 1)
            Utils.getText(
              'Expense Summary - ${state.vehicleName}',
              color: AppC().base,
              align: TextAlign.end,
            ),
            if(state.vehicleList.length > 1)
            Utils.dropdownBox(
              'Select Vehicle',
              state.vehicleList,
              (selectedValue) {
                context.read<TodoEditExpenseBloc>().add(SelectedVehicleEvent( vehicleName: selectedValue));
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
                if(state.vendorList.isNotEmpty)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context.read<TodoEditExpenseBloc>().add(InvoiceEvent());
                      var blo = context.read<TodoEditExpenseBloc>();
                      showDialog(
                        context: context,
                        builder: (context) => InvoiceDialog(bloc: blo),
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
                        context.read<TodoEditExpenseBloc>().add(
                            RemoveImageEvent(
                                data: state.expenseAttachments[index]));
                      },
                      child: Container(
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
                      )),
                ),
              ),
            Row(
              spacing: 10,
              children: [
                if(state. partsList.isEmpty && state.suppliesList.isEmpty)
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
            if(state. partsList.isNotEmpty || state.suppliesList.isNotEmpty)
              const SplitExpenseUI(),
            Utils.dropdownBox(
                'Select Category',
                state.mainCategories,
                (selectedValue) {
                  context.read<TodoEditExpenseBloc>().add(
                      CategoryListEvent(mainCategory: selectedValue));
                },
                selectedKey: state.selectedMainCategory,
                initialSelection: state.selectedMainCategory,
                labelKey: 'name'),
            Utils.dropdownBox(
                'Select SubCategory',
                state.subCategories,
                (selectedValue) {
                  context.read<TodoEditExpenseBloc>().add(
                      SubCategoryListEvent(subCategory: selectedValue));
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
                    // _saveExpense();
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
