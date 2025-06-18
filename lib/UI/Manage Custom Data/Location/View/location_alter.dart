part of 'location_view.dart';

class LocationAlter extends StatelessWidget {
  const LocationAlter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) => Form(
          key: context.read<LocationBloc>().formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.spMin,
            children: [
              CompactTextField(
                hintText: "Location Name",
                controller: context.read<LocationBloc>().locationController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) => (value.isNullOrEmpty) ? "Please enter location name" : null,
              ),
              CompactTextField(
                controller: context.read<LocationBloc>().addressController,
                hintText: "Address",
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.streetAddress,
                suffixIcon: GestureDetector(
                  onTap: () => context.read<LocationBloc>().add(StoreAddressEvent()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppC.lightGray,
                      border: Border.all(
                        width: Num.borderWidthField,
                        color: AppC.borderColor
                      ),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(5.spMin))
                    ),
                    padding: 9.spMin.padding,
                    child: Icon((context.watch<LocationBloc>().isEditAddress) ? Icons.save : Iconsax.add, color: (context.watch<LocationBloc>().isEditAddress) ? AppC.green : AppC.appColor),
                  ),
                ),
              ),
              /*Utils.getTextFormField(
                "Address",
                context.read<LocationBloc>().addressController,
                suffixIcon: InkWell(
                  onTap: () {
                    final bloc = context.read<LocationBloc>();
                    final text = bloc.addressController.text;
                    if (text.isNotEmpty) {
                      if (bloc.selectedAddressIndex != null) {
                        bloc.add(UpdateAddressEvent(text));
                      } else {
                        bloc.add(StoreAddressEvent(text));
                      }
                      bloc.addressController.clear();
                    }
                  },
                  child: Padding(
                    padding: 8.horizontalPadding,
                    child: Icon(
                      context.watch<LocationBloc>().selectedAddressIndex != null
                          ? Icons.save
                          : Icons.add,
                      color: context.watch<LocationBloc>().selectedAddressIndex != null
                              ? AppC.green
                              : AppC.blue,
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8.spMin,
                  runSpacing: 4.spMin,
                  children: List.generate(
                    context.watch<LocationBloc>().addressesList.length,
                    (index) {
                      final address = context.read<LocationBloc>().addressesList[index];
                      return InkWell(
                        onTap: () => context.read<LocationBloc>().add(EditAddressEvent(address)),
                        child: Chip(
                          label: CompactText(address['address'] ?? ''),
                          deleteIcon: const Icon(Icons.close),
                          deleteIconColor: Colors.redAccent,
                          backgroundColor: AppC.lightBlues,
                          side: BorderSide.none,
                          elevation: 2.spMin,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          padding: 7.spMin.padding,
                          color: WidgetStateColor.resolveWith((states) => AppC.lightBlue),
                          onDeleted: () => context.read<LocationBloc>().add(DeleteAddressEvent(address)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                spacing: 10.spMin,
                children: [
                  Expanded(
                      flex: 2,
                      child: Row(
                        spacing: 10.spMin,
                        children: [
                          SuccessButton(
                            text: (context.watch<LocationBloc>().isEditMode) ? "Update" : "Save",
                            onPressed: () => context.read<LocationBloc>().add(SubmitEvent()),
                          ),
                          if (context.watch<LocationBloc>().isEditMode)
                            SuccessButton(
                              text: "Cancel",
                              backgroundColor: AppC.redAccent,
                              onPressed: () => context.read<LocationBloc>().add(ExitEditModeEvent()),
                            ),
                          /*if (!context.read<LocationBloc>().isEditMode) ...[
                            SuccessButton(
                              text: "Save",
                              onPressed: () {
                                if (context
                                    .read<LocationBloc>()
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  final bloc = context.read<LocationBloc>();
                                  final addressText =
                                      bloc.addressController.text.trim();
                                  if (addressText.isNotEmpty) {
                                    // bloc.add(StoreAddressEvent(addressText));
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      final addresses =
                                          List<Map<String, dynamic>>.from(
                                              bloc.addressesList);
                                      bloc.add(SubmitEvent(
                                        name: bloc.locationController.text,
                                        address: addresses,
                                        id: null,
                                      ));
                                    });
                                  } else {
                                    // No address text, proceed with current addressesList
                                    final addresses =
                                        List<Map<String, dynamic>>.from(
                                            bloc.addressesList);
                                    bloc.add(SubmitEvent(
                                      name: bloc.locationController.text,
                                      address: addresses,
                                      id: null,
                                    ));
                                  }
                                  context
                                      .read<LocationBloc>()
                                      .formKey
                                      .currentState!
                                      .reset();
                                }
                              },
                            ),
                          ],
                          if (context.read<LocationBloc>().isEditMode) ...[
                            SuccessButton(
                              text: "Update",
                              onPressed: () {
                                if (context
                                    .read<LocationBloc>()
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  final bloc = context.read<LocationBloc>();
                                  final addresses =
                                      List<Map<String, dynamic>>.from(
                                          bloc.addressesList);
                                  log("Updating location with addresses: $addresses");
                                  log("${bloc.tempLocation} tempLocation");
                                  bloc.add(SubmitEvent(
                                    name: bloc.locationController.text,
                                    address: addresses,
                                    id: bloc.tempLocation.isNotEmpty
                                        ? bloc.tempLocation[0]['id']
                                        : null,
                                  ));
                                }
                              },
                            ),
                            SuccessButton(
                              text: "Cancel",
                              backgroundColor: AppC.red,
                              onPressed: () => context
                                  .read<LocationBloc>()
                                  .add(ExitEditModeEvent()),
                            ),
                          ],*/
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: CompactSearchView(
                        controller: context.read<LocationBloc>().searchController,
                        onChanged: (value) => context.read<LocationBloc>().add(SearchQueryEvent(value)),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
