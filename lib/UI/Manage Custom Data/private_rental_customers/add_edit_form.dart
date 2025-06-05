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
            ),
            CompactTextField(
              hintText: "Last Name",
              controller: context.read<RentalCustomerBloc>().lastNameController,
            ),
            CompactTextField(
              hintText: "Phone",
              controller: context.read<RentalCustomerBloc>().phoneController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
            ),
            CompactTextField(
              hintText: "Address",
              controller: context.read<RentalCustomerBloc>().addressController,
            ),
            CompactTextField(
              hintText: "Monthly Rental",
              controller: context.read<RentalCustomerBloc>().monthlyRentalController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
            ),
            CustomDateTimePicker<DateTime>(
              controller: context.read<RentalCustomerBloc>().rentalDateController,
              labelText: "dd-mm-yyyy",
              validator: (value) => (value == null) ? "Required" : null,
            ),
            CompactTextField(
              hintText: "Security Deposit",
              controller: context.read<RentalCustomerBloc>().securityDepositController,
              validator: (value) => value.isNullOrEmpty ? "Required" : null,
            ),
            CompactTextField(
              hintText: "Notes",
              controller: context.read<RentalCustomerBloc>().notesController,
            ),
            CompactFilePicker(
              controller: context.read<RentalCustomerBloc>().licenseController,
            ),
            CompactFilePicker(
              controller: context.read<RentalCustomerBloc>().insuranceController,
            ),
            Row(
              spacing: 10.spMin,
              children: [
                const SuccessButton(
                  text: "Save",
                ),
                const SuccessButton(
                  text: "Cancel",
                  backgroundColor: AppC.redAccent,
                ),
                Expanded(child: CompactSearchView(
                  hintText: "Search",
                  controller: context.read<RentalCustomerBloc>().searchController,
                ))
              ],
            )
          ],
        )));
  }
}
