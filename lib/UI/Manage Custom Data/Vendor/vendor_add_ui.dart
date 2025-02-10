import 'dart:io';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import '../../../Bloc/vendor_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utilities/image_pick_helper.dart';
import 'Vendor Types/vendor_type_view_ui.dart';

class VendorAddUI extends StatefulWidget {
  const VendorAddUI({super.key});

  @override
  State<VendorAddUI> createState() => _VendorAddUIState();
}

class _VendorAddUIState extends State<VendorAddUI> {
  late VendorDataBloc vendorDataBloc;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController vendorTypeController = TextEditingController();
  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<Map<String, dynamic>> imageFile = [];
  List<Map<String, dynamic>> vendorType = [];
  List<Map<String, dynamic>> _filteredVendorType = [];
  final FocusNode _vendorTypeFocusNode = FocusNode();
  dynamic selectedVendorType; // Variable to store selected vendor type
  bool _isSuggestionsVisible = false;
  bool isVendorFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    vendorDataBloc = VendorDataBloc();
    _filteredVendorType = vendorType;
    _vendorTypeFocusNode.addListener(() {
      if (!_vendorTypeFocusNode.hasFocus) {
        setState(() {
          _isSuggestionsVisible = false;
        });
      }
    });
  }

  void _filterSuggestions(String input) {
    setState(() {
      if (input.isEmpty) {
        _isSuggestionsVisible = false;
      } else {
        _filteredVendorType = vendorType
            .where((vendor) =>
                vendor['name']?.toLowerCase().contains(input.toLowerCase()) ??
                false)
            .toList();
        _isSuggestionsVisible =
            _filteredVendorType.isNotEmpty && _vendorTypeFocusNode.hasFocus;
      }
    });
  }

  void _saveVendor() {
    setState(() {
      isVendorFieldEmpty = nameController.text.isEmpty;
    });
    if (nameController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }

    final newVendor = {
      'name': nameController.text,
      'vendor_type': selectedVendorType,
      'address': addressController.text,
      'phone': phoneController.text,
      'expertise': expertiseController.text,
      'description': descriptionController.text,
      'images': imageFile,
    };
    Navigator.pop(context, newVendor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Add Vendor'),
        backgroundColor: AppC.appColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: AppC.white,
              ))
        ],
      ),
      body: BlocProvider(
        create: (context) => vendorDataBloc..add(const GetVendorTypeList()),
        child: BlocConsumer<VendorDataBloc, VendorDataState>(
          listener: (context, state) async {
            if (state is VendorTypeListLoaded) {
              _filteredVendorType.clear();
              _filteredVendorType.addAll(state.resource ?? []);
              vendorType = List.from(state.resource ?? []);
              _filteredVendorType = List.from(vendorType);
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: 20.padding,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils
                                .getTextFormField(
                              '',
                              nameController,
                              label: Utils.getText('Vendor Name',
                                  color: AppC.grey),
                              borderColor: isVendorFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isVendorFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Utils.getTextFormField('',
                        vendorTypeController,
                        label: Utils.getText(
                            'Vendor Type',
                            color: AppC.grey),
                        focusNode: _vendorTypeFocusNode,
                        suffixIcon: InkWell(
                          onTap: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorTypeUI()))
                          },
                            child: const Icon(Icons.add)),
                        onChangeCallback: (value) {
                          _filterSuggestions(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils
                                .getTextFormField(
                              '',
                              addressController,
                              label: Utils.getText('Address',
                                  color: AppC.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils
                                .getTextFormField(
                              '',
                              phoneController,
                              label: Utils.getText('Phone',
                                  color: AppC.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils
                                .getTextFormField(
                              '',
                              expertiseController,
                              label: Utils.getText('Expertise',
                                  color: AppC.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils
                                .getTextFormField(
                              '',
                              descriptionController,
                              label: Utils.getText('Description',
                                  color: AppC.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Num.subradiusButton))),
                          child: Utils.getOutlinedButton(
                              'Upload Business Card', () async {
                            await imagePickHelper
                                .getSingleImage(ImageSource.gallery)
                                .then((value) {
                              if (value != null) {
                                debugPrint(
                                    'value.path: ${value['path']}');
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: imageFile.isNotEmpty,
                        child: SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFile.length,
                            // Number of items in the list
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    (imageFile[index]['path'] ?? '')
                                            .isNotEmpty
                                        ? Utils
                                            .getOvalCachedImageNetworkDisplay(
                                                context,
                                                imageFile[index]
                                                        ['path'] ??
                                                    '')
                                        : ClipOval(
                                            child: Image.file(
                                              File(imageFile[index]
                                                      ['path'] ??
                                                  ''),
                                              width: 50.0,
                                              // Set the width as needed
                                              height: 50.0,
                                              // Set the width as needed
                                              fit: BoxFit
                                                  .cover, // You can use other BoxFit values to control how the image is displayed
                                            ),
                                          ),
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: InkWell(
                                        onTap: () {
                                          if ((imageFile[index]['path'] ??
                                                  '')
                                              .isEmpty) {
                                            imageFile.removeAt(index);
                                          } else {
                                            vendorDataBloc.add(
                                                DeleteImage(
                                                    id: imageFile[index]
                                                        ['id']));
                                            imageFile.removeAt(index);
                                          }
                                          // setState(() {});
                                          // receiptImageFile.removeAt(index);
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            color: AppC.red.shade400,
                                          ),
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                              Icons.clear_rounded,
                                              color: AppC.white,
                                              size: 15),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton(
                              'Save',
                              () {
                                _saveVendor();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_isSuggestionsVisible)
                    Positioned(
                      top: 140,
                      left: 0,
                      right: 0,
                      child: Material(
                        elevation: 4,
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredVendorType.length,
                            itemBuilder: (context, index) {
                              final vendortype = _filteredVendorType[index];
                              //print("VendorType:${vendortype}");
                              return ListTile(
                                title: Utils.getText(
                                    vendortype['name'].toString()),
                                onTap: () {
                                  vendorTypeController.text =
                                      vendortype['name'] ?? '';
                                  selectedVendorType =
                                      vendortype; // Save the selected VendorType
                                  _filterSuggestions(
                                      vendorTypeController.text);
                                  _vendorTypeFocusNode.unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
