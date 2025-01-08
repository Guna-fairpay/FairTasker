import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/image_pick_helper.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class CustomerEditUi extends StatefulWidget {
  final Map<String, dynamic> customer;

  const CustomerEditUi({super.key, required this.customer});

  @override
  State<CustomerEditUi> createState() => _CustomerEditUiState();
}

class _CustomerEditUiState extends State<CustomerEditUi> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController monthlyRentalController = TextEditingController();
  final TextEditingController selectDateController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>> licenseImageFile = [];
  List<Map<String, dynamic>> insuranceImageFile = [];
  late ImagePickHelper imagePickHelper;
  bool isFirstNameFieldEmpty = false;
  bool isLastNameFieldEmpty = false;
  bool isPhoneFieldEmpty = false;
  bool isMonthlyRentalFieldEmpty = false;
  bool isDateFieldEmpty = false;
  bool isSecurityDepositEmpty = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    imagePickHelper = ImagePickHelper();
    firstnameController.text = (widget.customer['first_name']);
    lastnameController.text = (widget.customer['last_name']);
    phoneController.text = (widget.customer['phone']);
    monthlyRentalController.text =
        (widget.customer['monthly_rental']).toString();
    selectDateController.text = (widget.customer['rental_start_date']);
    securityDepositController.text =
        (widget.customer['security_deposit']).toString();
    addressController.text = (widget.customer['address']);
    // notesController .text = (widget.customer['note']);
    Utils.getStringListPreference(Str.rolePrefText).then((role) {
      setState(() {
        userRole = role
            .first; // Assuming role is a List<String> and fetching the first value
      });
    });
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    monthlyRentalController.dispose();
    selectDateController.dispose();
    securityDepositController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isFirstNameFieldEmpty = firstnameController.text.isEmpty;
      isLastNameFieldEmpty = lastnameController.text.isEmpty;
      isPhoneFieldEmpty = phoneController.text.isEmpty;
      isMonthlyRentalFieldEmpty = monthlyRentalController.text.isEmpty;
      isDateFieldEmpty = selectDateController.text.isEmpty;
      isSecurityDepositEmpty = securityDepositController.text.isEmpty;
    });

    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        monthlyRentalController.text.isEmpty ||
        selectDateController.text.isEmpty ||
        securityDepositController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required fields');
    }

    final updatedCustomer = {
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'monthly_rental': monthlyRentalController.text,
      'rental_start_date': selectDateController.text,
      'security_deposit': securityDepositController.text,
      'note': notesController.text,
      //'licenceAttach':licenseImageFile,
      // 'insuranceAttach':insuranceImageFile,
      'id': widget.customer['id'],
    };

    Navigator.of(context).pop(updatedCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Utils.getText('Edit Customer',
                      size: 20, weight: FontWeight.bold),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '',
                      firstnameController,
                      label: Utils.getText('First Name', color: AppC.grey),
                      borderColor:
                          isFirstNameFieldEmpty ? Colors.red : AppC.fieldBase,
                    ),
                    if (isFirstNameFieldEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
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
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '',
                      lastnameController,
                      label: Utils.getText('Last Name', color: AppC.grey),
                      borderColor:
                          isLastNameFieldEmpty ? Colors.red : AppC.fieldBase,
                    ),
                    if (isLastNameFieldEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
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
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                        '', phoneController,
                        label: Utils.getText('Phone', color: AppC.grey),
                        borderColor:
                            isPhoneFieldEmpty ? Colors.red : AppC.fieldBase,
                        textType: TextInputType.number),
                    if (isPhoneFieldEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                  '',
                  addressController,
                  label: Utils.getText('Address', color: AppC.grey),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '',
                      monthlyRentalController,
                      label: Utils.getText('Monthly Rental', color: AppC.grey),
                      borderColor: isMonthlyRentalFieldEmpty
                          ? Colors.red
                          : AppC.fieldBase,
                    ),
                    if (isMonthlyRentalFieldEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
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
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '',
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
                                initial: DateTime.parse("1970-01-01"))
                            .then((value) {
                          if (value != null) {
                            selectDateController.text =
                                Utils.convertDateTimeToTheFormats(
                                    value.toString());
                          }
                        });
                      },
                      label: Utils.getText('Select Date', color: AppC.grey),
                      borderColor:
                          isDateFieldEmpty ? Colors.red : AppC.fieldBase,
                    ),
                    if (isDateFieldEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
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
                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                      '',
                      securityDepositController,
                      label:
                          Utils.getText('Security Deposit', color: AppC.grey),
                      borderColor:
                          isSecurityDepositEmpty ? Colors.red : AppC.fieldBase,
                    ),
                    if (isSecurityDepositEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.error_outline, color: Colors.red),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                  '',
                  notesController,
                  label: Utils.getText('Notes', color: AppC.grey),
                ),
              ),
              const SizedBox(height: 20),
              if (userRole == 'Admin')
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
                    child: Utils.getOutlinedButton('Upload License', () async {
                      await imagePickHelper
                          .getSingleImage(ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          debugPrint('value.path: ${value.path}');
                          //Attachments ve = Attachments(file: value, path: '');
                          licenseImageFile.add({'file': value, 'path': ''});
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
              if (userRole == 'Admin')
                const SizedBox(
                  height: 15,
                ),
              if (userRole == 'Admin')
                Visibility(
                  visible: licenseImageFile.isNotEmpty,
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: licenseImageFile.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              (licenseImageFile[index]['path'] ?? '').isNotEmpty
                                  ? Utils.getOvalCachedImageNetworkDisplay(
                                      context,
                                      licenseImageFile[index]['path'] ?? '')
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        File(licenseImageFile[index]['file']
                                                ?.path ??
                                            ''),
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: InkWell(
                                  onTap: () {
                                    if ((licenseImageFile[index]['path'] ?? '')
                                        .isEmpty) {
                                      licenseImageFile.removeAt(index);
                                    } else {
                                      // vehicleDataBloc.add(DeleteVehicleImage(id: imageFile[index]['id']));
                                      // imageFile.removeAt(index);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppC.red.shade400,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: AppC.white,
                                        size: 16),
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
              if (userRole == 'Admin')
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
                    child: Utils.getOutlinedButton('Upload Insurance',
                        () async {
                      await imagePickHelper
                          .getSingleImage(ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          debugPrint('value.path: ${value.path}');
                          //Attachments ve = Attachments(file: value, path: '');
                          insuranceImageFile.add({'file': value, 'path': ''});
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
              if (userRole == 'Admin')
                const SizedBox(
                  height: 10,
                ),
              if (userRole == 'Admin')
                Visibility(
                  visible: insuranceImageFile.isNotEmpty,
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: insuranceImageFile.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              (insuranceImageFile[index]['path'] ?? '')
                                      .isNotEmpty
                                  ? Utils.getOvalCachedImageNetworkDisplay(
                                      context,
                                      insuranceImageFile[index]['path'] ?? '')
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        File(insuranceImageFile[index]['file']
                                                ?.path ??
                                            ''),
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: InkWell(
                                  onTap: () {
                                    if ((insuranceImageFile[index]['path'] ??
                                            '')
                                        .isEmpty) {
                                      insuranceImageFile.removeAt(index);
                                    } else {
                                      // vehicleDataBloc.add(DeleteVehicleImage(id: imageFile[index]['id']));
                                      // imageFile.removeAt(index);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppC.red.shade400,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: AppC.white,
                                        size: 16),
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    child: Utils.getAddFilledButton('Save', () {
                      _save();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
