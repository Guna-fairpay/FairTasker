//
// import 'dart:io';
// import 'package:fairpytasker/Utilities/appC.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
// import 'package:fairpytasker/core/app/extension/sized_extension.dart';
// import 'package:fairpytasker/core/app/extension/string_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../Component/close_badge.dart';
// import '../../../Component/image_viewer.dart';
// import '../../../Response/create_expense_field_data.dart';
// import '../../../Utilities/image_pick_helper.dart';
// import '../../../Utilities/num.dart';
// import '../../../Response/create_vehicle_data.dart';
// import '../../../Bloc/vehicle_data_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../dialog/show_attachments_dialog.dart';
//
// class VehicleAddUI extends StatefulWidget {
//   const VehicleAddUI({super.key});
//
//   @override
//   State<VehicleAddUI> createState() => _VehicleAddUIState();
// }
//
// class _VehicleAddUIState extends State<VehicleAddUI> {
//   late VehicleDataBloc vehicleDataBloc;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   TextEditingController yearController = TextEditingController();
//   TextEditingController makeController = TextEditingController();
//   TextEditingController modelController = TextEditingController();
//   TextEditingController vehicleNoController = TextEditingController();
//   TextEditingController purchasePriceController = TextEditingController();
//   TextEditingController purchaseDateController = TextEditingController();
//   TextEditingController vinController = TextEditingController();
//   TextEditingController vehicleIdController = TextEditingController();
//
//   TextEditingController earningsController = TextEditingController();
//   TextEditingController utilizationRateController = TextEditingController();
//   TextEditingController platformController = TextEditingController();
//   TextEditingController mileageController = TextEditingController();
//   TextEditingController wholeSaleAmountController = TextEditingController();
//   CreateExpenseFieldData? createExpenseFieldData;
//   List<Map<String, dynamic>> cohortsData = [];
//   List<Map<String, dynamic>> categoriesData = [];
//   dynamic selectedVehicleStatus;
//   dynamic selectedCohortsData;
//
//   List<Map<String, dynamic>> vehicleStatusList = [
//     {'id': 1, 'name': 'Active'},
//     {'id': 2, 'name': 'InActive'},
//   ];
//   dynamic selectedStatus;
//   AnimationController? animationController;
//   ImagePickHelper imagePickHelper = ImagePickHelper();
//
//   CreateVehicleData? createVehicleData;
//   bool showMore = false;
//   bool isYearFieldEmpty = false;
//   bool isMakeFieldEmpty = false;
//   bool isModelFieldEmpty = false;
//   bool isPurchaseFieldEmpty = false;
//   bool isPurchaseDateFieldEmpty = false;
//   bool isSelected = false;
//
//   List<dynamic> vehicleImageFile = [];
//   List<dynamic> receiptImageFile = [];
//   List<dynamic> tireImageFile = [];
//   List<dynamic> tollImage = [];
//   List<dynamic> uploadRegSticker = [];
//   List<dynamic> insuranceImage = [];
//
//   TextEditingController addressController = TextEditingController();
//   TextEditingController carNumberController = TextEditingController();
//   TextEditingController oilGradeController = TextEditingController();
//   TextEditingController frontTireController = TextEditingController();
//   TextEditingController rearTireController = TextEditingController();
//   TextEditingController renewalDateController = TextEditingController();
//   TextEditingController plateNumberController = TextEditingController();
//
//   bool bouncie = false;
//   bool tollTags = false;
//   bool airTag = false;
//   bool permanentPlate = false;
//   bool spareTire = false;
//   bool spareKey = false;
//   bool frontLicensePlate = false;
//   Map<String, dynamic> cohortInitialSelection = {};
//
//   TextEditingController tollTagsController = TextEditingController();
//   TextEditingController spareTireController = TextEditingController();
//   TextEditingController insuranceCostController = TextEditingController();
//   TextEditingController insuranceAgentController = TextEditingController();
//   TextEditingController currentOdometerController = TextEditingController();
//   TextEditingController oilChangeOdometerController = TextEditingController();
//   TextEditingController maintenanceCheckController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     vehicleDataBloc = VehicleDataBloc();
//     vehicleDataBloc.add(const GetDropdownVehicleData());
//     vehicleDataBloc.add(const VehicleStatusCategory());
//     selectedStatus = vehicleStatusList[0];
//   }
//
//   @override
//   void dispose() {
//     vehicleDataBloc.close();
//     super.dispose();
//   }
//
//   void _save() {
//     if (!_formKey.currentState!.validate()) {
//       return ;
//     }
//     _formKey.currentState!.save();
//
//     setState(() {
//       isYearFieldEmpty = yearController.text.isEmpty;
//       isMakeFieldEmpty = makeController.text.isEmpty;
//       isModelFieldEmpty = modelController.text.isEmpty;
//       isPurchaseFieldEmpty = purchasePriceController.text.isEmpty;
//       isPurchaseDateFieldEmpty = purchaseDateController.text.isEmpty;
//     });
//     if (yearController.text.isEmpty ||
//         makeController.text.isEmpty ||
//         modelController.text.isEmpty ||
//         purchasePriceController.text.isEmpty ||
//         purchaseDateController.text.isEmpty) {
//       return Utils.showMobileToast('Please fill the required fields');
//     }
//
//     final createVehicleData = CreateVehicleData();
//     createVehicleData.year = yearController.text;
//     createVehicleData.make = makeController.text;
//     createVehicleData.model = modelController.text;
//     createVehicleData.vehicleNumber = vehicleNoController.text;
//     createVehicleData.selectedCohort = selectedCohortsData?['id'];
//     createVehicleData.vin = vinController.text;
//     createVehicleData.vehicleId = vehicleIdController.text;
//     createVehicleData.purchaseDate = purchaseDateController.text;
//     createVehicleData.purchasePrice = purchasePriceController.text;
//     createVehicleData.purchaseReceiptsImage = receiptImageFile.whereType<File>().map((e) => e).toList();
//     createVehicleData.vehicleImage = vehicleImageFile.whereType<File>().map((e) => e).toList();
//     createVehicleData.earnings = earningsController.text;
//     createVehicleData.utilizationRate = utilizationRateController.text;
//     createVehicleData.platform = platformController.text;
//     createVehicleData.mileage = mileageController.text;
//     createVehicleData.wholesaleAmount = wholeSaleAmountController.text;
//     createVehicleData.selectedVehicleStatus = selectedVehicleStatus?['id'];
//     createVehicleData.isActive = selectedStatus['id'] == 1 ? 1 : 0;
//     createVehicleData.address = addressController.text;
//     createVehicleData.bouncie = bouncie ? 1 : 0;
//     createVehicleData.airTag = airTag ? 1 : 0;
//     createVehicleData.tollTag = tollTags ? 1 : 0;
//     createVehicleData.spareTire = spareTire ? 1 : 0;
//     createVehicleData.tollTagsId=tollTagsController.text;
//     createVehicleData.tollImage = tollImage.whereType<File>().map((e) => e).toList();
//     createVehicleData.tireSize=spareTireController.text;
//     createVehicleData.spareKey=spareKey?1:0;
//     createVehicleData.permanentPlate = permanentPlate ? 1 : 0;
//     createVehicleData.frontLicensePlate = frontLicensePlate ? 1 : 0;
//     createVehicleData.tireImage = tireImageFile.whereType<File>().map((e) => e).toList();
//     createVehicleData.numberPlate=plateNumberController.text;
//     createVehicleData.carNumber = carNumberController.text;
//     createVehicleData.oilGrade = oilGradeController.text;
//     createVehicleData.frontTire = frontTireController.text;
//     createVehicleData.rearTire = rearTireController.text;
//     createVehicleData.regStickerDate = renewalDateController.text;
//     createVehicleData.uploadRegSticker = uploadRegSticker.whereType<File>().map((e) => e).toList();
//     createVehicleData.currentOdometer=currentOdometerController.text;
//     createVehicleData.oilChangeOdometer=oilChangeOdometerController.text;
//     createVehicleData.maintenanceCheck=maintenanceCheckController.text;
//     createVehicleData.insuranceAgent=insuranceAgentController.text;
//     createVehicleData.insuranceCost=insuranceCostController.text;
//     createVehicleData.insuranceImage = insuranceImage.whereType<File>().map((e) => e).toList();
//
//     final newVehicle = createVehicleData;
//
//     Navigator.pop(context, newVehicle);
//   }
//
//   Widget checkBoxWithSingleText({
//     required bool value,
//     required ValueChanged<bool?> onChanged,
//     required String label,
//     double scale = 1.0,
//   }) {
//     return Row(
//       children: [
//         Transform.scale(
//           scale: scale, // Adjust the scale here
//           child: SizedBox(
//             height: 15,
//             child: Checkbox(
//               activeColor: AppC.blue,
//               value: value,
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//         Utils.getText(label),
//       ],
//     );
//   }
//
//   void _pickReceiptImageFile(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         receiptImageFile.addAll(selectedImages);
//       });
//     }
//   }
//
//   void _pickVehicleImageFile(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         vehicleImageFile.addAll(selectedImages);
//       });
//     }
//   }
//
//   void _pickTollImage(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         tollImage.addAll(selectedImages);
//       });
//     }
//   }
//
//   void _pickTireImageFile(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         tireImageFile.addAll(selectedImages);
//       });
//     }
//   }
//
//   void _pickUploadRegSticker(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         uploadRegSticker.addAll(selectedImages);
//       });
//     }
//   }
//
//   void _pickInsuranceImage(ImageSource source) async {
//     List<File> selectedImages = await Utils.pickImages(source);
//     if (selectedImages.isNotEmpty) {
//       setState(() {
//         insuranceImage.addAll(selectedImages);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppC.white,
//       appBar: AppBar(
//         title: const Text('Add Vehicles'),
//         backgroundColor: AppC.appColor,
//         foregroundColor: AppC.white,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.close),
//           ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => vehicleDataBloc,
//         child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
//             listener: (context, state) {
//           if (state is VehicleDataLoading) {
//             EasyLoading.show();
//           } else {
//             if (EasyLoading.isShow) EasyLoading.dismiss();
//             if (state is DropdownVehicleDataLoaded) {
//               createExpenseFieldData = state.createExpenseFieldData;
//               if (state.createExpenseFieldData != null) {
//                 cohortsData = state.createExpenseFieldData!.cohortsData ?? [];
//                 for (Map<String, dynamic> c in cohortsData) {
//                   if (c['cohort'] == 'Unassigned') {
//                     selectedCohortsData = c;
//                   }
//                 }
//               }
//             } else if (state is VehicleStatusCategoryLoaded) {
//               categoriesData = state.vehicleStatusDataList ?? [];
//               isSelected = true;
//               selectedVehicleStatus = categoriesData[0];
//             }
//           }
//         }, builder: (context, state) {
//           return SafeArea(
//             minimum: 15.padding,
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   Utils.getTextFormField(
//                     'Year',
//                     yearController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>
//                         val!.isEmpty ? 'Please enter year' : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Make',
//                     makeController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>
//                         val!.isEmpty ? 'Please enter make' : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Model',
//                     modelController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>
//                         val!.isEmpty ? 'Please enter model' : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Vehicle Number',
//                     vehicleNoController,
//                     inputAction: TextInputAction.done,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.dropdownBox(
//                     'Select Cohort',
//                     cohortsData,
//                     (selectedValue) {
//                       setState(() {
//                         selectedCohortsData = selectedValue;
//                       });
//                     },
//                     labelKey: 'cohort',
//                     initialSelection: selectedCohortsData,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Vin',
//                     vinController,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Vehicle Id',
//                     vehicleIdController,
//                     inputAction: TextInputAction.done,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Purchase Date',
//                     purchaseDateController,
//                     suffixIcon: const Icon(
//                       Icons.date_range,
//                       color: AppC.appColor,
//                     ),
//                     readOnly: true,
//                     onTapCallback: () {
//                       Utils.datePicker(context, '',
//                               initial:purchaseDateController.text.toDateTime(
//                                   inputFormat: ('yyyy-MM-dd'))?? DateTime.now())
//                           .then((value) {
//                         if (value != null) {
//                           purchaseDateController.text =
//                               Utils.convertDateToYearMonthDateFormat(
//                                   value.toString());
//                         }
//                       });
//                     },
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>
//                         val!.isEmpty ? 'Please enter purchase date' : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Utils.getTextFormField(
//                     'Purchase Price',
//                     purchasePriceController,
//                     autoValidate: AutovalidateMode.onUserInteraction,
//                     validator: (val) =>
//                         val!.isEmpty ? 'Please enter purchase price' : null,
//                     inputAction: TextInputAction.done,
//
//                   ),
//                   const SizedBox(height: 10),
//                   InkWell(
//                     onTap: () => _pickReceiptImageFile(ImageSource.gallery),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppC.fieldBase,
//                           width: Num.borderWidthField,
//                         ),
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(Num.subradiusButton),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.cloud_upload,
//                             color: AppC.blue,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Utils.getText('Upload Purchase Receipt',
//                               color: AppC.blue),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (receiptImageFile.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: SizedBox(
//                         height: 100,
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           itemCount: receiptImageFile.length,
//                           scrollDirection: Axis.horizontal,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 1, mainAxisSpacing: 10),
//                           itemBuilder: (context, index) => CloseBadge(
//                               onTapView: () {
//                                 ShowAttachmentsDialog.of.show(context,
//                                     attachments: receiptImageFile,
//                                     title: "",
//                                     currentAttachment:
//                                         receiptImageFile[index]);
//                               },
//                               onTapDelete: () {
//                                 receiptImageFile.removeAt(index);
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 constraints: BoxConstraints(
//                                   minHeight:
//                                       MediaQuery.sizeOf(context).height,
//                                   minWidth:
//                                       MediaQuery.sizeOf(context).width,
//                                 ),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16),
//                                     color:
//                                         AppC.grey.withValues(alpha: 0.2)),
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 child: ImageViewer(
//                                   fit: BoxFit.cover,
//                                   imageInput: receiptImageFile[index],
//                                   isNotImage:
//                                       !((receiptImageFile[index] as Object)
//                                           .isImage),
//                                 ),
//                               )),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 10),
//                   Visibility(
//                     visible: !showMore,
//                     child: InkWell(
//                         onTap: () {
//                           showMore = !showMore;
//                           setState(() {});
//                         },
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Utils.getText(' More ...',
//                                 color: const Color(0xff0580b5),
//                                 weight: FontWeight.w500),
//                           ],
//                         )),
//                   ),
//                   Visibility(
//                     visible: showMore,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () =>
//                               _pickVehicleImageFile(ImageSource.gallery),
//                           child: Container(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppC.fieldBase,
//                                 width: Num.borderWidthField,
//                               ),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(Num.subradiusButton),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.cloud_upload,
//                                   color: AppC.blue,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Utils.getText('Upload Vehicle Image',
//                                     color: AppC.blue),
//                               ],
//                             ),
//                           ),
//                         ),
//                         if (vehicleImageFile.isNotEmpty)
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: 10),
//                             child: SizedBox(
//                               height: 100,
//                               child: GridView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: vehicleImageFile.length,
//                                 scrollDirection: Axis.horizontal,
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 1,
//                                         mainAxisSpacing: 10),
//                                 itemBuilder: (context, index) => CloseBadge(
//                                     onTapView: () {
//                                       ShowAttachmentsDialog.of.show(context,
//                                           attachments: vehicleImageFile,
//                                           title: "",
//                                           currentAttachment:
//                                               vehicleImageFile[index]);
//                                     },
//                                     onTapDelete: () {
//                                       vehicleImageFile.removeAt(index);
//                                       setState(() {});
//                                     },
//                                     child: Container(
//                                       constraints: BoxConstraints(
//                                         minHeight:
//                                             MediaQuery.sizeOf(context)
//                                                 .height,
//                                         minWidth: MediaQuery.sizeOf(context)
//                                             .width,
//                                       ),
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(16),
//                                           color: AppC.grey
//                                               .withValues(alpha: 0.2)),
//                                       clipBehavior:
//                                           Clip.antiAliasWithSaveLayer,
//                                       child: ImageViewer(
//                                         fit: BoxFit.cover,
//                                         imageInput: vehicleImageFile[index],
//                                         isNotImage:
//                                             !((vehicleImageFile[index]
//                                                     as Object)
//                                                 .isImage),
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 10),
//                         Utils.getTextFormField(
//                           'Earnings',
//                           earningsController,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getTextFormField(
//                           'Utilization Rate',
//                           utilizationRateController,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getTextFormField(
//                           'Platform',
//                           platformController,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getTextFormField(
//                           'Mileage',
//                           mileageController,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getTextFormField(
//                           'Wholesale Amount',
//                           wholeSaleAmountController,
//                           label: Utils.getText('', color: AppC.grey),
//                           inputAction: TextInputAction.done,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.dropdownBox(
//                           'Select Category',
//                           categoriesData,
//                           (selectedValue) {
//                             setState(() {
//                               selectedVehicleStatus =
//                                   selectedValue; // Store the selected value
//                             });
//                           },
//                           labelKey: 'category_name',
//                           initialSelection: selectedVehicleStatus,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.dropdownBox('Status', vehicleStatusList,
//                             (selectedValue) {
//                           setState(() {
//                             selectedStatus = selectedValue;
//                           });
//                         },
//                             labelKey: 'name',
//                             initialSelection: selectedStatus),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getBorderedMultilineTextField(
//                           'Address',
//                           addressController,
//                           minLines: 3,
//                           fillColor: AppC.white,
//                           inputAction: TextInputAction.done,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 children: [
//                                   checkBoxWithSingleText(
//                                     value: bouncie,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         bouncie = value ?? false;
//                                       });
//                                     },
//                                     label: 'Bouncie',
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   checkBoxWithSingleText(
//                                     value: tollTags,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         tollTags = value ?? false;
//                                       });
//                                     },
//                                     label: 'Toll tags',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   checkBoxWithSingleText(
//                                     value: airTag,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         airTag = value ?? false;
//                                       });
//                                     },
//                                     label: 'AirTag',
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   checkBoxWithSingleText(
//                                     value: spareTire,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         spareTire = value ?? false;
//                                       });
//                                     },
//                                     label: 'Spare Tire',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Visibility(
//                                       visible: tollTags,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 10),
//                                         child: Utils.getTextFormField(
//                                             'Enter the toll tag id',
//                                             tollTagsController),
//                                       )),
//                                   Visibility(
//                                     visible: tollTags,
//                                     child: InkWell(
//                                       onTap: () => _pickTollImage(
//                                           ImageSource.gallery),
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             color: AppC.fieldBase,
//                                             width: Num.borderWidthField,
//                                           ),
//                                           borderRadius:
//                                               const BorderRadius.all(
//                                             Radius.circular(
//                                                 Num.subradiusButton),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             const Icon(
//                                               Icons.cloud_upload,
//                                               color: AppC.blue,
//                                             ),
//                                             const SizedBox(
//                                               width: 5,
//                                             ),
//                                             Utils.getText(
//                                                 'Upload Toll Image',
//                                                 color: AppC.blue),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Visibility(
//                                   visible: spareTire,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10),
//                                     child: Utils.getTextFormField(
//                                         'e.g.,T165/70D18',
//                                         spareTireController),
//                                   )),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5.0),
//                           child: Column(
//                             children: [
//                               Visibility(
//                                 visible: tollImage.isNotEmpty && tollTags,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 10),
//                                   child: SizedBox(
//                                     height: 100,
//                                     child: GridView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: tollImage.length,
//                                       scrollDirection: Axis.horizontal,
//                                       gridDelegate:
//                                           const SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 1,
//                                               mainAxisSpacing: 10),
//                                       itemBuilder: (context, index) =>
//                                           CloseBadge(
//                                               onTapView: () {
//                                                 ShowAttachmentsDialog.of
//                                                     .show(context,
//                                                         attachments:
//                                                             tollImage,
//                                                         title: "",
//                                                         currentAttachment:
//                                                             tollImage[
//                                                                 index]);
//                                               },
//                                               onTapDelete: () {
//                                                 tollImage.removeAt(index);
//                                                 setState(() {});
//                                               },
//                                               child: Container(
//                                                 constraints: BoxConstraints(
//                                                   minHeight:
//                                                       MediaQuery.sizeOf(
//                                                               context)
//                                                           .height,
//                                                   minWidth:
//                                                       MediaQuery.sizeOf(
//                                                               context)
//                                                           .width,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius
//                                                             .circular(16),
//                                                     color: AppC.grey
//                                                         .withValues(
//                                                             alpha: 0.2)),
//                                                 clipBehavior: Clip
//                                                     .antiAliasWithSaveLayer,
//                                                 child: ImageViewer(
//                                                   fit: BoxFit.cover,
//                                                   imageInput:
//                                                       tollImage[index],
//                                                   isNotImage:
//                                                       !((tollImage[index]
//                                                               as Object)
//                                                           .isImage),
//                                                 ),
//                                               )),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             checkBoxWithSingleText(
//                               value: spareKey,
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   spareKey = value ?? false;
//                                 });
//                               },
//                               label: 'Spare Key',
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: checkBoxWithSingleText(
//                                 value: permanentPlate,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     permanentPlate = value ?? false;
//                                   });
//                                 },
//                                 label: 'Permanent Plate',
//                               ),
//                             ),
//                             Expanded(
//                               child: Visibility(
//                                 visible: permanentPlate,
//                                 child: checkBoxWithSingleText(
//                                   value: frontLicensePlate,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       frontLicensePlate = value ?? false;
//                                     });
//                                   },
//                                   label: 'Front license plate',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () => _pickTireImageFile(
//                                     ImageSource.gallery),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 8),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: AppC.fieldBase,
//                                       width: Num.borderWidthField,
//                                     ),
//                                     borderRadius:
//                                     const BorderRadius.all(
//                                       Radius.circular(Num.subradiusButton),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(
//                                         Icons.cloud_upload,
//                                         color: AppC.blue,
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       Utils.getText(
//                                           'Upload Tire Image',
//                                           color: AppC.blue),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                 'Number Plate',
//                                 plateNumberController,
//                                  ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Visibility(
//                                 visible: tireImageFile.isNotEmpty,
//                                 child: SizedBox(
//                                   height: 100,
//                                   child: GridView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: tireImageFile.length,
//                                     scrollDirection: Axis.horizontal,
//                                     gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 1,
//                                         mainAxisSpacing: 10),
//                                     itemBuilder: (context, index) =>
//                                         CloseBadge(
//                                             onTapView: () {
//                                               ShowAttachmentsDialog.of
//                                                   .show(context,
//                                                   attachments:
//                                                   tireImageFile,
//                                                   title: "",
//                                                   currentAttachment:
//                                                   tireImageFile[
//                                                   index]);
//                                             },
//                                             onTapDelete: () {
//                                               tireImageFile.removeAt(index);
//                                               setState(() {});
//                                             },
//                                             child: Container(
//                                               constraints: BoxConstraints(
//                                                 minHeight:
//                                                 MediaQuery.sizeOf(
//                                                     context)
//                                                     .height,
//                                                 minWidth:
//                                                 MediaQuery.sizeOf(
//                                                     context)
//                                                     .width,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .circular(16),
//                                                   color: AppC.grey
//                                                       .withValues(
//                                                       alpha: 0.2)),
//                                               clipBehavior: Clip
//                                                   .antiAliasWithSaveLayer,
//                                               child: ImageViewer(
//                                                 fit: BoxFit.cover,
//                                                 imageInput:
//                                                 tireImageFile[index],
//                                                 isNotImage:
//                                                 !((tireImageFile[index]
//                                                 as Object)
//                                                     .isImage),
//                                               ),
//                                             )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Car Number', carNumberController,
//                                   hintTextColor: AppC.grey),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Oil grade', oilGradeController,
//                                   hintTextColor: AppC.grey),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Front tire e.g., 215/55R17',
//                                   frontTireController,
//                                   hintTextColor: AppC.grey),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Rear tire e.g., 215/55R17',
//                                   rearTireController,
//                                   hintTextColor: AppC.grey,
//                                 inputAction: TextInputAction.done,
//
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getText('Reg Stick date',
//                             weight: FontWeight.bold),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Utils.getTextFormField(
//                                     'dd-mm-yyyy',
//                                     renewalDateController,
//                                     suffixIcon: const Icon(
//                                       Icons.date_range,
//                                       color: AppC.appColor,
//                                     ),
//                                     readOnly: true,
//                                     onTapCallback: () {
//                                       Utils.datePicker(context, '',
//                                         initial: renewalDateController.text.toDateTime(inputFormat: "dd-MM-yyyy") ?? DateTime.now())
//                                           .then((value) {
//                                         if (value != null) {
//                                           renewalDateController.text = Utils
//                                               .convertDateTimeToTheFormat(
//                                                   value.toString());
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   InkWell(
//                                     onTap: () => _pickUploadRegSticker(
//                                         ImageSource.gallery),
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 8),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: AppC.fieldBase,
//                                           width: Num.borderWidthField,
//                                         ),
//                                         borderRadius:
//                                         const BorderRadius.all(
//                                           Radius.circular(
//                                               Num.subradiusButton),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(
//                                             Icons.cloud_upload,
//                                             color: AppC.blue,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Utils.getText(
//                                               'Upload Reg Sticker',
//                                               color: AppC.blue),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsets.symmetric(vertical: 5.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Visibility(
//                                 visible: uploadRegSticker.isNotEmpty,
//                                 child: SizedBox(
//                                   height: 100,
//                                   child: GridView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: uploadRegSticker.length,
//                                     scrollDirection: Axis.horizontal,
//                                     gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 1,
//                                         mainAxisSpacing: 10),
//                                     itemBuilder: (context, index) =>
//                                         CloseBadge(
//                                             onTapView: () {
//                                               ShowAttachmentsDialog.of
//                                                   .show(context,
//                                                   attachments:
//                                                   uploadRegSticker,
//                                                   title: "",
//                                                   currentAttachment:
//                                                   uploadRegSticker[
//                                                   index]);
//                                             },
//                                             onTapDelete: () {
//                                               uploadRegSticker.removeAt(index);
//                                               setState(() {});
//                                             },
//                                             child: Container(
//                                               constraints: BoxConstraints(
//                                                 minHeight:
//                                                 MediaQuery.sizeOf(
//                                                     context)
//                                                     .height,
//                                                 minWidth:
//                                                 MediaQuery.sizeOf(
//                                                     context)
//                                                     .width,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .circular(16),
//                                                   color: AppC.grey
//                                                       .withValues(
//                                                       alpha: 0.2)),
//                                               clipBehavior: Clip
//                                                   .antiAliasWithSaveLayer,
//                                               child: ImageViewer(
//                                                 fit: BoxFit.cover,
//                                                 imageInput:
//                                                 uploadRegSticker[index],
//                                                 isNotImage:
//                                                 !((uploadRegSticker[index]
//                                                 as Object)
//                                                     .isImage),
//                                               ),
//                                             )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Current Odometer',
//                                   insuranceAgentController),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Oil Change Odometer',
//                                   insuranceCostController),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Utils.getTextFormField(
//                             'Maintenance Check(day from today)',
//                             maintenanceCheckController),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Insurance Agent',
//                                   insuranceAgentController),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Utils.getTextFormField(
//                                   'Insurance Cost',
//                                   insuranceCostController,
//                                 inputAction: TextInputAction.done,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         InkWell(
//                           onTap: () => _pickInsuranceImage(
//                               ImageSource.gallery),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: AppC.fieldBase,
//                                 width: Num.borderWidthField,
//                               ),
//                               borderRadius:
//                               const BorderRadius.all(
//                                 Radius.circular(
//                                     Num.subradiusButton),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.cloud_upload,
//                                   color: AppC.blue,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Utils.getText(
//                                     'Upload Insurance Sticker',
//                                     color: AppC.blue),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsets.symmetric(vertical: 5.0),
//                           child: Visibility(
//                             visible: insuranceImage.isNotEmpty,
//                             child: SizedBox(
//                               height: 100,
//                               child: GridView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: insuranceImage.length,
//                                 scrollDirection: Axis.horizontal,
//                                 gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 1,
//                                     mainAxisSpacing: 10),
//                                 itemBuilder: (context, index) =>
//                                     CloseBadge(
//                                         onTapView: () {
//                                           ShowAttachmentsDialog.of
//                                               .show(context,
//                                               attachments:
//                                               insuranceImage,
//                                               title: "",
//                                               currentAttachment:
//                                               insuranceImage[
//                                               index]);
//                                         },
//                                         onTapDelete: () {
//                                           insuranceImage.removeAt(index);
//                                           setState(() {});
//                                         },
//                                         child: Container(
//                                           constraints: BoxConstraints(
//                                             minHeight:
//                                             MediaQuery.sizeOf(
//                                                 context)
//                                                 .height,
//                                             minWidth:
//                                             MediaQuery.sizeOf(
//                                                 context)
//                                                 .width,
//                                           ),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius
//                                                   .circular(16),
//                                               color: AppC.grey
//                                                   .withValues(
//                                                   alpha: 0.2)),
//                                           clipBehavior: Clip
//                                               .antiAliasWithSaveLayer,
//                                           child: ImageViewer(
//                                             fit: BoxFit.cover,
//                                             imageInput:
//                                             insuranceImage[index],
//                                             isNotImage:
//                                             !((insuranceImage[index]
//                                             as Object)
//                                                 .isImage),
//                                           ),
//                                         )),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             InkWell(
//                                 onTap: () {
//                                   showMore = !showMore;
//                                   setState(() {});
//                                 },
//                                 child: Utils.getText(' Less ...',
//                                     color: AppC.blue,
//                                     weight: FontWeight.w500)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Utils.getElevatedButton(()=>_save(),),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
