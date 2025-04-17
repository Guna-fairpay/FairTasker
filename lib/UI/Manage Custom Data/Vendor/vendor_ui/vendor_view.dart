import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/suggestion_search_bar.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/vendor_image_upload.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/vendor_type_view.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Component/custom_compact_pagination.dart';
import '../../../../Utilities/num.dart';
import '../../../../Utilities/utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../vendor_data_bloc.dart';

class VendorView extends StatelessWidget {
  dynamic selectedVendorType;
  List<dynamic> businessCarImage = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  VendorView({super.key});

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
                  print("${context.read<VendorDataBloc>().vendorTypeId} vendorTypeId");
              return SafeArea(
                  minimum: EdgeInsets.only(bottom: 10.sp, top: 10.sp),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.sp, right: 10.sp, bottom: 10.sp, top: 10.sp),
                    child: Column(
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: ListView(
                              children: [
                                Utils.getTextFormField(
                                  'Vendor Name',
                                  context.read<VendorDataBloc>().nameController,
                                  autoValidate: AutovalidateMode.onUserInteraction,
                                  validator: (val) => val!.isEmpty ? 'Please enter vendor name' : null,
                                ),
                                5.height,
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                      SuggestionSearchBar<Map<String, dynamic>>(
                                        suggestions: context.read<VendorDataBloc>().vendorTypeData.where((item) => item['name']?.trim().isNotEmpty ?? false).toList(),
                                        displayString: (item) => item['name']?.trim().replaceAll('\n', ' ') ?? '',
                                        getId: (item) => item['id'],
                                        searchController: context.read<VendorDataBloc>().searchController,
                                        hintText: "Search Vendor Name",
                                        onChanged: (val) {
                                          log("SuggestionSearchBar $val");
                                          context.read<VendorDataBloc>().add(FilterVendorTypeEvent(searchTerm: val));
                                        },
                                        onSelected: (item) {
                                          selectedVendorType = item;
                                          print('Selected item: $item');
                                        },
                                        onIconTap: () {
                                          print("Triggered onIconTap");
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                const VendorTypeView(),
                                          ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                  Row(children: [
                                    Expanded(
                                      child: Utils.getTextFormFieldWithIcon(
                                          'Address',
                                          context
                                              .read<VendorDataBloc>()
                                              .addressController,
                                          suffixIconData:
                                              Icons.location_on_outlined,
                                          onSuffixTap: () {
                                        _getCurrentLocation(context);
                                      }),
                                    ),
                                    if (context.read<VendorDataBloc>().latitude != null &&
                                        context.read<VendorDataBloc>().longitude != null) ...[
                                      GestureDetector(
                                        onTap: () async {
                                          final Uri mapsUri = Uri(
                                            scheme: 'https',
                                            host: 'www.google.com',
                                            path:
                                                '/maps/search/ ${context.read<VendorDataBloc>().latitude}, ${context.read<VendorDataBloc>().longitude}',
                                            queryParameters: {
                                              'q':
                                                  '${context.read<VendorDataBloc>().latitude}, ${context.read<VendorDataBloc>().longitude}'
                                            },
                                          );
                                          if (await canLaunchUrl(mapsUri)) {
                                            await launchUrl(mapsUri,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            throw 'Could not open the map.';
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ),
                                            color: AppC.blue50,
                                            border: const Border(
                                              top: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                              bottom: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                              right: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 9, vertical: 9),
                                            child: Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationZ(
                                                    50 * math.pi / 180),
                                                child: const Icon(
                                                    Icons.navigation_outlined,
                                                    color: AppC.green)),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<VendorDataBloc>().add(const ResetLocationEvent());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ),
                                            color: AppC.blue50,
                                            border: const Border(
                                              top: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                              bottom: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                              right: BorderSide(
                                                  width: Num.borderWidthField,
                                                  color: AppC.fieldBase),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 9, vertical: 9),
                                            child: Icon(Icons.close,
                                                color: AppC.red),
                                          ),
                                        ),
                                      )
                                    ],
                                  ]),
                                  if (context.read<VendorDataBloc>().latitude != null &&
                                      context.read<VendorDataBloc>().longitude != null) ...[
                                    ListTile(
                                      trailing: Utils.getText(
                                          "Lat : ${context.watch<VendorDataBloc>().latitude} "
                                          "Long : ${context.watch<VendorDataBloc>().longitude}",
                                          color: AppC.red),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ] else ...[
                                    5.height,
                                  ],
                                Utils.getTextFormField(
                                    'Phone',
                                    context
                                        .read<VendorDataBloc>()
                                        .phoneController,
                                    textType: TextInputType.phone),
                                5.height,
                                Utils.getTextFormField(
                                    'Website',
                                    context
                                        .read<VendorDataBloc>()
                                        .websiteController),
                                5.height,
                                Utils.getBorderedMultilineTextField(
                                    'Expertise',
                                    context
                                        .read<VendorDataBloc>()
                                        .expertiseController,
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
                                VendorImageUploadSection(
                                  title: 'Upload Business Card',
                                  borderColor: Colors.blue,
                                  onUpload: () => context.read<VendorDataBloc>().add(VendorImageEvent()),
                                  onRemove: (index) => context.read<VendorDataBloc>().add(RemoveVendorImageEvent(index: index)),
                                  images: context.watch<VendorDataBloc>().vendorImage,
                                  logName: "",
                                ),
                                10.height,
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (!context
                                          .watch<VendorDataBloc>()
                                          .isEditMode)
                                        SuccessButton(
                                          text: 'Save',
                                          onPressed: () {
                                            formKey.currentState!.validate();
                                            if(context.read<VendorDataBloc>().nameController.text.isEmpty){
                                              return ;
                                            }
                                            context.read<VendorDataBloc>().add(AddVendorData(
                                                  name: context.read<VendorDataBloc>().nameController.text,
                                                  vendorTypeId:
                                                      selectedVendorType?['id'].toString() ?? '',
                                                  address: context.read<VendorDataBloc>().addressController.text,
                                                  phone: context.read<VendorDataBloc>().phoneController.text,
                                                  expertise: context.read<VendorDataBloc>().expertiseController.text,
                                                  description: context.read<VendorDataBloc>().descriptionController.text,
                                                  latitude: context.read<VendorDataBloc>().latitude?.toString(),
                                                  longitude: context.read<VendorDataBloc>().longitude?.toString(),
                                                  website: context.read<VendorDataBloc>().websiteController.text,
                                                  images: context.read<VendorDataBloc>().vendorImage.whereType<File>().map((e) => e).toList(),
                                                  id: null,
                                                ));
                                          },
                                        ),
                                      if (context
                                          .watch<VendorDataBloc>()
                                          .isEditMode) ...[
                                        SuccessButton(
                                          text: 'Update',
                                          onPressed: () {
                                            context.read<VendorDataBloc>().add(AddVendorData(
                                                  name: context.read<VendorDataBloc>().nameController.text,
                                                  vendorTypeId: context.read<VendorDataBloc>().vendorTypeId.toString(),
                                                  address: context.read<VendorDataBloc>().addressController.text,
                                                  phone: context.read<VendorDataBloc>().phoneController.text,
                                                  expertise: context.read<VendorDataBloc>().expertiseController.text,
                                                  description: context.read<VendorDataBloc>().descriptionController.text,
                                                  latitude: context.read<VendorDataBloc>().latitude?.toString(),
                                                  longitude: context.read<VendorDataBloc>().longitude?.toString(),
                                                  website: context.read<VendorDataBloc>().websiteController.text,
                                                  images: context.read<VendorDataBloc>().vendorImage.whereType<File>().map((e) => e).toList(),
                                                  id: context.read<VendorDataBloc>().vendorId,
                                                ));
                                          },
                                        ),
                                        SuccessButton(
                                          text: 'Cancel',
                                          backgroundColor: AppC.red,
                                          onPressed: () {
                                            context.read<VendorDataBloc>().add(ExitEditModeEvent());
                                          },
                                        ),
                                      ],
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child:
                                        CompactSearchView(
                                          controller: context.read<VendorDataBloc>().vendorSearchController,
                                          onChanged: (val) {
                                            context.read<VendorDataBloc>().add(FilterVendorsEvent(searchTerm: val));
                                          },
                                        ),
                                      )
                                    ]),
                                20.height,
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(5),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(2),
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
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Text('',),
                                        Text('',),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 8.0),
                                          child: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    ...context.read<VendorDataBloc>().filterPage.map((vendor) {
                                      return
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1),
                                          )),
                                          children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: GestureDetector(
                                              onTap: () { context.read<VendorDataBloc>().add(EnterEditModeEvent(vendor: vendor));},
                                                child: Text(vendor['name'] ?? '')
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(vertical: 10),
                                              child: (vendor['images'].length > 0)
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        ShowAttachmentsDialog.of.show(
                                                            context,
                                                            attachments: vendor['images']?.map((e) => e['path'].toString().toStorageURL).toList(), title: vendor['name'] ?? '');
                                                      },
                                                      child: const Icon(
                                                        Icons.visibility,
                                                        color: AppC.appColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Utils.getText("")
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: (vendor['latitude'] != null && vendor['longitude'] != null)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      final Uri mapsUri = Uri(
                                                        scheme: 'https',
                                                        host: 'www.google.com',
                                                        path: '/maps/search/ ${vendor['latitude']}, ${vendor['longitude']}',
                                                        queryParameters: {'q': '${vendor['latitude']}, ${vendor['longitude']}'},
                                                      );
                                                      if (await canLaunchUrl(
                                                          mapsUri)) {
                                                        await launchUrl(mapsUri,
                                                            mode: LaunchMode
                                                                .externalApplication);
                                                      } else {
                                                        throw 'Could not open the map.';
                                                      }
                                                    },
                                                    child: Transform(
                                                        alignment: Alignment.center,
                                                        transform: Matrix4.rotationZ(50 * math.pi / 180),
                                                        child: const Icon(Icons.navigation_outlined, color: AppC.green)
                                                    ),
                                                )
                                                : Utils.getText(""),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10
                                                  ),
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
                                                    onTap: () {
                                                      AskPermissionDialog.show(
                                                        context,
                                                        title: "Are you sure?",
                                                        description:
                                                            "Do you want to delete this vendor?",
                                                        positiveText:
                                                            "Yes, Delete it!",
                                                        negativeText: "Cancel",
                                                        isReasonRequired: false,
                                                        onPositivePressed: () => context.read<VendorDataBloc>().add(DeleteVendorEvent(id: vendor['id'])),
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
                                    }).toList(),
                                  ],
                                ),
                                CompactPagination(
                                  currentPage: context.watch<VendorDataBloc>().currentIndex,
                                  totalPages: (context.watch<VendorDataBloc>().totalCount / context.watch<VendorDataBloc>().itemsPerPage).ceil(),
                                  onPageChanged: (value) => context.read<VendorDataBloc>().add(VendorPaginationEvent(page: value)),
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

  // Location handling methods
  Future<void> _getCurrentLocation(BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    EasyLoading.show();
    if (!serviceEnabled) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      Utils.showMobileToast(
          "Location services are disabled. Please enable them.");
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (EasyLoading.isShow) EasyLoading.dismiss();
        Utils.showMobileToast("Location permission denied.");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      Utils.showMobileToast("Location permission is permanently denied.");
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (EasyLoading.isShow) EasyLoading.dismiss();
      // Update VendorDataBloc with latitude and longitude
      context.read<VendorDataBloc>().latitude = position.latitude;
      context.read<VendorDataBloc>().longitude = position.longitude;
      context.read<VendorDataBloc>().add(locationEvent(latitude: position.latitude, longitude: position.longitude));
      // Fetch address
      _getAddressFromLatLng(context, position.latitude, position.longitude);
    } catch (e) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      Utils.showMobileToast("Failed to get location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(
      BuildContext context, double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
        // Update addressController only if empty
        context.read<VendorDataBloc>().addressController.clear();
        context.read<VendorDataBloc>().addressController.text = address;
        context.read<VendorDataBloc>().latitude = lat;
        context.read<VendorDataBloc>().longitude = lng;
      } else {
        Utils.showMobileToast("No address found for the location.");
      }
    } catch (e) {
      Utils.showMobileToast("Failed to get address: $e");
    }
  }
}
