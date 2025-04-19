//
// import 'dart:developer';
//
// import 'package:fairpytasker/core/app/extension/sized_extension.dart';
// import 'package:flutter/material.dart';
// import 'Bloc/location_data_bloc.dart';
// import '../../../Utilities/appC.dart';
// import '../../../Utilities/utils.dart';
//
// class LocationAddUI extends StatefulWidget {
//   const LocationAddUI({super.key, location});
//
//   @override
//   State<LocationAddUI> createState() => _LocationAddUIState();
// }
//
// class _LocationAddUIState extends State<LocationAddUI> {
//   late LocationDataBloc locationDataBloc;
//   TextEditingController locationController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   List<Map<String, dynamic>> addressesList = [];
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   void _save() {
//     formKey.currentState!.validate();
//     setState(() {});
//
//     if (locationController.text.isEmpty) {
//       return ;
//     }
//     final newLocation = {
//       'name': locationController.text,
//       'addresses': addressesList,
//     };
//     Navigator.pop(context, newLocation);
//   }
//
//   void _deleteAddress(int index) {
//     /*if (addressesList[index]['id'] != null) {
//       locationDataBloc.add(DeleteLocationEvent(
//           id: addressesList[index]['id']));
//     }*/
//     setState(() {
//       addressesList.removeAt(index);
//       print("addressesList\t$addressesList");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppC.white,
//       appBar: AppBar(
//         title: const Text('Add Location'),
//         backgroundColor: AppC.appColor,
//         automaticallyImplyLeading: false,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//               onPressed: ()=>Navigator.pop(context),
//               icon: const Icon(Icons.close)
//           ),
//         ],
//       ),
//       body: SafeArea(
//         minimum: 15.padding,
//         child: Form(
//           key: formKey,
//           autovalidateMode: AutovalidateMode.onUnfocus,
//           child: ListView(
//             children: [
//               Utils.getTextFormField(
//                 'Location Name',
//                 locationController,
//                 autoValidate: AutovalidateMode.onUserInteraction,
//                 validator: (val) => val!.isEmpty ? 'Please enter location name' : null,
//               ),
//               const SizedBox(height: 10),
//               Utils.getTextFormField(
//                 'Address',
//                 addressController,
//                 inputAction: TextInputAction.done,
//                 suffixIcon:
//                 InkWell(
//                   onTap: () {
//                     if (addressController.text.isNotEmpty) {
//                       setState(() {
//                         addressesList.add({
//                           'address': addressController.text,
//                         });
//                         addressController
//                             .clear(); // Clear the text field after adding
//                       });
//                     }
//                   },
//                   child: const Icon(Icons.add),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 8.0, // space between addresses
//                 runSpacing: 4.0, // space between rows if wrapped
//                 children: List.generate(addressesList.length, (address) {
//                   return Chip(
//                     label: Utils.getText(addressesList[address]['address'] ?? ''),
//                     deleteIcon: const Icon(Icons.close),
//                     deleteIconColor: Colors.redAccent,
//                     backgroundColor: AppC.lowGreen,
//                     onDeleted: () => _deleteAddress(address),
//                   );
//                 }),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Utils.getElevatedButton((){
//                       if (addressController.text.isNotEmpty) {
//                         setState(() {
//                           addressesList.add({
//                             'address': addressController.text,
//                           });
//                         });
//                       }
//                       _save();
//                     },),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
