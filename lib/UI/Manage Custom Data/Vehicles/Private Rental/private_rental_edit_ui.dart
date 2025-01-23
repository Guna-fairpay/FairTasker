import 'dart:io';

import 'package:fairpytasker/UI/Manage%20Custom%20Data/Customers/customer_view_ui.dart';
import 'package:flutter/material.dart';
import '../../../../Bloc/private_rental_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Event/private_rental_event.dart';
import '../../../../State/private_rental_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/image_pick_helper.dart';
import '../../../../Utilities/num.dart';
import '../../../../Utilities/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentalEditUI extends StatefulWidget {
  final Map<String, dynamic> rentalData;

  const RentalEditUI({super.key, required this.rentalData});

  @override
  State<RentalEditUI> createState() => _RentalEditUIState();
}

class _RentalEditUIState extends State<RentalEditUI> {
  late PrivateRentalBloc privateRentalBloc;
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController checkInDateController = TextEditingController();
  final TextEditingController checkOutDateController = TextEditingController();
  final TextEditingController checkInMileageController =
      TextEditingController();
  final TextEditingController checkOutMileageController =
      TextEditingController();
  final ImagePickHelper imagePickHelper = ImagePickHelper();
  final List<Map<String, dynamic>> receiptImageFile = [];
  final List<String> confirmationTypeList = ['Confirm', 'Close'];
  String? selectedConfirmationType;
  bool isVehicleFieldEmpty = false;
  bool isCustomerFieldEmpty = false;
  bool showCustomerList = false;
  List<Map<String, dynamic>> customer = [];
  List<Map<String, dynamic>> filteredCustomer = [];
  List<Map<String, dynamic>> vehicle = [];
  List<Map<String, dynamic>> filteredVehicle = [];
  final FocusNode customerFocusNode = FocusNode();
  dynamic selectedCustomer;
  final FocusNode vehicleFocusNode = FocusNode();
  final GlobalKey vehicleFieldKey = GlobalKey();
  final GlobalKey customerFieldKey = GlobalKey();
  List<String> vehicleSuggestionList = [];
  bool showVehicleList = false;
  List<String> customerSuggestionList = [];

  @override
  void initState() {
    super.initState();

    privateRentalBloc = PrivateRentalBloc();
    vehicleController.text = widget.rentalData['vehicle_name'] ?? '';
    if (widget.rentalData['customer'] is Map<String, dynamic>) {
      customerController.text =
          (widget.rentalData['customer']['first_name'] ?? '') +
              ' ' +
              (widget.rentalData['customer']['last_name'] ?? '');
    } else {
      return;
    }
    checkInDateController.text =
        widget.rentalData['rental']['check_in_date'] ?? '';
    checkOutDateController.text =
        widget.rentalData['rental']['check_out_date'] ?? '';
    checkInMileageController.text =
        (widget.rentalData['rental']['check_in_mileage'] ?? '').toString();
    checkOutMileageController.text =
        (widget.rentalData['rental']['check_out_mileage'] ?? '').toString();
    selectedConfirmationType = (widget.rentalData['rental']['rental_status'] ??
                confirmationTypeList[1]) ==
            1
        ? confirmationTypeList[0]
        : confirmationTypeList[1];
    privateRentalBloc.add(const GetPrivateRentalData());
    customerFocusNode.addListener(() {
      if (!customerFocusNode.hasFocus) {
        setState(() {
          showCustomerList = false;
        });
      }
    });
    vehicleFocusNode.addListener(() {
      if (!vehicleFocusNode.hasFocus) {
        setState(() {
          showVehicleList = false;
        });
      }
    });
  }

