part of 'private_rental_customers.dart';

class AddEditForm extends StatelessWidget {
  const AddEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentalCustomerBloc, State>(builder: (context, state) => Form(
        key: context.read<RentalCustomerBloc>().formKey,
        child: Column(
          spacing: 10.spMin,
          children: [
            CompactTextField(
              hintText: "First Name",
              controller: context.read<RentalCustomerBloc>().firstNameController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
              textInputAction: TextInputAction.next,
            ),
            CompactTextField(
              hintText: "Last Name",
              controller: context.read<RentalCustomerBloc>().lastNameController,
              textInputAction: TextInputAction.next,
            ),
            CompactTextField(
              hintText: "Phone",
              controller: context.read<RentalCustomerBloc>().phoneController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
              textInputAction: TextInputAction.next,
            ),
            CompactTextField(
              hintText: "Address",
              controller: context.read<RentalCustomerBloc>().addressController,
              textInputAction: TextInputAction.next,
            ),
            CompactTextField(
              hintText: "Monthly Rental",
              controller: context.read<RentalCustomerBloc>().monthlyRentalController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
              textInputAction: TextInputAction.done,
            ),
            CustomDateTimePicker<DateTime>(
              labelText: "dd-mm-yyyy",
              format: "dd-MM-yyyy",
              value: context.watch<RentalCustomerBloc>().rentalDate,
              validator: (value) => (value == null) ? "Required" : null,
              controller: context.read<RentalCustomerBloc>().rentalDateController,
              onChanged: (value) => context.read<RentalCustomerBloc>().add(RentalDateEvent(value)),
            ),
            CompactTextField(
              hintText: "Security Deposit",
              controller: context.read<RentalCustomerBloc>().securityDepositController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
              textInputAction: TextInputAction.next,
            ),
            CompactTextField(
              hintText: "Notes",
              controller: context.read<RentalCustomerBloc>().notesController,
              textInputAction: TextInputAction.done,
            ),
            CompactFilePicker(
              pickerName: "Upload License",
              controller: context.read<RentalCustomerBloc>().licenseController,
              onPressed: () => context.read<RentalCustomerBloc>().add(PickLicenseEvent()),
            ),
            if (context.watch<RentalCustomerBloc>().licenseAttachments.isNotEmpty)
              AttachmentLister(attachments: context.watch<RentalCustomerBloc>().licenseAttachments,
                onDelete: (value) => context.read<RentalCustomerBloc>().add(DeleteLicenseEvent(value))),
            CompactFilePicker(
              pickerName: "Upload Insurance",
              controller: context.read<RentalCustomerBloc>().insuranceController,
              onPressed: () => context.read<RentalCustomerBloc>().add(PickInsuranceEvent()),
            ),
            if (context.watch<RentalCustomerBloc>().insuranceAttachments.isNotEmpty)
              AttachmentLister(attachments: context.watch<RentalCustomerBloc>().insuranceAttachments,
              onDelete: (value) => context.read<RentalCustomerBloc>().add(DeleteInsuranceEvent(value))),
            Row(
              spacing: 10.spMin,
              children: [
                SuccessButton(
                  text: (context.watch<RentalCustomerBloc>().isEditing) ? "Update" : "Save",
                  onPressed: () => context.read<RentalCustomerBloc>().add(SubmitEvent()),
                ),
                if (context.watch<RentalCustomerBloc>().isEditing)
                SuccessButton(
                  text: "Cancel",
                  backgroundColor: AppC.redAccent,
                  onPressed: () => context.read<RentalCustomerBloc>().add(CancelEditEvent()),
                ),
                Expanded(child: CompactSearchView(
                  hintText: "Search",
                  controller: context.read<RentalCustomerBloc>().searchController,
                  onChanged: (value) => context.read<RentalCustomerBloc>().add(SearchEvent(value)),
                ))
              ],
            )
          ],
        )));
  }
}
