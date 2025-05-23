import 'dart:developer';

import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Bloc/location_data_bloc.dart';
import '../../../../Component/custom_compact_pagination.dart';
import '../../../../Component/success_button.dart';
import '../../../../Utilities/appC.dart';
import '../Components/location_list_item.dart';

class LocationView extends StatelessWidget {
  final String? title;
  LocationView({super.key,this.title});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
        LocationDataBloc()..add(LocationInitialEvent(title: title))..add(const GetAddedLocationListData()),
        child: BlocListener<LocationDataBloc, LocationDataState>(
          listener: (context, state) async {
            if (state is LocationDataLoading) {
              EasyLoading.show();
            } else if (state is LocationListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: BlocBuilder<LocationDataBloc, LocationDataState>(
            builder: (context, state) {
              return
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                    child: Column(
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: ListView(
                              children: [
                                Utils.getTextFormField(
                                  "Location Name",
                                  context.read<LocationDataBloc>().locationController,
                                  validator: (val) => val!.isEmpty ? 'Please enter location name' : null,
                                ),
                                10.height,
                                Utils.getTextFormFieldWithIcon(
                                  "Address",
                                  context.read<LocationDataBloc>().addressController,
                                  onSuffixTap: () {
                                    final bloc = context.read<LocationDataBloc>();
                                    final text = bloc.addressController.text;
                                    if (text.isNotEmpty) {
                                      if (bloc.selectedAddressIndex != null) {
                                        bloc.add(UpdateAddressEvent(text));
                                      } else {
                                        bloc.add(AddAddressEvent(text));
                                      }
                                      bloc.addressController.clear();
                                    }
                                  },
                                  suffixIconData: context.watch<LocationDataBloc>().selectedAddressIndex != null
                                      ? Icons.save
                                      : Icons.add,
                                ),
                                10.height,
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: List.generate(
                                    context.watch<LocationDataBloc>().addressesList.length,
                                        (index) {
                                      final address = context.watch<LocationDataBloc>().addressesList[index];
                                      return InkWell(
                                        onTap: () {
                                          context.read<LocationDataBloc>().add(SelectAddressForEditEvent(index));
                                        },
                                        child: Chip(
                                          label: Utils.getText(address['address'] ?? ''),
                                          deleteIcon: const Icon(Icons.close),
                                          deleteIconColor: Colors.redAccent,
                                          backgroundColor: AppC.lowGreen,
                                          onDeleted: () {
                                            context.read<LocationDataBloc>().add(RemoveAddressEvent(index));
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                10.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (!context.read<LocationDataBloc>().isEditMode) ...[
                                      SuccessButton(
                                        text: "Save",
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            final bloc = context.read<LocationDataBloc>();
                                            final addressText = bloc.addressController.text.trim();
                                            if (addressText.isNotEmpty) {
                                              bloc.add(AddAddressEvent(addressText));
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                final addresses = List<Map<String, dynamic>>.from(bloc.addressesList);
                                                log("Saving new location with addresses: $addresses");
                                                bloc.add(AddLocationData(
                                                  name: bloc.locationController.text,
                                                  address: addresses,
                                                  id: null,
                                                ));
                                              });
                                            } else {
                                              // No address text, proceed with current addressesList
                                              final addresses = List<Map<String, dynamic>>.from(bloc.addressesList);
                                              log("Saving new location with addresses: $addresses");
                                              bloc.add(AddLocationData(
                                                name: bloc.locationController.text,
                                                address: addresses,
                                                id: null,
                                              ));
                                            }
                                            formKey.currentState!.reset();
                                          }
                                        },
                                      ),
                                    ],
                                    if (context.read<LocationDataBloc>().isEditMode) ...[
                                      SuccessButton(
                                        text: "Update",
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            final bloc = context.read<LocationDataBloc>();
                                            final addresses = List<Map<String, dynamic>>.from(bloc.addressesList);
                                            log("Updating location with addresses: $addresses");
                                            log("${bloc.tempLocation} tempLocation");
                                            bloc.add(AddLocationData(
                                              name: bloc.locationController.text,
                                              address: addresses,
                                              id: bloc.tempLocation.isNotEmpty ? bloc.tempLocation[0]['id'] : null,
                                            ));
                                          }
                                        },
                                      ),
                                      SuccessButton(
                                        text: "Cancel",
                                        backgroundColor: AppC.red,
                                        onPressed: () {
                                          context.read<LocationDataBloc>().add(ExitEditModeEvent());
                                        },
                                      ),
                                    ],
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: CompactSearchView(
                                        controller: context.read<LocationDataBloc>().searchController,
                                        onChanged: (value) => context.read<LocationDataBloc>().add(FilterLocationEvent(searchTerm: value)),
                                      ),
                                    ),
                                  ],
                                ),
                                10.height,
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(7),
                                    2: FlexColumnWidth(4),
                                  },
                                  children: [
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      children: [
                                        Text(''),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 8.0),
                                          child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
                                          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...context.watch<LocationDataBloc>().filterPage.map((e) =>
                                        LocationListItem(
                                      model: e,
                                      onEdit: () {
                                        context.read<LocationDataBloc>().add(EnterEditModeEvent(location: e));
                                      },
                                      onDelete: () {
                                        AskPermissionDialog.show(
                                          context,
                                          title: "Are you sure?",
                                          description: "Do you want to delete this location?",
                                          positiveText: "Yes, Delete it!",
                                          negativeText: "Cancel",
                                          isReasonRequired: false,
                                          onPositivePressed: () {
                                            context.read<LocationDataBloc>().add(DeleteLocation(id: e['id']));
                                          },
                                        );
                                        //context.read<LocationDataBloc>().add(ExitEditModeEvent());
                                      },
                                    )).toList(),
                                  ],
                                ),
                                CompactPagination(
                                  currentPage: context.watch<LocationDataBloc>().currentIndex,
                                  totalPages: context.watch<LocationDataBloc>().totalPages,
                                  onPageChanged: (value) => context.read<LocationDataBloc>().add(LocationPaginationEvent(page: value)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}