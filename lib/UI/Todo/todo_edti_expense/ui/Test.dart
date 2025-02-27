
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
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
import 'package:provider/provider.dart';

class TodoExpense extends StatelessWidget {
  final dynamic expenseId;
  const TodoExpense({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoEditExpenseBloc>(
      create: (context) => TodoEditExpenseBloc()..add(GetTodoExpenseInitialEvent(expenseId: expenseId)),
      child: BlocListener<TodoEditExpenseBloc, TodoExpenseState>(
          listener: (context, state) {
        state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
      }, child: BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
              builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // spacing: 10,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getText(
              'Expense Summary',
              size: 12,
              color: AppC().base,
              align: TextAlign.end,
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.read<TodoEditExpenseBloc>().add(PickImageEvent()),
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
                          Utils.getText('Upload', color: AppC.blue,weight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.read<TodoEditExpenseBloc>().add(CaptureImageEvent()),
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
                          Utils.getText('Capture', color: AppC.redAccent,weight: FontWeight.bold),
                        ],
                      ),
                    ),
                  ),
                ),
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
                          Utils.getText('Invoice', color: AppC.blue, weight: FontWeight.bold),
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
                            currentAttachment:state.expenseAttachments[index]);
                      },
                      onTapDelete: () {
                        state.expenseAttachments.remove(index);},
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.sizeOf(context).height,
                          minWidth: MediaQuery.sizeOf(context).width,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppC.grey.withValues(alpha: 0.2)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child:  ImageViewer(
                          fit: BoxFit.cover,
                          imageInput: state.expenseAttachments[index],
                          isNotImage:
                          !((state.expenseAttachments[index] as Object).isImage),
                        ),
                      )),
                ),
              ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Utils.getTextFormField(
                    'Amount in dollars',
                    textType: TextInputType.number,
                    context.read<TodoEditExpenseBloc>().amountController ,
                  ),
                ),
                Expanded(
                  child: Utils.dropdownBox(
                      'Select Payment Method',
                      state.paymentMethods,
                          (selectedValue) {
                          //state.selectedPayment = selectedValue;
                      },
                      selectedKey:  state.selectedPayment,
                      initialSelection:  state.selectedPayment,
                      labelKey: 'name'),
                ),
              ],
            ),
            Utils.getTextFormField(
              'Enter Description',
              context.read<TodoEditExpenseBloc>().descriptionController,
              inputAction: TextInputAction.done,
            ),
            Row(
              children: [
                Expanded(child: Utils.getText('-Part name-')),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    hintText: 'enter a amount',
                    context.read<TodoEditExpenseBloc>().partsCostController,
                    textType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getText('Labour')),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    hintText: 'enter a amount',
                    context.read<TodoEditExpenseBloc>().labourCostController,
                    textType: TextInputType.number,
                    inputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getText('Sub Total')),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    context.watch<TodoEditExpenseBloc>().subTotalController,
                    textType: TextInputType.number,
                    readOnly: true,
                      fillColor: Colors.grey.shade200,
                      borderWidth: 0.4
                  ),
                ),
              ],
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utils.getText('Sales Tax'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<TodoEditExpenseBloc>().add(TaxIconEvent());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppC.grey,
                                  width: 0.5
                                ),
                              ),
                              child: context.watch<TodoEditExpenseBloc>().taxIsTapped
                                  ? const Icon(Icons.monetization_on_outlined, color: AppC.grey,size: 20,)
                                  : const Icon(Icons.percent,color: AppC.grey,size: 20,),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Utils.getTextFormField('',
                              maxLength: 20,
                              context.watch<TodoEditExpenseBloc>().percentageOrAmountController,
                              inputAction: TextInputAction.done,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                              textType: TextInputType.number,
                                textAlign: TextAlign.center
                            ),
                          ),
                          Spacer(flex: 1,),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    readOnly: true,
                    context.watch<TodoEditExpenseBloc>().saleTaxController,
                      fillColor: Colors.grey.shade200,
                      borderWidth: 0.4
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getText('Shipping & Handling')),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    hintText: 'enter a amount',
                    context.read<TodoEditExpenseBloc>().shippingController,
                    textType: TextInputType.number,
                    inputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getText('Total')),
                const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    context.watch<TodoEditExpenseBloc>().totalAmountController,
                    readOnly: true,
                      fillColor: Colors.grey.shade200,
                    borderWidth: 0.4
                  ),
                ),
              ],
            ),
            Utils.dropdownBox(
                'Select Category',
                state.mainCategories,
                    (selectedValue) {
                 // state.selectedPayment = selectedValue;
                },
                selectedKey:  state.selectedMainCategory,
                initialSelection:  state.selectedMainCategory,
                labelKey: 'name'),
            Utils.dropdownBox(
                'Select SubCategory',
                state.subCategories,
                    (selectedValue) {
                  //state.selectedPayment = selectedValue;
                },
                selectedKey:  state.selectedSubCategory,
                initialSelection:  state.selectedSubCategory,
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
