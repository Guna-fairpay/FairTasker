
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bloc/person_expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/persion_expense_state.dart';
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

class PersonExpenseEditUI extends StatelessWidget {
  final String id;
  const PersonExpenseEditUI({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonExpenseBloc>(
      create: (context) => PersonExpenseBloc()..add(GetPersonExpenseEditData(id:id)),
      child: BlocListener<PersonExpenseBloc, PersonExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if(state.popAddPage){
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<PersonExpenseBloc, PersonExpenseState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Person Expense '),
                  foregroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppC.appColor,
                  actions: [
                    IconButton(
                        onPressed: () {
                          AskPermissionDialog.show(context,
                              title: "Are you sure?",
                              description: "Do you want to delete this Expense?",
                              positiveText: "Yes, delete it!",
                              negativeText: "Cancel",
                              isReasonRequired: false,
                              onPositivePressed: () {
                                context
                                    .read<PersonExpenseBloc>()
                                    .add(DeletePersonExpenseEvent(id: id,isEditPage: true));
                                // Future.delayed(
                                //   const Duration(seconds: 1),
                                //       () => context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 4, message: '',)),
                                // );
                              });
                        },
                        icon: Icon(Icons.delete_outline)
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close)
                    ),
                  ],
                ),
                body: SafeArea(
                  minimum: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: ListView(
                    children: [
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                              child: Utils.dropdownBox(
                                  "Select Person",
                                  state.persons,
                                      (value) =>context.read<PersonExpenseBloc>().add(PersonDropDownEvent(selectedPerson: value)),
                                  labelKey: 'first_name',
                                  labelKey2: 'last_name',
                                initialSelection: state.selectedPerson,
                              )),
                          Expanded(
                            child: CustomDateTimePicker<DateTime>(
                              controller:
                              context.read<PersonExpenseBloc>().dateController,
                              format: "dd-MM-yyyy",
                              suffixIcon: Icon(Icons.calendar_month_rounded,
                                  size: 18, color: context.theme.hintColor),
                              textAlign: TextAlign.center,
                              value: state.selectedDate,
                              onChanged: (value) => context
                                  .read<PersonExpenseBloc>()
                                  .add(DateChangeEvent(selectedDate: value)),
                            ),
                          ),
                        ],
                      ),
                      15.height,
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                              child: Utils.dropdownBox(
                                  "Select Category",
                                  state.categories,
                                      (value) =>context.read<PersonExpenseBloc>().add(CategoryDropDownEvent(selectedCategory: value)),
                                  labelKey: 'name',
                                initialSelection: state.selectedCategory,
                              )),
                          Expanded(
                              child: Utils.dropdownBox("Select Sub Category",
                                  state.subCategories,
                                      (value) =>context.read<PersonExpenseBloc>().add(SubCategoryDropDownEvent(selectedSubCategory: value)),
                                  labelKey: 'name',
                                initialSelection: state.selectedSubCategory,
                              )),
                        ],
                      ),
                      15.height,
                      Row(
                        children: [
                          Expanded(
                              child: Utils.dropdownBox(
                                "Select Expense To",
                                state.cohorts,
                                    (value) =>context.read<PersonExpenseBloc>().add(CohortDropDownEvent(selectedCohort: value)),
                                labelKey: 'name',
                                initialSelection: state.selectedCohorts,

                              )),
                          20.width,
                          Expanded(
                              child: Utils.getTextFormField(
                                "Expense Amount",
                                context.read<PersonExpenseBloc>().amountController,
                                textType: TextInputType.numberWithOptions(decimal: true),
                                inputAction: TextInputAction.done,
                                textInputFormatter:[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                                ],
                              )),
                        ],
                      ),
                      15.height,
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                              child: Utils.dropdownBox("Select Payment Type",
                                  state.paymentType,
                                      (value) =>context.read<PersonExpenseBloc>().add(PaymentDropDownEvent(paymentType: value)),
                                  labelKey: 'name',
                                initialSelection: state.selectedPaymentType
                              )),
                          Expanded(
                              child: Utils.dropdownBox("Select Approved Status",
                                  state.approved,
                                      (value) =>context.read<PersonExpenseBloc>().add(ApprovedDropDownEvent(selectedApproved: value)),
                                  labelKey: 'name',
                                initialSelection: state.selectedApproved
                              )),
                        ],
                      ),
                      20.height,
                      Utils.getTextFormField("Description",
                          context.read<PersonExpenseBloc>().descriptionController),
                      15.height,
                      GestureDetector(
                        onTap: () =>
                            context.read<PersonExpenseBloc>().add(PickImageEvent()),
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
                                          .read<PersonExpenseBloc>()
                                          .add(RemoveImageEvent(
                                          data: state
                                              .expenseAttachments[index])));
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
                                    isNotImage: !((state.expenseAttachments[index]
                                    as Object)
                                        .isImage),
                                  ),
                                )),
                          ),
                        ),
                      15.height,
                      Utils.getElevatedButton((){
                        if (state.selectedPerson.isEmpty) {
                          return Toaster.showError("Please select person");
                        }
                        if (state.selectedCategory.isEmpty) {
                          return Toaster.showError("Please select category");
                        }
                        if (state.selectedSubCategory.isEmpty) {
                          return Toaster.showError("Please select subCategory");
                        }
                        if (state.selectedCohorts.isEmpty) {
                          return Toaster.showError("Please select expenseTo");
                        }
                        if (context.read<PersonExpenseBloc>().amountController.text.isEmpty) {
                          return Toaster.showError("Please enter amount");
                        }
                        if (state.selectedPaymentType.isEmpty) {
                          return Toaster.showError("Please select payment type");
                        }
                        if (state.selectedApproved.isEmpty) {
                          return Toaster.showError("Please select approved status");
                        }
                        context.read<PersonExpenseBloc>().add(SavePersonExpenseEvent(id: id));})
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