  Offset _getWidgetPosition(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject.localToGlobal(Offset.zero);
    } else {
      return Offset
          .zero; // Return a default position if RenderBox is not available
    }
  }

  void _saveRental() {
    setState(() {
      isVehicleFieldEmpty = vehicleController.text.isEmpty;
      isCustomerFieldEmpty = customerController.text.isEmpty;
    });
    if (customerController.text.isEmpty || vehicleController.text.isEmpty) {
      return Utils.showMobileToast("Please fill the required fields");
    }

    final updatedRental = {
      'vehicle': vehicleController.text,
      'customer': customerController.text,
      'checkin': checkInDateController.text,
      'checkout': checkOutDateController.text,
      // Include other fields if necessary
    };

    // Return the updated rental data to the previous screen
    Navigator.pop(context, updatedRental);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => privateRentalBloc..add(const GetCustomerData()),
        child: BlocConsumer<PrivateRentalBloc, PrivateRentalState>(
            listener: (context, state) async {
          if (state is PrivateRentalLoaded) {
            filteredVehicle.clear();
            filteredVehicle.addAll(state.data ?? []);
            vehicle = List.from(state.data ?? []);
            filteredVehicle = List.from(vehicle);
          } else if (state is CustomerLoaded) {
            filteredCustomer.clear();
            filteredCustomer.addAll(state.data ?? []);
            customer = List.from(state.data ?? []);
            filteredCustomer = List.from(customer);
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          Utils.getText('Edit Private Rental',
                              size: 20, weight: FontWeight.bold)
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
                            Container(
                              key: vehicleFieldKey, // Assign key here
                              child: Utils
                                  .getTextFormField(
                                      'Vehicle', vehicleController,
                                      borderColor: isVehicleFieldEmpty
                                          ? Colors.red
                                          : AppC.fieldBase,
                                      focusNode: vehicleFocusNode,
                                      onChangeCallback: (value) async {
                                setState(() {
                                  vehicleSuggestionList.clear();
                                  if (value.isNotEmpty) {
                                    List taskList = filteredVehicle
                                        .map((e) => e['vehicle_name'] ?? '')
                                        .toList();
                                    vehicleSuggestionList.addAll(
                                        Utils.searchList(taskList, value));
                                    showVehicleList =
                                        vehicleSuggestionList.isNotEmpty;
                                  } else {
                                    showVehicleList = false;
                                  }
                                });
                              }),
                            ),
                            if (isVehicleFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error, color: Colors.red),
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
                            Utils.getTextFormField(
                                'Customer', customerController,
                                borderColor: isCustomerFieldEmpty
                                    ? Colors.red
                                    : AppC.fieldBase,
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 40),
                                focusNode: customerFocusNode,
                                onChangeCallback: (value) async {
                              setState(() {
                                customerSuggestionList.clear();
                                if (value.isNotEmpty) {
                                  List taskList = filteredCustomer
                                      .map((e) =>
                                          (e['first_name'] ?? '') +
                                          ' ' +
                                          (e['last_name'] ?? ''))
                                      .toList();
                                  customerSuggestionList.addAll(
                                      Utils.searchList(taskList, value));
                                  showCustomerList =
                                      customerSuggestionList.isNotEmpty;
                                } else {
                                  showCustomerList = false;
                                }
                              });
                            }),
                            if (isCustomerFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerViewUi()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: AppC.grey.shade300,
                                        borderRadius:
                                            const BorderRadiusDirectional.only(
                                          topEnd: Radius.circular(4),
                                          bottomEnd: Radius.circular(4),
                                        )),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          '',
                          checkInDateController,
                          suffixIcon: const Icon(
                            Icons.date_range,
                            color: AppC.appColor,
                          ),
                          readOnly: true,
                          onTapCallback: () {
                            Utils.datePicker(context, '',
                                    initial: DateTime.parse("1970-01-01"))
                                .then((value) {
                              if (value != null) {
                                checkInDateController.text =
                                    Utils.convertDateTimeToTheFormat(
                                        value.toString());
                              }
                            });
                          },
                          label:
                              Utils.getText('CheckIn date', color: AppC.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          '',
                          checkOutDateController,
                          suffixIcon: const Icon(
                            Icons.date_range,
                            color: AppC.appColor,
                          ),
                          readOnly: true,
                          onTapCallback: () {
                            Utils.datePicker(context, '',
                                    initial: DateTime.parse("1970-01-01"))
                                .then((value) {
                              if (value != null) {
                                checkOutDateController.text =
                                    Utils.convertDateTimeToTheFormat(
                                        value.toString());
                              }
                            });
                          },
                          label:
                              Utils.getText('Checkout date', color: AppC.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          'CheckIn Mileage',
                          checkInMileageController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          'Checkout mileage',
                          checkOutMileageController,
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
                              Radius.circular(Num.subradiusButton),
                            ),
                          ),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('Transaction Type',
                                  color: AppC.grey),
                            ),
                            value: selectedConfirmationType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 0,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? value) {
                              selectedConfirmationType = value;
                              setState(() {});
                            },
                            items: confirmationTypeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Utils.getText(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppC.fieldBase,
                                  width: Num.borderWidthField,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Num.subradiusButton),
                                ),
                              ),
                              child: Utils.getOutlinedButton(
                                'Choose image',
                                () async {
                                  await imagePickHelper
                                      .getSingleImage(ImageSource.gallery)
                                      .then((value) {
                                    if (value != null) {
                                      debugPrint('value.path: ${value.path}');
                                      // Attachments ve = Attachments(file: value, path: '');
                                      receiptImageFile
                                          .add({'file': value, 'path': ''});
                                      setState(() {});
                                    }
                                  });
                                },
                                iconData: const Icon(Icons.cloud_upload,
                                    color: AppC.appColor, size: 15),
                                verticalPadding: 0,
                                radius: BorderRadius.zero,
                                bgColor: AppC.trans,
                                borderColor: AppC.trans,
                                textColor: AppC.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: receiptImageFile.isNotEmpty,
                        child: SizedBox(
                          height: 80, // Set a height for the ListView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: receiptImageFile.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    (receiptImageFile[index]['path'] ?? '')
                                            .isNotEmpty
                                        ? Utils
                                            .getOvalCachedImageNetworkDisplay(
                                                context,
                                                receiptImageFile[index]
                                                        ['path'] ??
                                                    '')
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.file(
                                              File(receiptImageFile[index]
                                                          ['file']
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
                                          if ((receiptImageFile[index]
                                                      ['path'] ??
                                                  '')
                                              .isEmpty) {
                                            receiptImageFile.removeAt(index);
                                          } else {
                                            // vehicleDataBloc.add(
                                            //   DeleteExpenseImage(id: receiptImageFile[index]['id']),);
                                            receiptImageFile.removeAt(index);
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
                                            size: 16,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton(
                              'Save',
                              () {
                                _saveRental();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showVehicleList,
                child: Positioned(
                  top: _getWidgetPosition(vehicleFieldKey).dy -
                      15, // Adjust offset as needed
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Utils.customAutoCompleteList(
                      vehicleSuggestionList,
                      (index) {
                        setState(() {
                          showVehicleList = false;
                          vehicleController.text = vehicleSuggestionList[index];
                          vehicleController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: vehicleController.text.length),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showCustomerList,
                child: Positioned(
                  top: _getWidgetPosition(customerFieldKey).dy +
                      150, // Adjust offset as needed
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Utils.customAutoCompleteList(
                      customerSuggestionList,
                      (index) {
                        setState(() {
                          showCustomerList = false;
                          customerController.text =
                              customerSuggestionList[index];
                          customerController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: customerController.text.length),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
