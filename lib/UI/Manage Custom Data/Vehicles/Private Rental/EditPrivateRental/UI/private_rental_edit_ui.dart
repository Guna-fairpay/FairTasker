
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/UI/edit_private_rental_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PrivateRentalEditUI extends StatelessWidget {
  final dynamic rentalData;
  const PrivateRentalEditUI({super.key,required this.rentalData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPrivateRentalBloc>(
      create: (context)=>EditPrivateRentalBloc()..add(EditPrivateRentalInitialEvent(rentalData: rentalData)),
      child: BlocListener<EditPrivateRentalBloc, EditPrivateRentalState>(
        listener: (context, state) {
          if (state is EditPrivateRentalLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Private Rental Edit UI'),
              backgroundColor: AppC.appColor,
              foregroundColor: AppC.white,
              automaticallyImplyLeading: false,
              actions:[
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ]
          ),
          body: const EditPrivateRentalBody(),
        ),
      ),
    );
  }
}

// class RentalAddUI extends StatefulWidget {
//   const RentalAddUI({super.key});
//
//   @override
//   State<RentalAddUI> createState() => _RentalAddUI();
// }
//
// class _RentalAddUI extends State<RentalAddUI> {
//   late PrivateRentalBloc privateRentalBloc;
//   TextEditingController rentalController = TextEditingController();
//   TextEditingController vehicleController = TextEditingController();
//   TextEditingController customerController = TextEditingController();
//   TextEditingController checkInDateController = TextEditingController();
//   TextEditingController checkOutDateController = TextEditingController();
//   TextEditingController checkInMileageController = TextEditingController();
//   TextEditingController checkOutMileageController = TextEditingController();
//   TextEditingController fileController = TextEditingController();
//   ImagePickHelper imagePickHelper = ImagePickHelper();
//   List<Map<String, dynamic>> receiptImageFile = [];
//   List<String> confirmationTypeList = ['Confirm', 'Close'];
//   String? selectedConfirmationTypeList;
//   bool isVehicleFieldEmpty = false;
//   bool isCustomerFieldEmpty = false;
//   bool showCustomerList = false;
//   List<Map<String, dynamic>> customer = [];
//   List<Map<String, dynamic>> filteredCustomer = [];
//   final FocusNode customerFocusNode = FocusNode();
//   dynamic selectedCustomer;
//   List<Map<String, dynamic>> vehicle = [];
//   List<Map<String, dynamic>> filteredVehicle = [];
//   final FocusNode vehicleFocusNode = FocusNode();
//   final GlobalKey vehicleFieldKey = GlobalKey();
//   final GlobalKey customerFieldKey = GlobalKey();
//   List<String> vehicleSuggestionList = [];
//   bool showVehicleList = false;
//   List<String> customerSuggestionList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     privateRentalBloc = PrivateRentalBloc();
//     privateRentalBloc.add(const GetPrivateRentalData());
//     customerFocusNode.addListener(() {
//       if (!customerFocusNode.hasFocus) {
//         setState(() {
//           showCustomerList = false;
//         });
//       }
//     });
//     vehicleFocusNode.addListener(() {
//       if (!vehicleFocusNode.hasFocus) {
//         setState(() {
//           showVehicleList = false;
//         });
//       }
//     });
//   }
//
//   Offset _getWidgetPosition(GlobalKey key) {
//     final renderObject = key.currentContext?.findRenderObject();
//     if (renderObject is RenderBox) {
//       return renderObject.localToGlobal(Offset.zero);
//     } else {
//       return Offset
//           .zero; // Return a default position if RenderBox is not available
//     }
//   }
//
//   void _saveRental() {
//     setState(() {
//       isVehicleFieldEmpty = vehicleController.text.isEmpty;
//       isCustomerFieldEmpty = customerController.text.isEmpty;
//     });
//     if (vehicleController.text.isEmpty || customerController.text.isEmpty) {
//       return Utils.showMobileToast('Please fill in all required fields');
//     }
//
//     // Create a map with rental data
//     final newRental = {
//       'vin': vehicleController.text,
//       'customer_id': customerController.text,
//       'check_in_date': checkInDateController.text,
//       'check_out_date': checkOutDateController.text,
//       'check_in_mileage': checkInMileageController.text,
//       'check_out_mileage': checkOutMileageController.text,
//       'rental_status': selectedConfirmationTypeList ?? '',
//       // Add other fields if necessary
//     };
//
//     // Return the new rental data to the previous screen
//     Navigator.pop(context, newRental);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(35.0), // Change the height here
//         child: HeaderView(),
//       ),
//       body: BlocProvider(
//         create: (context) => privateRentalBloc..add(const GetCustomerData()),
//         child: BlocConsumer<PrivateRentalBloc, PrivateRentalState>(
//             listener: (context, state) async {
//           if (state is PrivateRentalLoaded) {
//             filteredVehicle.clear();
//             filteredVehicle.addAll(state.data ?? []);
//             vehicle = List.from(state.data ?? []);
//             filteredVehicle = List.from(vehicle);
//           } else if (state is CustomerLoaded) {
//             filteredCustomer.clear();
//             filteredCustomer.addAll(state.data ?? []);
//             customer = List.from(state.data ?? []);
//             filteredCustomer = List.from(customer);
//           }
//         }, builder: (context, state) {
//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(Icons.arrow_back),
//                           ),
//                           Utils.getText('Add Private Rental',
//                               size: 20, weight: FontWeight.bold)
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       SizedBox(
//                         height: 40,
//                         child: Stack(
//                           alignment: Alignment.centerRight,
//                           children: [
//                             Container(
//                               key: vehicleFieldKey, // Assign key here
//                               child: Utils
//                                   .getTextFormField(
//                                       'Vehicle', vehicleController,
//                                       borderColor: isVehicleFieldEmpty
//                                           ? Colors.red
//                                           : AppC.fieldBase,
//                                       focusNode: vehicleFocusNode,
//                                       onChangeCallback: (value) async {
//                                 setState(() {
//                                   vehicleSuggestionList.clear();
//                                   if (value.isNotEmpty) {
//                                     List taskList = filteredVehicle
//                                         .map((e) => e['vehicle_name'] ?? '')
//                                         .toList();
//                                     vehicleSuggestionList.addAll(
//                                         Utils.searchList(taskList, value));
//                                     showVehicleList =
//                                         vehicleSuggestionList.isNotEmpty;
//                                   } else {
//                                     showVehicleList = false;
//                                   }
//                                 });
//                               }),
//                             ),
//                             if (isVehicleFieldEmpty)
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 10),
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child: Stack(
//                           alignment: Alignment.centerRight,
//                           children: [
//                             Utils.getTextFormField(
//                                 'Customer', customerController,
//                                 borderColor: isCustomerFieldEmpty
//                                     ? Colors.red
//                                     : AppC.fieldBase,
//                                 contentPadding:
//                                     const EdgeInsets.only(left: 10, right: 40),
//                                 focusNode: customerFocusNode,
//                                 onChangeCallback: (value) async {
//                               setState(() {
//                                 customerSuggestionList.clear();
//                                 if (value.isNotEmpty) {
//                                   List taskList = filteredCustomer
//                                       .map((e) =>
//                                           (e['first_name'] ?? '') +
//                                           ' ' +
//                                           (e['last_name'] ?? ''))
//                                       .toList();
//                                   customerSuggestionList.addAll(
//                                       Utils.searchList(taskList, value));
//                                   showCustomerList =
//                                       customerSuggestionList.isNotEmpty;
//                                 } else {
//                                   showCustomerList = false;
//                                 }
//                               });
//                             }),
//                             if (isCustomerFieldEmpty)
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 30),
//                                 child: Icon(Icons.error, color: Colors.red),
//                               ),
//                             Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const CustomerViewUi()));
//                                   },
//                                   child: Container(
//                                     height: 40,
//                                     width: 30,
//                                     decoration: BoxDecoration(
//                                         color: AppC.grey.shade300,
//                                         borderRadius:
//                                             const BorderRadiusDirectional.only(
//                                           topEnd: Radius.circular(4),
//                                           bottomEnd: Radius.circular(4),
//                                         )),
//                                     child: const Icon(
//                                       Icons.add,
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child:
//                             Utils.getTextFormField(
//                           '',
//                           checkInDateController,
//                           suffixIcon: const Icon(
//                             Icons.date_range,
//                             color: AppC.appColor,
//                           ),
//                           readOnly: true,
//                           onTapCallback: () {
//                             Utils.datePicker(context, '',
//                                     initial: DateTime.parse("1970-01-01"))
//                                 .then((value) {
//                               if (value != null) {
//                                 checkInDateController.text =
//                                     Utils.convertDateTimeToTheFormat(
//                                         value.toString());
//                               }
//                             });
//                           },
//                           label:
//                               Utils.getText('CheckIn date', color: AppC.grey),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child:
//                             Utils.getTextFormField(
//                           '',
//                           checkOutDateController,
//                           suffixIcon: const Icon(
//                             Icons.date_range,
//                             color: AppC.appColor,
//                           ),
//                           readOnly: true,
//                           onTapCallback: () {
//                             Utils.datePicker(context, '',
//                                     initial: DateTime.parse("1970-01-01"))
//                                 .then((value) {
//                               if (value != null) {
//                                 checkOutDateController.text =
//                                     Utils.convertDateTimeToTheFormat(
//                                         value.toString());
//                               }
//                             });
//                           },
//                           label:
//                               Utils.getText('Checkout date', color: AppC.grey),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child:
//                             Utils.getTextFormField(
//                           'CheckIn Mileage',
//                           checkInMileageController,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child:
//                             Utils.getTextFormField(
//                           'Checkout mileage',
//                           checkOutMileageController,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 40,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: AppC.fieldBase,
//                               width: Num.borderWidthField,
//                             ),
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(Num.subradiusButton),
//                             ),
//                           ),
//                           child: DropdownButton<String>(
//                             hint: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10.0),
//                               child: Utils.getText('Transaction Type',
//                                   color: AppC.grey),
//                             ),
//                             value: selectedConfirmationTypeList,
//                             isExpanded: true,
//                             icon: const Icon(Icons.arrow_drop_down),
//                             elevation: 0,
//                             underline: Container(
//                               height: 0,
//                               color: Colors.transparent,
//                             ),
//                             onChanged: (String? value) {
//                               selectedConfirmationTypeList = value;
//                               setState(() {});
//                             },
//                             items: confirmationTypeList
//                                 .map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   child: Utils.getText(value),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Column(
//                         children: [
//                           SizedBox(
//                             height: 40,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: AppC.fieldBase,
//                                   width: Num.borderWidthField,
//                                 ),
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(Num.subradiusButton),
//                                 ),
//                               ),
//                               child: Utils.getOutlinedButton(
//                                 'Choose image',
//                                 () async {
//                                   await imagePickHelper
//                                       .getSingleImage(ImageSource.gallery)
//                                       .then((value) {
//                                     if (value != null) {
//                                       debugPrint('value.path: ${value.path}');
//                                       // Attachments ve = Attachments(file: value, path: '');
//                                       receiptImageFile
//                                           .add({'file': value, 'path': ''});
//                                       setState(() {});
//                                     }
//                                   });
//                                 },
//                                 iconData: const Icon(Icons.cloud_upload,
//                                     color: AppC.appColor, size: 15),
//                                 verticalPadding: 0,
//                                 radius: BorderRadius.zero,
//                                 bgColor: AppC.trans,
//                                 borderColor: AppC.trans,
//                                 textColor: AppC.grey,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Visibility(
//                         visible: receiptImageFile.isNotEmpty,
//                         child: SizedBox(
//                           height: 80,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: receiptImageFile.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5.0),
//                                 child: Stack(
//                                   alignment: Alignment.topRight,
//                                   children: [
//                                     (receiptImageFile[index]['path'] ?? '')
//                                             .isNotEmpty
//                                         ? Utils
//                                             .getOvalCachedImageNetworkDisplay(
//                                                 context,
//                                                 receiptImageFile[index]
//                                                         ['path'] ??
//                                                     '')
//                                         : ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(6),
//                                             child: Image.file(
//                                               File(receiptImageFile[index]
//                                                           ['file']
//                                                       ?.path ??
//                                                   ''),
//                                               width: 60.0,
//                                               height: 60.0,
//                                               fit: BoxFit.fill,
//                                             ),
//                                           ),
//                                     SizedBox(
//                                       width: 18,
//                                       height: 18,
//                                       child: InkWell(
//                                         onTap: () {
//                                           if ((receiptImageFile[index]
//                                                       ['path'] ??
//                                                   '')
//                                               .isEmpty) {
//                                             receiptImageFile.removeAt(index);
//                                           } else {
//                                             // vehicleDataBloc.add(DeleteVehicleImage(id: imageFile[index]['id']));
//                                             // imageFile.removeAt(index);
//                                           }
//                                           setState(() {});
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: AppC.red.shade400,
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: const Icon(
//                                               Icons.delete_outline_outlined,
//                                               color: AppC.white,
//                                               size: 16),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           SizedBox(
//                             height: 40,
//                             child: Utils.getAddFilledButton(
//                               'Save',
//                               () {
//                                 _saveRental();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: showVehicleList,
//                 child: Positioned(
//                   top: _getWidgetPosition(vehicleFieldKey).dy -
//                       15, // Adjust offset as needed
//                   left: 0,
//                   right: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Utils.customAutoCompleteList(
//                       vehicleSuggestionList,
//                       (index) {
//                         setState(() {
//                           showVehicleList = false;
//                           vehicleController.text = vehicleSuggestionList[index];
//                           vehicleController.selection =
//                               TextSelection.fromPosition(
//                             TextPosition(offset: vehicleController.text.length),
//                           );
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: showCustomerList,
//                 child: Positioned(
//                   top: _getWidgetPosition(customerFieldKey).dy +
//                       150, // Adjust offset as needed
//                   left: 0,
//                   right: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Utils.customAutoCompleteList(
//                       customerSuggestionList,
//                       (index) {
//                         setState(() {
//                           showCustomerList = false;
//                           customerController.text =
//                               customerSuggestionList[index];
//                           customerController.selection =
//                               TextSelection.fromPosition(
//                             TextPosition(
//                                 offset: customerController.text.length),
//                           );
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//       drawer: const DrawerView(),
//     );
//   }
// }
