
import 'dart:io';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Component/close_badge.dart';
import '../../../Component/image_viewer.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import '../../dialog/show_attachments_dialog.dart';

class CustomerAddUI extends StatefulWidget {
  const CustomerAddUI({super.key});

  @override
  State<CustomerAddUI> createState() => _CustomerAddUIState();
}

class _CustomerAddUIState extends State<CustomerAddUI> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController monthlyRentalController = TextEditingController();
  TextEditingController selectDateController = TextEditingController();
  TextEditingController securityDepositController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<dynamic> licenseImages = [];
  List<dynamic> insuranceImages = [];
  bool isFirstNameFieldEmpty = false;
  bool isLastNameFieldEmpty = false;
  bool isPhoneFieldEmpty = false;
  bool isMonthlyRentalFieldEmpty = false;
  bool isDateFieldEmpty = false;
  bool isSecurityDepositEmpty = false;
  String? userRole;
  String? userId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadUserId();
  }

  Future<void> _loadUserRole() async {
    final role = await Utils.getStringListPreference(Str.rolePrefText);
    if (role.isNotEmpty) {
      setState(() {
        userRole = role[0];
      });
    }
  }

  Future<void> _loadUserId() async {
    final id = await Utils.getStringPreference(Str.userIdPrefText);
    setState(() {
      userId = id;
    });
  }

  void _pickLicenseImages(ImageSource source) async {
    List<File> selectedImages = await Utils.pickImages(source);
    if (selectedImages.isNotEmpty) {
      setState(() {
        licenseImages.addAll(selectedImages);
      });
    }
  }

  void _pickInsuranceImages(ImageSource source) async {
    List<File> selectedImages = await Utils.pickImages(source);
    if (selectedImages.isNotEmpty) {
      setState(() {
        insuranceImages.addAll(selectedImages);
      });
    }
  }

  void _save() {

    _formKey.currentState!.validate();
    setState(() {});
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        monthlyRentalController.text.isEmpty ||
        selectDateController.text.isEmpty ||
        securityDepositController.text.isEmpty) {
      return ;
    }
    final newCustomer = {
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'monthly_rental': monthlyRentalController.text,
      'rental_start_date': selectDateController.text,
      'security_deposit': securityDepositController.text,
      'note': notesController.text,
      'licenceAttach':licenseImages.whereType<File>().map((e) => e).toList(),
      'insuranceAttach':insuranceImages.whereType<File>().map((e) => e).toList(),
    };

    Navigator.pop(context, newCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
          backgroundColor: AppC.appColor,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          title: const Text('Add Customer'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,),)]
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'First Name',
                firstnameController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter first name' : null,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Last Name',
                lastnameController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter last name' : null,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                  'Phone', phoneController,
                  autoValidate: AutovalidateMode.onUserInteraction,
                  validator: (val) => val!.isEmpty ? 'Please enter phone number' : null,
                  textType: TextInputType.phone
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Address',
                addressController,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Monthly Rental',
                monthlyRentalController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter monthly rental' : null,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Rent Date',
                selectDateController,
                suffixIcon: Padding(
                  padding: isDateFieldEmpty
                      ? const EdgeInsets.only(right: 35)
                      : const EdgeInsets.all(0),
                  child:
                  const Icon(Icons.date_range, color: AppC.appColor),
                ),
                readOnly: true,
                onTapCallback: () {
                  Utils.datePicker(context, '',
                      initial:DateTime.tryParse(selectDateController.text)?? DateTime.now())
                      .then((value) {
                    if (value != null) {
                      selectDateController.text =
                          Utils.convertDateToYearMonthDateFormat(
                              value.toString());
                    }
                  });
                },
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please select rent date' : null,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Security Deposit',
                securityDepositController,
                autoValidate: AutovalidateMode.onUserInteraction,
                validator: (val) => val!.isEmpty ? 'Please enter security deposit' : null,
              ),
              const SizedBox(height: 10),
              Utils.getTextFormField(
                'Notes',
                notesController,
              ),
              const SizedBox(height: 10),
              if (userRole == 'Admin'|| userId == '3')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    InkWell(
                      onTap: () => _pickLicenseImages(ImageSource.gallery),
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
                            Utils.getText('Upload License', color: AppC.blue),
                          ],
                        ),
                      ),
                    ),
                    if(licenseImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: licenseImages.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10),
                          itemBuilder: (context, index) => CloseBadge(
                              onTapView: () {
                                ShowAttachmentsDialog.of.show(context,
                                    attachments: licenseImages,
                                    title: "",
                                    currentAttachment: licenseImages[index]);
                              },
                              onTapDelete: () {
                                // var model = _insuranceImages[index].toString().replaceAll(Str.STORAGE_BASE_URL, "");
                                // var data = (_insuranceImages['attachments'] as List?)?.where((element) => element['path'] == model).toList().firstOrNull;
                                // log("Data:\t${data['id']} : ${data['path'].toString().toStorageURL}", name: "REMOVE_DATA");
                                // if (data != null) _removeImage(data['id']);
                                licenseImages.removeAt(index);
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
                                  imageInput: licenseImages[index],
                                  isNotImage:
                                  !((licenseImages[index] as Object).isImage),
                                ),
                              )),
                        ),
                      ),
                    InkWell(
                      onTap: () => _pickInsuranceImages(ImageSource.gallery),
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
                            Utils.getText('Upload Insurance', color: AppC.blue),
                          ],
                        ),
                      ),
                    ),
                    if(insuranceImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: insuranceImages.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10),
                          itemBuilder: (context, index) => CloseBadge(
                              onTapView: () {
                                ShowAttachmentsDialog.of.show(context,
                                    attachments: insuranceImages,
                                    title: "",
                                    currentAttachment: insuranceImages[index]);
                              },
                               onTapDelete: () {
                              //   var model = _insuranceImages[index].toString().replaceAll(Str.STORAGE_BASE_URL, "");
                              //   var data = (_insuranceImages['attachments'] as List?)?.where((element) => element['path'] == model).toList().firstOrNull;
                              //   log("Data:\t${data['id']} : ${data['path'].toString().toStorageURL}", name: "REMOVE_DATA");
                              //   if (data != null) _removeImage(data['id']);
                                 insuranceImages.removeAt(index);
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
                                  imageInput: insuranceImages[index],
                                  isNotImage:
                                  !((insuranceImages[index] as Object).isImage),
                                ),
                              )),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Utils.getElevatedButton( () =>  _save()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
