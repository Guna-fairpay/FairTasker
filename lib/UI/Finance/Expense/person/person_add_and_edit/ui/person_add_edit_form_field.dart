part of 'person_add_edit_main_ui.dart';

class PersonAddEditFormField extends StatelessWidget {
  const PersonAddEditFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonAddEditBloc, PersonAddEditState>(
      builder: (context, state) => Scaffold(
        appBar: CompactAppBar(
          titleText: context.read<PersonAddEditBloc>().isEdit ? 'Edit Person' : 'Add Person',
          foregroundColour: AppC.white,
          onClose: context.pop,
          actionWidgets: [
            (context.read<PersonAddEditBloc>().isEdit) ?
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent),
              onPressed: (){
                AskPermissionDialog.show(context,
                    title: "Are you sure?",
                    description: "Do you want to delete this Expense?",
                    positiveText: "Yes, delete it!",
                    negativeText: "Cancel",
                    isReasonRequired: false,
                    onPositivePressed: () => context.read<PersonAddEditBloc>().add(DeleteEvent()));
              },
            )
            : const SizedBox.shrink(),
            IconButton(
              icon: const Icon(Icons.close, color: AppC.white),
              onPressed: ()=> context.pop(),
            )

          ],
        ),
        body: Form(
          key: context.read<PersonAddEditBloc>().formKey,
          child: SafeArea(
            minimum: 15.spMin.padding,
              child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Expanded(
                      child: Utils.dropdownBox(
                          'Select Person',
                          context.read<PersonAddEditBloc>().persons,
                              (value) => context.read<PersonAddEditBloc>().add(SelectPersonEvent(value)),
                      labelKey: 'first_name',
                        labelKey2: 'last_name',
                        initialSelection: context.read<PersonAddEditBloc>().selectedPerson,
                        validator: (value) => value == null ? "Select Person" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      )
                  ),
                  Expanded(
                    child: CustomDateTimePicker<DateTime>(
                      controller:
                      context.read<PersonAddEditBloc>().dateController,
                      format: "dd-MM-yyyy",
                      suffixIcon: Icon(Icons.calendar_month_rounded,
                          size: 18.spMin, color: context.theme.hintColor),
                      textAlign: TextAlign.center,
                      value: context.read<PersonAddEditBloc>().selectedDate,
                      onChanged: (value) => context
                          .read<PersonAddEditBloc>()
                          .add(SelectDateEvent(value)),
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
                        context.read<PersonAddEditBloc>().categories,
                            (value) => context.read<PersonAddEditBloc>().add(
                            SelectCategoryEvent(value)),
                        labelKey: 'name',
                        initialSelection: context.watch<PersonAddEditBloc>().selectedCategory,
                        validator: (value) => value == null ? "Select Category" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      )),
                  Expanded(
                      child: Utils.dropdownBox(
                        "Select Sub Category",
                        context.read<PersonAddEditBloc>().subCategories,
                            (value) => context.read<PersonAddEditBloc>().add(SelectSubCategoryEvent(value)),
                        labelKey: 'name',
                        initialSelection: context.watch<PersonAddEditBloc>().selectedSubCategory,
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
                        "Select Expense To",
                        context.read<PersonAddEditBloc>().expenseTo,
                            (value) => context.read<PersonAddEditBloc>().add(
                                ExpenseToEvent(value)),
                        labelKey: 'name',
                        initialSelection: context.watch<PersonAddEditBloc>().selectedExpenseTo,
                      )),
                  Expanded(
                    child: Utils.getTextFormField(
                      "Expense Amount",
                      context.read<PersonAddEditBloc>().amountController,
                      textType: const TextInputType.numberWithOptions(decimal: true),
                      inputAction: TextInputAction.done,
                      textInputFormatter:[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      validator: (value) =>(value!.isEmpty) ? "Enter Expense Amount" : null,
                      autoValidate: context.watch<PersonAddEditBloc>().autoValidateMode,
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
                        "Select Payment Type",
                        context.read<PersonAddEditBloc>().paymentType,
                            (value) => context.read<PersonAddEditBloc>().add(
                            SelectPaymentEvent(value)),
                        labelKey: 'name',
                        initialSelection: context.watch<PersonAddEditBloc>().selectedPaymentType,
                      )),
                  Expanded(
                      child: Utils.dropdownBox(
                        "Select Approved Status",
                        context.read<PersonAddEditBloc>().approved,
                            (value) => context.read<PersonAddEditBloc>().add(
                            ApproveEvent(value)),
                        labelKey: 'name',
                        initialSelection: context.watch<PersonAddEditBloc>().selectedApproved,
                        validator: (value) => value == null ? "Select Approved Status" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      )
                  ),
                ],
              ),
              15.spMin.height,
              Utils.getTextFormField("Description",
                  context.read<PersonAddEditBloc>().descriptionController),
              15.spMin.height,
              ImageUploadSection(
                title: 'Upload',
                onUpload: ()=> context.read<PersonAddEditBloc>().add(PickImageEvent()),
                borderColor: Colors.blue,
                onRemove: (file)=> context.read<PersonAddEditBloc>().add(RemoveImageEvent(data: file)),
                images: context.read<PersonAddEditBloc>().attachments,
                logName: "expenseAttachmentsEvent",
                isRequired: true,
              ),
              SuccessButton(
                text: (context.watch<PersonAddEditBloc>().isEdit) ? 'Update' : 'Save',
                onPressed: ()=> context.read<PersonAddEditBloc>().add(SaveEvent()),
              ),
            ],
          )),
        ),
      )
    );
  }
}
