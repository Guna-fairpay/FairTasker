


import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Component/custom_compact_pagination.dart';
import '../../../../Component/success_button.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../vendor_data_bloc.dart';

class VendorTypeView extends StatelessWidget {
  const VendorTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor Types"),
        titleTextStyle:
        context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: context.pop, icon: const Icon(Icons.close_rounded)
          )
        ],
      ),
      body: BlocProvider(
          create: (context) => VendorDataBloc()..add(const GetVendorTypeList()),
          child: BlocListener<VendorDataBloc, VendorDataState>(
            listener: (context, state) async {
              if (state is VendorDataLoading) {
                EasyLoading.show();
              }
              else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              }
            },
            child:
            BlocBuilder<VendorDataBloc, VendorDataState>(
                builder: (context, state) {
                  return SafeArea(
                      minimum: 16.sp.padding,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Utils.getTextFormField('Name', context.read<VendorDataBloc>().vendorTypeNameController),
                                5.height,
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (!context.read<VendorDataBloc>().isVendorTypeEdit)
                                        SuccessButton(
                                          text: 'Save',
                                          onPressed: ()
                                          {
                                            context.read<VendorDataBloc>().add(AddVendorType(name: context.read<VendorDataBloc>().vendorTypeNameController.text, id: null));
                                          },
                                        ),
                                      if (context.read<VendorDataBloc>().isVendorTypeEdit) ...[
                                        SuccessButton(
                                          text: 'Update',
                                          onPressed: () {
                                            context.read<VendorDataBloc>().add(AddVendorType(
                                                name: context.read<VendorDataBloc>().vendorTypeNameController.text,
                                                id: context.read<VendorDataBloc>().vendorTypeEditId)
                                            );
                                          },
                                        ),
                                        SuccessButton(
                                          text: 'Cancel',
                                          backgroundColor: AppC.red,
                                          onPressed: () {
                                            context.read<VendorDataBloc>().add(ExitVendorTypeEditEvent());
                                          },
                                        ),
                                      ],
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child:
                                        CompactSearchView(
                                          controller: context.read<VendorDataBloc>().vendorTypeSearchController,
                                          onChanged: (value) => context.read<VendorDataBloc>().add(FilterVendorEvent(searchTerm: value)),
                                        )
                                      ),
                                    ]
                                  ),
                                5.height,
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(9),
                                    1: FlexColumnWidth(3),
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
                                          child: Text('Type',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8.0),
                                          child: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...context.read<VendorDataBloc>().filterPage1.map((vendor) {
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  context.read<VendorDataBloc>().add(EnterVendorTypeEditEvent(vendor: vendor));
                                                },
                                                child: Text(vendor['name'])
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 12),
                                              child: Row(
                                                spacing: 10,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.read<VendorDataBloc>().add(EnterVendorTypeEditEvent(vendor: vendor));
                                                    },
                                                    child: const Icon(
                                                      Icons.edit_outlined,
                                                      color: AppC.appColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      AskPermissionDialog.show(
                                                        context,
                                                        title: "Are you sure?",
                                                        description: "Do you want to delete this vendor type?",
                                                        positiveText: "Yes, Delete it!",
                                                        negativeText: "Cancel",
                                                        isReasonRequired: false,
                                                        onPositivePressed: () => context.read<VendorDataBloc>().add(DeleteVendorType(id: vendor['id'])),
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_outline,
                                                      color: AppC.red,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                        ],
                                      );
                                    })
                                  ],
                                ),
                                10.height,
                                CompactPagination(
                                  currentPage: context.watch<VendorDataBloc>().vendorTypeCurrentIndex,
                                  totalPages: (context.watch<VendorDataBloc>().vendorTypeTotalCount / context.watch<VendorDataBloc>().vendorTypeItemsPerPage).ceil(),
                                  onPageChanged: (value) => context.read<VendorDataBloc>().add(VendorTypePaginationEvent(page: value)),
                                ),
                              ],
                            ),
                          ),
                        ],

                      )
                  );
                }
            ),
          )
      ),
    );
  }
}
