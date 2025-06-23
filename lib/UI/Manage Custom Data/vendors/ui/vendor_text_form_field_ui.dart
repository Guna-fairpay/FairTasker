part of 'vendor_main_ui.dart';

class VendorTextFormFieldUI extends StatelessWidget {
  const VendorTextFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorBloc, VendorState>(
      builder: (context, state) {
        return Form(
          key: context.read<VendorBloc>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.spMin,
            children: [
              Utils.getTextFormField(
                'Vendor Name',
                context.read<VendorBloc>().nameController,
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter vendor name' : null,
                autoValidate: context.watch<VendorBloc>().autoValidateMode,
              ),
              SearchViewField(
                controller: context.read<VendorBloc>().vendorTypeController,
                suggestions: context.watch<VendorBloc>().vendorType,
                itemAsString: (item) => item['name'] ?? '',
                onSelected: (value) => context.read<VendorBloc>().add(SelectVendorTypeEvent(value)),
                selectedItem: (context.watch<VendorBloc>().selectedVendorType != null) ? null : context.watch<VendorBloc>().selectedVendorType,
                onEmptyTap: () => context.read<VendorBloc>().add(VendorTypeEvent(context.read<VendorBloc>().vendorTypeController.text,)),
                showEmpty: true,
                labelText: 'Vendor Type',
                hintText: "Select Vendor Type",
              ),
              Utils.getTextFormField(
                'Address',
                context.read<VendorBloc>().addressController,
                suffixIcon: Padding(
                  padding: 10.padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10.spMin,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: ()=> context.read<VendorBloc>().add(AddressEvent()),
                          child: const Icon(Iconsax.location,color: AppC.appColor,)
                      ),
                      if(context.watch<VendorBloc>().isLatLong)...[
                        InkWell(
                          onTap: ()=> context.read<VendorBloc>().add(NavigationEvent()),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(30 * math.pi / -120),
                            child: const Icon(
                              Iconsax.direct_right,
                              color: AppC.green,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: ()=> context.read<VendorBloc>().add(ClearLatLongEvent()),
                            child: const Icon(Icons.close, color: AppC.redAccent,)
                        ),
                      ],

                    ],
                  ),
                ),
                counterText: (context.watch<VendorBloc>().isLatLong)
                    ? "Lat : ${context.watch<VendorBloc>().latitude ?? ''} Long : ${context.watch<VendorBloc>().longitude ?? ''}"
                    : null,
              ),
              Utils.getTextFormField(
                'Phone',
                context.read<VendorBloc>().phoneController,
                  textType: TextInputType.phone,
                textInputFormatter: [FilteringTextInputFormatter.digitsOnly]
              ),
              Utils.getTextFormField(
                'Website',
                context.read<VendorBloc>().websiteController,

              ),
              Utils.getTextFormField(
                'Expertise',
                context.read<VendorBloc>().expertiseController,
                minLines: 2,
                maxLines: 2,
              ),
              Utils.getTextFormField(
                'Description',
                context.read<VendorBloc>().descriptionController,
                minLines: 2,
                maxLines: 2,
              ),
              ImageUploadSection(
                title: 'Upload Business Card',
                borderColor: Colors.grey,
                onUpload: () =>context.read<VendorBloc>().add(PickImageEvent()),
                onRemove: (file) => context.read<VendorBloc>().add(RemoveImageEvent(data: file)),
                images: context.watch<VendorBloc>().businessCardImage,
                logName: "PurchaseReceiptImageEvent",
              ),
              Row(
                  spacing: 10,
                  children: [
                    SuccessButton(
                      text:(!context.read<VendorBloc>().isEdit) ? 'Save' : 'Update',
                      onPressed: ()=> context.read<VendorBloc>().add(SaveEvent()),
                    ),
                    if (context.read<VendorBloc>().isEdit) ...[
                      SuccessButton(
                        text: 'Cancel',
                        backgroundColor: AppC.red,
                        onPressed: ()=> context.read<VendorBloc>().add(CancelEvent()),
                      ),
                    ],
                    Expanded(
                      flex: 8,
                      child: CompactSearchView(
                        controller: context.read<VendorBloc>().searchController,
                        onChanged: (value) => context.read<VendorBloc>().add(SearchEvent(value)),
                      ),
                    ),
                  ]
              ),
            ],
          ),
        );
      }
    );
  }
}
