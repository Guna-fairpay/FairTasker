import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/suggestion_search_bar.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/vendor_image_upload.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/vendor_list_item.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vendor/vendor_ui/vendor_type_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/vendor_types/ui/vendor_type_main_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Component/custom_compact_pagination.dart';
import '../../../../Utilities/utils.dart';
import '../../../../Utilities/appC.dart';
import '../Bloc/vendor_data_bloc.dart';

class VendorView extends StatelessWidget {
  dynamic selectedVendorType;
  List<dynamic> businessCarImage = [];
  final String? title;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  VendorView({super.key, this.title});

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
          create: (context) => VendorDataBloc()..add(VendorInitialEvent(title: title))..add(const GetVendorList()),
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
                    padding: EdgeInsets.all(10.sp),
                    child: GestureDetector(
                      onTap: () => Utils.dismissKeyboard(context),
                      child: Column(
                        children: [
                          Expanded(
                            child: Form(
                              key: formKey,
                              child: ListView(
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Utils.getTextFormField(
                                      'Vendor Name',
                                      context.read<VendorDataBloc>().nameController,
                                      validator: (val) => val == null || val.isEmpty ? 'Please enter vendor name' : null,
                                    ),
                                  ),
                                  10.height,
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                        SuggestionSearchBar<Map<String, dynamic>>(
                                          suggestions: context.watch<VendorDataBloc>().vendorSearchData.where((item) => item['name']?.trim().isNotEmpty ?? false).toList(),
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
                                            print('Selected item: ${selectedVendorType['id']} ${selectedVendorType['name']}');
                                          },
                                          onIconTap: () {
                                            print("Triggered onIconTap");
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const VendorTypeMainUI(),
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.height,
                                  Utils.getTextFormField(
                                      'Address',
                                    context.read<VendorDataBloc>().addressController,
                                      hintText: 'Address',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Row(
                                          spacing: 12.spMin,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: ()=> _getCurrentLocation(context),
                                                child: const Icon(Icons.location_on_outlined,color: AppC.appColor,)
                                            ),
                                            if(context.read<VendorDataBloc>().latitude != null && context.read<VendorDataBloc>().longitude != null)...[
                                              InkWell(
                                                onTap: ()async{
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
                                                child: Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.rotationZ(30 * math.pi / 180),
                                                  child: const Icon(
                                                    Icons.navigation_outlined,
                                                    color: AppC.green,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: ()=> context.read<VendorDataBloc>().add(const ResetLocationEvent()),
                                                  child: const Icon(Icons.close, color: AppC.redAccent,)
                                              ),
                                            ],

                                          ],
                                        ),
                                      ),
                                    counterText: (context.read<VendorDataBloc>().latitude != null && context.read<VendorDataBloc>().longitude != null)
                                        ? "Lat : ${context.watch<VendorDataBloc>().latitude} Long : ${context.watch<VendorDataBloc>().longitude}"
                                        : null,
                                  ),
                                  10.height,
                                  Utils.getTextFormField(
                                      'Phone',
                                      context
                                          .read<VendorDataBloc>()
                                          .phoneController,
                                      textType: TextInputType.phone),
                                  10.height,
                                  Utils.getTextFormField(
                                      'Website',
                                      context
                                          .read<VendorDataBloc>()
                                          .websiteController),
                                  10.height,
                                  Utils.getTextFormField(
                                      null,
                                      context
                                          .read<VendorDataBloc>()
                                          .expertiseController,
                                      hintText: 'Expertise',
                                      minLines: 2,
                                      maxLines: 4),
                                  10.height,
                                  Utils.getTextFormField(
                                      null,
                                      context
                                          .read<VendorDataBloc>()
                                          .descriptionController,
                                      hintText: 'Description',
                                      minLines: 2,
                                      maxLines: 4),
                                  10.height,
                                  ImageUploadSection(
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
                                              if(formKey.currentState!.validate()){
                                                if(context.read<VendorDataBloc>().nameController.text.isEmpty){
                                                  formKey.currentState!.reset();
                                                  return;
                                                }
                                                context.read<VendorDataBloc>().add(AddVendorData(
                                                  name: context.read<VendorDataBloc>().nameController.text,
                                                  vendorTypeId: selectedVendorType?['id'] ?? null,
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
                                                selectedVendorType = null;
                                                formKey.currentState!.reset();
                                              }
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
                                                    vendorTypeId: selectedVendorType != null ? selectedVendorType['id'] ?? '' : context.read<VendorDataBloc>().vendorTypeId,
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
                                              selectedVendorType = null;
                                            },
                                          ),
                                          SuccessButton(
                                            text: 'Cancel',
                                            backgroundColor: AppC.red,
                                            onPressed: () {
                                              context.read<VendorDataBloc>().add(ExitEditModeEvent());
                                              selectedVendorType = null;
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
                                      0: FlexColumnWidth(2),
                                      3: IntrinsicColumnWidth(),
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
                                        children:  [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal:8.spMin, vertical: 4.spMin),
                                            child: const Text('Vendor Name',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal:8.spMin, vertical: 4.spMin),
                                            child: const Text('Actions',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      ...context.read<VendorDataBloc>().filterPage.map((vendor) =>
                                      VendorListItem(vendor: vendor, context: context)
                                      ).toList(),
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
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks[0];
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
