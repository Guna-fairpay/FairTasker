import 'package:fairpytasker/Utilities/Utils.dart';
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

class TotoExpense extends StatelessWidget {
  final dynamic expenseId;
  const TotoExpense({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoEditExpenseBloc>(
      create: (context) => TodoEditExpenseBloc()..add(GetTodoExpenseInitialEvent(expenseId: expenseId)),
      child: BlocListener<TodoEditExpenseBloc, TodoExpenseState>(
          listener: (context, state) {
        state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
      }, child: BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
              builder: (context, state) {
        return Stack(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Utils.getText('Upload', color: AppC.blue),
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
                                  Utils.getText('Capture', color: AppC.redAccent),
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
                                state.expenseAttachments.remove(index);                              },
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
                            context.read<TodoEditExpenseBloc>().amountTextController ,
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
                      context.read<TodoEditExpenseBloc>().descriptionTextController,
                    ),
                    Utils.dropdownBox(
                        'Select Category',
                        state.mainCategories,
                            (selectedValue) {
                          //state.selectedPayment = selectedValue;
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
                      '',
                      context.read<TodoEditExpenseBloc>().odometerTextController,
                      textType: TextInputType.number,
                      contentPadding: const EdgeInsets.only(left: 10, right: 40),
                      label: Utils.getText('Odometer', color: AppC.grey),
                      suffixIcon: const Icon(
                        Icons.speed,
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Utils.getAddFilledButton(
                          'Save',
                              () {
                           // _saveExpense();
                          },
                          bgColor: AppC.green,
                        ),
                        Utils.getAddFilledButton(
                          'Save Category',
                              () {
                            // _save();
                          },
                          bgColor: AppC.green,
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      })),
    );
  }
}
