import 'dart:developer';

import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/suggestion_search_bar.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Component/header.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../vendor_data_bloc.dart';

class VendorView extends StatelessWidget {
  const VendorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Vendors"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
      ),
      body: BlocProvider(
          create: (context) => VendorDataBloc()..add(const GetVendorList()),
          child: BlocListener<VendorDataBloc, VendorDataState>(
            listener: (context, state) async {
              if (state is VendorDataLoading) {
                EasyLoading.show();
              } else if (state is VendorListLoaded) {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              }
            },
            child: BlocBuilder<VendorDataBloc, VendorDataState>(
                builder: (context, state) {
                  return SafeArea(
                  minimum: EdgeInsets.only(bottom: 10.sp, top: 10.sp),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.sp, right: 10.sp, bottom: 10.sp),
                    child: Column(
                      children: [
                        Expanded(
                          child: Form(
                            child: ListView(
                              children: [
                                Utils.getTextFormField(
                                  'Vendor Name',
                                  context.read<VendorDataBloc>().nameController,
                                ),
                                5.height,
                                Row(
                                  children: [
                                    Expanded(
                                      child: SuggestionSearchBar<Map<String, dynamic>>(
                                        suggestions: context.read<VendorDataBloc>().vendorTypeData
                                            .where((item) => item['name']?.trim().isNotEmpty ?? false)
                                            .toList(),
                                        displayString: (item) => item['name']?.trim().replaceAll('\n', ' ') ?? '',
                                        getId: (item) => item['id'],
                                        searchController: context.read<VendorDataBloc>().searchController,
                                        hintText: "Search Vendor Name",
                                        selectedId: context.read<VendorDataBloc>().vendorTypeId,
                                        onChanged: (val){
                                          log("SuggestionSearchBar $val");
                                          context.read<VendorDataBloc>().add(FilterVendorTypeEvent(searchTerm: val));
                                        },
                                        onSelected: (item) {
                                          print('Selected item: $item');
                                        },
                                        onIconTap: () {
                                          print('Add tapped!');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                Utils.getTextFormField(
                                    'Address',
                                    context.read<VendorDataBloc>().addressController
                                ),
                                5.height,
                                Utils.getTextFormField(
                                    'Phone',
                                    context.read<VendorDataBloc>().phoneController,
                                    textType: TextInputType.phone
                                ),
                                5.height,
                                Utils.getTextFormField(
                                    'Website',
                                    context.read<VendorDataBloc>().websiteController
                                ),
                                5.height,
                                Utils.getBorderedMultilineTextField(
                                    'Expertise',
                                    context.read<VendorDataBloc>().expertiseController,
                                    minLines: 2,
                                    maxLines: 4),
                                5.height,
                                Utils.getBorderedMultilineTextField(
                                    'Description',
                                    context
                                        .read<VendorDataBloc>()
                                        .descriptionController,
                                    minLines: 2,
                                    maxLines: 4),
                                5.height,
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (!context
                                          .watch<VendorDataBloc>()
                                          .isEditMode)
                                        const SuccessButton(
                                          text: 'Save',
                                        ),
                                      if (context
                                          .watch<VendorDataBloc>()
                                          .isEditMode) ...[
                                        SuccessButton(
                                          text: 'Update',
                                          onPressed: () {
                                            context.read<VendorDataBloc>().add(AddVendorData(
                                                  name: context.read<VendorDataBloc>().nameController.text,
                                                  vendorTypeId: '',
                                                  address: context.read<VendorDataBloc>().addressController.text,
                                                  phone: context.read<VendorDataBloc>().phoneController.text,
                                                  expertise: context.read<VendorDataBloc>().expertiseController.text,
                                                  description: context.read<VendorDataBloc>().descriptionController.text,
                                                  latitude: context.read<VendorDataBloc>().latitude.toString(),
                                                  longitude: context.read<VendorDataBloc>().longitude.toString(),
                                                  website: context.read<VendorDataBloc>().websiteController.text,
                                                  images: [],
                                                  id: 0,
                                                )
                                            );
                                          },
                                        ),
                                        SuccessButton(
                                          text: 'Cancel',
                                          backgroundColor: AppC.red,
                                          onPressed: () {
                                            context
                                                .read<VendorDataBloc>()
                                                .add(ExitEditModeEvent());
                                          },
                                        ),
                                      ],
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: Utils.getSearchBarUI(
                                            searchController: context.read<VendorDataBloc>().vendorSearchController,
                                            onChange: (val) {
                                              context.read<VendorDataBloc>().add(FilterVendorsEvent(searchTerm: val));
                                            },
                                          )
                                      )
                                    ]),
                                5.height,
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(5),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(2),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8.0),
                                          child: Text('Vendor Name',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                        Text(
                                          '',
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 8.0),
                                          child: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...context.read<VendorDataBloc>().filteredVendors.take(10).map((vendor) {
                                      return TableRow(
                                        decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1),
                                            )
                                        ),
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10),
                                            child: Text(vendor['name'] ?? ''),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: GestureDetector(
                                              child:
                                              // Icon(Icons.visibility, color: AppC.appColor, size: 20,),
                                              Utils.getText(""),
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Row(
                                                spacing: 20,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));
                                                    },
                                                    child: const Icon(
                                                      Icons.edit_outlined,
                                                      color: AppC.appColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: const Icon(
                                                      Icons.delete_outline,
                                                      color: AppC.red,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            }),
          )),
    );
  }
}
