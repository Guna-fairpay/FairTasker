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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PersonExpenseAddUI extends StatelessWidget {
  const PersonExpenseAddUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonExpenseBloc>(
      create: (context) =>
          PersonExpenseBloc()..add(const GetPersonExpenseAddData()),
      child: BlocListener<PersonExpenseBloc, PersonExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
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
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close))
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
                              "Select Person", [], (value) {},
                              labelKey: '')),
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
                              "Select Category", [], (value) {},
                              labelKey: '')),
                      Expanded(
                          child: Utils.dropdownBox(
                              "Select Sub Category", [], (value) {},
                              labelKey: '')),
                    ],
                  ),
                  15.height,
                  Row(
                    children: [
                      Expanded(
                          child: Utils.dropdownBox(
                              "Select Expense To", [], (value) {},
                              labelKey: '')),
                      20.width,
                      Expanded(
                          child: Utils.getTextFormField(
                        "Expense Amount",
                        context.read<PersonExpenseBloc>().amountController,
                      )),
                    ],
                  ),
                  15.height,
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                          child: Utils.dropdownBox(
                              "Select Payment Type", [], (value) {},
                              labelKey: '')),
                      Expanded(
                          child: Utils.dropdownBox(
                              "Select Person", [], (value) {},
                              labelKey: '')),
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
                  Utils.getElevatedButton(() {})
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
