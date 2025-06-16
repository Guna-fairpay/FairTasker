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
                context.read<VendorBloc>().vendorController,
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter vendor name' : null,
                autoValidate: context.read<VendorBloc>().autoValidate,
              ),

            ],
          ),
        );
      }
    );
  }
}
