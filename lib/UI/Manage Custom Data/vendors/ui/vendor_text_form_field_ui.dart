part of 'vendor_main_ui.dart';

class VendorTextFormFieldUI extends StatelessWidget {
  const VendorTextFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorBloc, VendorState>(
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.spMin,
            children: [
              Utils.getTextFormField(
                'Vendor Name',
                context.read<VendorBloc>().nameController,
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter vendor name' : null,
                autoValidate: context.read<VendorBloc>().autoValidate,
              ),
              SearchViewField(
                controller: context.read<VendorBloc>().vendorTypeController,
                suggestions: context.watch<VendorBloc>().vendorType,
                itemAsString: (item) => item['name'] ?? '',
                onSelected: (value) => context.read<VendorBloc>().add(VendorTypeEvent()),
                selectedItem: (context.watch<VendorBloc>().selectedVendorType != null) ? null : context.watch<VendorBloc>().selectedVendorType,
                onEmptyTap: () => context.push(VendorTypeMainUI(title: context.read<VendorBloc>().vendorTypeController.text)),
                showEmpty: true,
                labelText: 'Task Name',
                hintText: "Select Task",
              ),
            ],
          ),
        );
      }
    );
  }
}
