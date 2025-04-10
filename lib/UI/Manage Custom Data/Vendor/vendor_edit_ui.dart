
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Component/close_badge.dart';
import '../../../Component/image_viewer.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import 'vendor_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utilities/image_pick_helper.dart';
import '../../dialog/show_attachments_dialog.dart';
import 'Vendor Types/vendor_type_add_ui.dart';

class VendorEditUI extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const VendorEditUI({super.key, required this.vendor});

  @override
  State<VendorEditUI> createState() => _VendorEditUIState();
}

class _VendorEditUIState extends State<VendorEditUI> {

  late VendorDataBloc vendorDataBloc;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController vendorTypeController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<dynamic> businessCarImage = [];
  List<Map<String, dynamic>> vendorType = [];
  dynamic selectedVendorType;
  String? locationMessage = "Press the button to get location";
  double? latitude;
  double? longitude;
  String? liveAddress;
  bool onTap = false;

  @override
  void initState() {
    super.initState();
    vendorDataBloc = VendorDataBloc();
    nameController.text =  widget.vendor['name']??'';
    addressController.text = widget.vendor['address']??'';
    phoneController.text =  widget.vendor['phone']??'';
    expertiseController.text = widget.vendor['expertise']??'';
    descriptionController.text = widget.vendor['description']??'';
    websiteController.text = widget.vendor['website']??'';
    latitude =double.tryParse(widget.vendor['latitude']??'');
    longitude =double.tryParse(widget.vendor['longitude']??'');
    businessCarImage.addAll(widget.vendor['images']?.map((e) => e['path'].toString().toStorageURL).toList());
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _pickBusinessCardImages(ImageSource source) async {
    List<File> selectedImages = await Utils.pickImages(source);
    if (selectedImages.isNotEmpty) {
      setState(() {
        businessCarImage.addAll(selectedImages);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    onTap=true;
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    EasyLoading.show();
    if (!serviceEnabled) {
      EasyLoading.dismiss();
      setState(() {
        locationMessage = "Location services are disabled. Please enable them.";
      });
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.dismiss();
        setState(() {
          locationMessage = "Location permission denied.";
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) { EasyLoading.dismiss();
      setState(() {
        locationMessage = "Location permission is permanently denied.";
      });
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ); EasyLoading.dismiss();
    setState(() {
      if(latitude == null && longitude == null) {
        latitude= position.latitude;
        longitude= position.longitude;
      }
      locationMessage = "Lat: ${position.latitude}, Long: ${position.longitude}";
      _getAddressFromLatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      setState(() {
        liveAddress = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
        if(addressController.text.isEmpty){
          addressController.text = liveAddress!;
        }
      });
    } catch (e) {
      setState(() {
        liveAddress = 'Failed to get address: $e';
      });
    }
  }

  void _save() {
    setState(() {});
    if (nameController.text.isEmpty) {
      return ;
    }
    final updatedVendor = {
      'id': widget.vendor['id'],
      'name': nameController.text,
      'vendor_type': selectedVendorType['id'],
      'address': addressController.text,
      'phone': phoneController.text,
      'expertise': expertiseController.text,
      'description': descriptionController.text,
      'website': websiteController.text,
      'latitude': (latitude??'').toString(),
      'longitude': (longitude??'').toString(),
      'images': businessCarImage.whereType<File>().map((e) => e).toList(),
    };
    Navigator.pop(context, updatedVendor);
  }

  void _removeImage(imageId) {
    vendorDataBloc.add(
      DeleteImage(id: imageId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title:const Text('Edit Vendor'),
        backgroundColor: AppC.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider(
        create: (context) => vendorDataBloc..add(const GetVendorTypeList()),
        child: BlocConsumer<VendorDataBloc, VendorDataState>(
          listener: (context, state) async {
            if(state is VendorDataLoading){
              EasyLoading.show();
            }
            if (state is VendorTypeListLoaded) {
              EasyLoading.dismiss();
              vendorType.clear();
              vendorType.addAll(state.resource ?? []);
              selectedVendorType = vendorType.firstWhere((element) => element['id'] == widget.vendor['type_id'],
                  orElse: () => {});
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
              child: ListView(
                children: [
                  Utils.getTextFormField(
                    'Vendor Name',
                    nameController,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (val) => val!.isEmpty ? 'Please enter vendor name' : null,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Utils.dropdownBox(
                          "Vendor Type",
                          vendorType,
                              (selectedValue) {},
                          initialSelection: selectedVendorType,
                          selectedKey: selectedVendorType,
                          labelKey: 'name',
                          topRRadius: 0,
                          bottomRRadius: 0,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            color: AppC.blue50,
                            border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField,
                            )),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8,
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => const VendorTypeAddUI()
                            )),
                            child: const Icon(
                              Icons.add,
                              color: AppC.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getTextFormField(
                    'Address',
                    addressController,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        InkWell(
                          onTap:_getCurrentLocation,
                          child: const Icon(Icons.location_on_outlined,color: AppC.appColor,)),
                       if(onTap) GestureDetector(
                         onTap:()async {
                           if(latitude!=null && longitude!=null)
                           {
                             final Uri mapsUri = Uri(
                             scheme: 'https',
                             host: 'www.google.com',
                             path: '/maps/search/ $latitude, $longitude',
                             queryParameters: {'q': '$latitude, $longitude'},
                           );
                           if (await canLaunchUrl(mapsUri) && latitude != null && longitude != null) {
                             await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                           } else {
                             throw 'Could not open the map.';
                           }
                           }

                          },
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(
                                40 * math.pi / 180),
                            child: const Icon(
                              Icons.navigation_outlined,
                              color: AppC.green,
                            ),
                          ),
                        ),
                        if(onTap)GestureDetector(
                          onTap: (){onTap=false;
                            setState(() {});},
                            child: const Icon(Icons.close,color: AppC.redAccent,)),
                        const SizedBox(width: 3,)
                      ],
                    )
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     if(latitude!=null && longitude!=null)
                       Utils.getText("Lat: $latitude, Long: $longitude",color: AppC.redAccent),
                     if(latitude==null && longitude==null)
                       Utils.getText(locationMessage!,color: AppC.redAccent),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getTextFormField(
                    'Phone',
                    phoneController,
                    textType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getTextFormField(
                    'Website',
                    websiteController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getBorderedMultilineTextField(
                    'Expertise',
                    expertiseController,
                    minLines: 2,
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getBorderedMultilineTextField(
                    'Description',
                    descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => _pickBusinessCardImages(ImageSource.gallery),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Num.subradiusButton),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_upload,
                            color: AppC.blue,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Utils.getText('Upload Business Card', color: AppC.blue),
                        ],
                      ),
                    ),
                  ),
                  if(businessCarImage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 100,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: businessCarImage.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10),
                          itemBuilder: (context, index) => CloseBadge(
                              onTapView: () {
                                ShowAttachmentsDialog.of.show(context,
                                    attachments: businessCarImage,
                                    title: "",
                                    currentAttachment: businessCarImage[index]);
                              },
                              onTapDelete: () {
                                var model = businessCarImage[index].toString().replaceAll(Str.STORAGE_BASE_URL, "");
                                var data = (widget.vendor['images'] as List?)?.where((element) => element['path'] == model).toList().firstOrNull;
                                //log("Data:\t${data['id']} : ${data['path'].toString().toStorageURL}", name: "REMOVE_DATA");
                                if (data != null) _removeImage(data['id']);
                                businessCarImage.removeAt(index);
                                setState(() {

                                });
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.sizeOf(context).height,
                                  minWidth: MediaQuery.sizeOf(context).width,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppC.grey.withValues(alpha: 0.2)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child:  ImageViewer(
                                  fit: BoxFit.cover,
                                  imageInput: businessCarImage[index],
                                  isNotImage:
                                  !((businessCarImage[index] as Object).isImage),
                                ),
                              )),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getElevatedButton(() => _save()),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
