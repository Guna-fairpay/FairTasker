
import 'dart:io';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import '../../../Bloc/vendor_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utilities/image_pick_helper.dart';
import 'Vendor Types/vendor_type_add_ui.dart';

class VendorEditUI extends StatefulWidget {
  final Map<String, dynamic> vendor;

  const VendorEditUI({super.key, required this.vendor});

  @override
  _VendorEditUIState createState() => _VendorEditUIState();
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
  List<dynamic> imageFile = [];
  List<Map<String, dynamic>> vendorType = [];
  dynamic selectedVendorType;
  bool isVendorFieldEmpty = false;
  File? fileType;

  @override
  void initState() {
    super.initState();
    vendorDataBloc = VendorDataBloc();
    nameController.text =  widget.vendor['name']??'';
    addressController.text = widget.vendor['address']??'';
    phoneController.text =  widget.vendor['phone']??'';
    expertiseController.text = widget.vendor['expertise']??'';
    descriptionController.text = widget.vendor['description']??'';
    vendorTypeController.text =  widget.vendor['vendor__type']?['name'] ?? '';
    imageFile.addAll(widget.vendor['images'] ?? []);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isVendorFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    final updatedVendor = {
      'id': widget.vendor['id'],
      'name': nameController.text,
      'vendor_type': selectedVendorType,
      'address': addressController.text,
      'phone': phoneController.text,
      'expertise': expertiseController.text,
      'description': descriptionController.text,
      'images': imageFile,
    };
    Navigator.pop(context, updatedVendor);
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
            if (state is VendorTypeListLoaded) {
              vendorType.clear();
              vendorType.addAll(state.resource ?? []);
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Utils.getTextFormField(
                        '',
                        nameController,
                        label: Utils.getText('Vendor Name', color: AppC.grey),
                        borderColor:
                        isVendorFieldEmpty ? Colors.red : AppC.fieldBase,
                      ),
                      if (isVendorFieldEmpty)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.error_outline, color: Colors.red),
                        ),
                    ],
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
                            onTap: () => VendorTypeAddUI,
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
                    '',
                    addressController,
                    label: Utils.getText('Address', color: AppC.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getTextFormField(
                    '',
                    phoneController,
                    label: Utils.getText('Phone', color: AppC.grey),
                    textType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getTextFormField(
                    '',
                    websiteController,
                    label: Utils.getText('Website', color: AppC.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getBorderedMultilineTextField(
                    '',
                    expertiseController,
                    label: Utils.getText('Expertise', color: AppC.grey),
                    minLines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Utils.getBorderedMultilineTextField(
                      '',
                      descriptionController,
                      label: Utils.getText('Description', color: AppC.grey),
                      minLines: 2
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: Num.borderWidthField,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton))),
                    child: Utils.getOutlinedButton('Upload Business Card',
                            () async {
                          await imagePickHelper
                              .getSingleImage(ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              debugPrint('value.path: ${value['path']}');
                              // VendorImages ve = VendorImages(
                              //     fileType: value, path: '');
                              imageFile.add({
                                'path': '',
                              });
                              setState(() {});
                            } else {
                              return;
                            }
                          });
                        },
                        iconData: const Icon(Icons.cloud_upload,
                            color: AppC.appColor, size: 15),
                        verticalPadding: 0,
                        radius: BorderRadius.zero,
                        bgColor: AppC.trans,
                        borderColor: AppC.trans,
                        textColor: AppC.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: imageFile.isNotEmpty,
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: imageFile.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                (imageFile[index]['path'] ?? '').isNotEmpty
                                    ? Utils.getOvalCachedImageNetworkDisplay(
                                    context, imageFile[index]['path'] ?? '')
                                    : ClipOval(
                                  child: Image.file(
                                    File(imageFile[index]['path'] ?? ''),
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: InkWell(
                                    onTap: () {
                                      if ((imageFile[index]['path'] ?? '')
                                          .isEmpty) {
                                        imageFile.removeAt(index);
                                      } else {
                                        vendorDataBloc.add(DeleteImage(
                                            id: imageFile[index]['id']));
                                        imageFile.removeAt(index);
                                      }
                                      // setState(() {});
                                      // receiptImageFile.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        color: AppC.red.shade400,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.clear_rounded,
                                          color: AppC.white, size: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getElevatedButton(() => _save(),
                          text: 'Save', bgColor: AppC.green),
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
