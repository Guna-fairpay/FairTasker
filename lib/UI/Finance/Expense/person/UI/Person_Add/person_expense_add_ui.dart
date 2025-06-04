import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/person_expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/persion_expense_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PersonExpenseAddUI extends StatelessWidget {
  final VoidCallback? onAdd;
  const PersonExpenseAddUI({super.key, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonExpenseBloc>(
      create: (context) =>
          PersonExpenseBloc()..add(const GetPersonExpenseAddData()),
      child: BlocListener<PersonExpenseBloc, PersonExpenseState>(
        listener: (_, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if(state.popAddPage) {
            // context.read<PersonExpenseBloc>().close();
            // FBroadcast.instance().broadcast("expense_person_refresh");
            context.pop();
            // onAdd?.call();
          }
        },
        child: BlocBuilder<PersonExpenseBloc, PersonExpenseState>(
            builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Person Expense '),
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              backgroundColor: AppC.appColor,
              actions: [
                IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close))
              ],
            ),
            body: SafeArea(
              minimum: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Form(
                key: context.read<PersonExpenseBloc>().formKey,
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Expanded(
                            child: Utils.dropdownBox(
                                "Select Person",
                                state.persons,
                                (value) => context.read<PersonExpenseBloc>().add(
                                    PersonDropDownEvent(selectedPerson: value)),
                                labelKey: 'first_name',
                                labelKey2: 'last_name',
                              validator: (value) => value == null ? "Select Person" : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Expanded(
                            child: Utils.dropdownBox(
                                "Select Category",
                                state.categories,
                                (value) => context.read<PersonExpenseBloc>().add(
                                    CategoryDropDownEvent(
                                        selectedCategory: value)),
                                labelKey: 'name',
                                initialSelection: state.selectedCategory,
                                validator: (value) => value == null ? "Select Category" : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                            )),
                        Expanded(
                            child: Utils.dropdownBox(
                                "Select Sub Category",
                                state.subCategories,
                                (value) => context.read<PersonExpenseBloc>().add(
                                    SubCategoryDropDownEvent(
                                        selectedSubCategory: value)),
                                labelKey: 'name',
                                initialSelection: state.selectedSubCategory,
                                validator: (value) => value == null ? "Select Sub Category" : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                            )),
                      ],
                    ),
                    15.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Utils.dropdownBox(
                          "Select Expense To",
                          state.cohorts,
                          (value) => context
                              .read<PersonExpenseBloc>()
                              .add(CohortDropDownEvent(selectedCohort: value)),
                          labelKey: 'name',
                          initialSelection: state.selectedCohorts,
                        )),
                        20.width,
                        Expanded(
                            child: Utils.getTextFormField(
                          "Expense Amount",
                          context.read<PersonExpenseBloc>().amountController,
                              textType: const TextInputType.numberWithOptions(decimal: true),
                              inputAction: TextInputAction.done,
                              textInputFormatter:[
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              validator: (value) =>(value!.isEmpty) ? "Enter Expense Amount" : null,
                              autoValidate: context.watch<PersonExpenseBloc>().autoValidateMode,
                        )),
                      ],
                    ),
                    15.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Expanded(
                            child: Utils.dropdownBox(
                                "Select Payment Type",
                                state.paymentType,
                                (value) => context.read<PersonExpenseBloc>().add(
                                    PaymentDropDownEvent(paymentType: value)),
                                labelKey: 'name')),
                        Expanded(
                            child: Utils.dropdownBox(
                                "Select Approved Status",
                                state.approved,
                                (value) => context.read<PersonExpenseBloc>().add(
                                    ApprovedDropDownEvent(
                                        selectedApproved: value)),
                                labelKey: 'name',
                                initialSelection: state.selectedApproved,
                                validator: (value) => value == null ? "Select Approved Status" : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                            data: state.expenseAttachments[index])));
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
                    SuccessButton(text: 'save', onPressed: () => context.read<PersonExpenseBloc>().add(const SavePersonExpenseEvent()),)
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
