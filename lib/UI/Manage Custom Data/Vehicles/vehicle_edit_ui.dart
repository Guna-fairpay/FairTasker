import 'dart:io';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Response/create_expense_field_data.dart';
import '../../../Utilities/image_pick_helper.dart';
import '../../../Utilities/num.dart';
import '../../../Response/create_vehicle_data.dart';
import '../../../Bloc/vehicle_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleEditUI extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const VehicleEditUI({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleEditUI> createState() => _VehicleEditUIState();
}

class _VehicleEditUIState extends State<VehicleEditUI> {
  late VehicleDataBloc vehicleDataBloc;
  late final TextEditingController yearController;
  late final TextEditingController makeController;
  late final TextEditingController modelController;
  late final TextEditingController vehicleNoController;
  late final TextEditingController purchasePriceController;
  late final TextEditingController purchaseDateController;
  late final TextEditingController vinController;
  late final TextEditingController vehicleIdController;

  late final TextEditingController earningsController;
  late final TextEditingController utilizationRateController;
  late final TextEditingController platformController;
  late final TextEditingController mileageController;
  late final TextEditingController wholeSaleAmountController;
  CreateExpenseFieldData? createExpenseFieldData;
  List<Map<String, dynamic>> cohortsData = [];
  dynamic selectedCohortsData;
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedCategoriesData;

  // List<VehicleSourceList> vehicleSourceList = [];
  // VehicleSourceList? selectedSourceType;
  List<String> vehicleStatusList = ['Active', 'InActive'];
  String? selectedVehicleStatus;
  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<dynamic> vehicleImageFile = [];
  // List<String> imagePath = [];
  List<dynamic> receiptImageFile = [];
  CreateVehicleData? createVehicleData;
  bool showMore = false;
  bool isYearFieldEmpty = false;
  bool isMakeFieldEmpty = false;
  bool isModelFieldEmpty = false;
  bool isPurchaseFieldEmpty = false;
  bool isPurchaseDateFieldEmpty = false;
  bool categoriesDataIsSelected = false;
  late final TextEditingController addressController;
  late final TextEditingController carNumberController;
  late final TextEditingController oilGradeController;
  late final TextEditingController frontTireController;
  late final TextEditingController rearTireController;
  late final TextEditingController renewalDateController;

  bool bouncie = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  List<dynamic> imageFile = [];
  List<dynamic> tireImageFile = [];

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetDropdownVehicleData());
    vehicleDataBloc.add(const VehicleStatusCategory());
    yearController = TextEditingController(text: widget.vehicle['year'] ?? '');
    makeController = TextEditingController(text: widget.vehicle['make'] ?? '');
    modelController =
        TextEditingController(text: widget.vehicle['model'] ?? '');
    vehicleNoController =
        TextEditingController(text: widget.vehicle['vehicle_number'] ?? '');
    vinController = TextEditingController(text: widget.vehicle['vin'] ?? '');
    purchaseDateController =
        TextEditingController(text: widget.vehicle['purchase_date'] ?? '');
    vehicleIdController = TextEditingController(
        text: (widget.vehicle['vehicle_id'] ?? '').toString());
    purchasePriceController = TextEditingController(
        text: (widget.vehicle['purchase_price'] ?? '').toString());
    earningsController = TextEditingController(
        text: (widget.vehicle['earnings'] ?? '').toString());
    utilizationRateController = TextEditingController(
        text: (widget.vehicle['utilization_rate'] ?? '').toString());
    platformController = TextEditingController(
        text: (widget.vehicle['platform'] ?? '').toString());
    mileageController = TextEditingController(
        text: (widget.vehicle['mileage'] ?? '').toString());
    wholeSaleAmountController = TextEditingController(
        text: (widget.vehicle['wholesale_amount'] ?? '').toString());
    addressController =
        TextEditingController(text: widget.vehicle['address'] ?? '');
    carNumberController = TextEditingController(
        text: (widget.vehicle['car_number'] ?? '').toString());
    oilGradeController =
        TextEditingController(text: widget.vehicle['oil_grade'] ?? '');
    frontTireController =
        TextEditingController(text: widget.vehicle['front_tire'] ?? '');
    rearTireController =
        TextEditingController(text: widget.vehicle['rear_tire'] ?? '');
    renewalDateController = TextEditingController(
        text: widget.vehicle['registration_renewal_date'] ?? '');

    for (Map<String, dynamic> c in cohortsData) {
      if (c['id'] == widget.vehicle['cohort_id']) {
        selectedCohortsData = c;
      }
    }
    for (Map<String, dynamic> c in categoriesData) {
      if (c['id'] == widget.vehicle['vehicle_status']) {
        selectedCategoriesData = c;
      }
    }
    selectedVehicleStatus =
        (widget.vehicle['active'] ?? vehicleStatusList[1]) == 1
            ? vehicleStatusList[0]
            : vehicleStatusList[1];

    vehicleImageFile = (widget.vehicle['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 1)
            .toList() ??
        [];

    imageFile = (widget.vehicle['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 3)
            .toList() ??
        [];

    tireImageFile = (widget.vehicle['images'] as List<dynamic>?)
            ?.where((image) => image['vehicle_image_type'] == 2)
            .toList() ??
        [];

    receiptImageFile.addAll(widget.vehicle['expenses']?['attachments'] ?? []);

    bouncie = (widget.vehicle['bouncie'] == 1);
    airTag = (widget.vehicle['air_tag'] == 1);
    permanentPlate = (widget.vehicle['permanent_plate'] == 1);
    spareTire = (widget.vehicle['spare_tire'] == 1);
  }

  void _save() {
    setState(() {
      isYearFieldEmpty = yearController.text.isEmpty;
      isMakeFieldEmpty = makeController.text.isEmpty;
      isModelFieldEmpty = modelController.text.isEmpty;
      isPurchaseFieldEmpty = purchasePriceController.text.isEmpty;
      isPurchaseDateFieldEmpty = purchaseDateController.text.isEmpty;
    });
    if (yearController.text.isEmpty ||
        makeController.text.isEmpty ||
        modelController.text.isEmpty ||
        purchasePriceController.text.isEmpty ||
        purchaseDateController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required fields');
    }
    final createVehicleData = CreateVehicleData();
    createVehicleData.id = widget.vehicle['id'];
    createVehicleData.year = yearController.text;
    createVehicleData.make = makeController.text;
    createVehicleData.model = modelController.text;
    createVehicleData.vehicleNumber = vehicleNoController.text;
    createVehicleData.vin = vinController.text;
    createVehicleData.vehicleId = vehicleIdController.text;
    createVehicleData.earnings = earningsController.text;
    createVehicleData.utilizationRate = utilizationRateController.text;
    createVehicleData.platform = platformController.text;
    createVehicleData.mileage = mileageController.text;
    createVehicleData.wholesaleAmount = wholeSaleAmountController.text;
    createVehicleData.purchaseDate = purchaseDateController.text;
    createVehicleData.purchasePrice = purchasePriceController.text;
    createVehicleData.address = addressController.text;
    createVehicleData.bouncie = bouncie ? 1 : 0;
    createVehicleData.airTag = airTag ? 1 : 0;
    createVehicleData.permanentPlate = permanentPlate ? 1 : 0;
    createVehicleData.spareTire = spareTire ? 1 : 0;
    createVehicleData.carNumber = carNumberController.text;
    createVehicleData.oilGrade = oilGradeController.text;
    createVehicleData.frontTire = frontTireController.text;
    createVehicleData.rearTire = rearTireController.text;
    createVehicleData.renewalDate = renewalDateController.text;

    createVehicleData.chosenFiles = vehicleImageFile
        .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
        .where((element) => element != null)
        .cast<File>()
        .toList();
    createVehicleData.chosenFiles = imageFile
        .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
        .where((element) => element != null)
        .cast<File>()
        .toList();
    createVehicleData.chosenFiles = tireImageFile
        .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
        .where((element) => element != null)
        .cast<File>()
        .toList();
    createVehicleData.chosenPurchaseReceipts = receiptImageFile
        .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
        .where((element) => element != null)
        .cast<File>()
        .toList();
    createVehicleData.isActive = selectedVehicleStatus == 'Active' ? 1 : 0;
    if (selectedCategoriesData != null) {
      createVehicleData.selectedVehicleStatus = selectedCategoriesData['id']!;
    }

    createVehicleData.selectedCohort = selectedCohortsData['id'];

    final updateVehicle = createVehicleData;
    Navigator.of(context).pop(updateVehicle);
    // Navigator.pop(context, updateVehicle);
  }

  Widget checkBoxWithSingleText({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
    double scale = 1.0, // Add a scale parameter to control the size
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: scale, // Adjust the scale here
          child: SizedBox(
            height: 15,
            child: Checkbox(
              activeColor: AppC.blue,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        Utils.getText(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => vehicleDataBloc,
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) {
          if (state is DropdownVehicleDataLoaded) {
            createExpenseFieldData = state.createExpenseFieldData;
            if (state.createExpenseFieldData != null) {
              cohortsData = state.createExpenseFieldData!.cohortsData ?? [];
              for (Map<String, dynamic> c in cohortsData) {
                if (c['id'] == widget.vehicle['cohort_id']) {
                  selectedCohortsData = c;
                }
              }
              for (Map<String, dynamic> c in categoriesData) {
                if (c['id'] == widget.vehicle['vehicle_status']) {
                  selectedCategoriesData = c;
                }
              }
              // categoriesData = state.createExpenseFieldData!.expenseCategories ?? [];
            }
          }
          if (state is VehicleStatusCategoryLoaded) {
            categoriesData = state.vehicleStatusDataList ?? [];
            categoriesDataIsSelected = true;
            selectedCategoriesData = categoriesData[0];
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
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
                          Utils.getText('Edit Vehicle',
                              size: 20, weight: FontWeight.bold)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: vehicleImageFile.isNotEmpty,
                            child: vehicleImageFile.isNotEmpty // Check if the list is not empty
                                ? Container(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  (vehicleImageFile.first['path'] ?? '').isNotEmpty
                                      ? Utils.getHeadCachedImageNetworkDisplay(
                                    context,
                                    vehicleImageFile.first['path'] ?? '',
                                  )
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(vehicleImageFile.first['path'] ?? ''),
                                      width: 50.0,
                                      height: 100.0,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox(), // Placeholder for empty list case
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                              '',
                              yearController,
                              label: Utils.getText('Year', color: AppC.grey),
                              borderColor: isYearFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isYearFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
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
                              makeController,
                              label: Utils.getText('Make', color: AppC.grey),
                              borderColor: isMakeFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isMakeFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
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
                              modelController,
                              label: Utils.getText('Model', color: AppC.grey),
                              borderColor: isModelFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isModelFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                          '',
                          vehicleNoController,
                          label:
                              Utils.getText('Vehicle Number', color: AppC.grey),
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
                          child: DropdownButton<Map<String, dynamic>>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('Project Name',
                                  color: AppC.grey),
                            ),
                            value: selectedCohortsData,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AppC.appColor,
                            ),
                            elevation: 3,
                            dropdownColor: AppC.white,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (Map<String, dynamic>? value) {
                              selectedCohortsData = value;
                              setState(() {});
                            },
                            items: cohortsData
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Utils.getText(value['cohort'] ?? ''),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                          '',
                          vinController,
                          label: Utils.getText('Vin', color: AppC.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                          '',
                          vehicleIdController,
                          label: Utils.getText('Vehicle Id', color: AppC.grey),
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
                              purchaseDateController,
                              suffixIcon: Padding(
                                padding: isPurchaseDateFieldEmpty
                                    ? const EdgeInsets.only(right: 35.0)
                                    : const EdgeInsets.only(),
                                child: const Icon(
                                  Icons.date_range,
                                  color: AppC.appColor,
                                ),
                              ),
                              readOnly: true,
                              onTapCallback: () {
                                Utils.datePicker(context, '',
                                        initial: DateTime.parse("1970-01-01"))
                                    .then((value) {
                                  if (value != null) {
                                    purchaseDateController.text =
                                        Utils.convertDateTimeToTheFormat(
                                            value.toString());
                                  }
                                });
                              },
                              label: Utils.getText(
                                'Purchase Date',
                                color: AppC.grey,
                              ),
                              borderColor: isPurchaseDateFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isPurchaseDateFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
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
                              purchasePriceController,
                              label: Utils.getText('Purchase Price',
                                  color: AppC.grey),
                              borderColor: isPurchaseFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isPurchaseFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
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
                          child: Utils.getOutlinedButton('Purchase Receipt',
                              () async {
                            await imagePickHelper
                                .getSingleImage(ImageSource.gallery)
                                .then((value) {
                              if (value != null) {
                                debugPrint('value.path: ${value.path}');
                                // Attachments ve = Attachments(
                                //     file: value, path: '');
                                receiptImageFile
                                    .add({'file': value, 'path': ''});
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
                        height: 15,
                      ),
                      Visibility(
                        visible: receiptImageFile.isNotEmpty,
                        child: SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: receiptImageFile.length,
                            // Number of items in the list
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
                                        : ClipOval(
                                            child: Image.file(
                                              File(receiptImageFile[index]
                                                      ['path'] ??
                                                  ''),
                                              width: 50.0,
                                              // Set the width as needed
                                              height: 50.0,
                                              // Set the width as needed
                                              fit: BoxFit
                                                  .fill, // You can use other BoxFit values to control how the image is displayed
                                            ),
                                          ),
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: InkWell(
                                        onTap: () {
                                          if ((receiptImageFile[index]
                                                      ['path'] ??
                                                  '')
                                              .isEmpty) {
                                            receiptImageFile.removeAt(index);
                                          } else {
                                            vehicleDataBloc.add(
                                                DeleteExpenseImage(
                                                    id: receiptImageFile[index]
                                                        ['id']));
                                            receiptImageFile.removeAt(index);
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                              Icons.delete_outline_sharp,
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
                      Visibility(
                        visible: !showMore,
                        child: InkWell(
                            onTap: () {
                              showMore = !showMore;
                              setState(() {});
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Utils.getText(' More ...',
                                    size: 16,
                                    color: AppC.appColor,
                                    weight: FontWeight.w500),
                              ],
                            )),
                      ),
                      Visibility(
                        visible: showMore,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        Radius.circular(Num.subradiusButton))),
                                child: Utils.getOutlinedButton('Vehicle Image',
                                    () async {
                                  await imagePickHelper
                                      .getSingleImage(ImageSource.gallery)
                                      .then((value) {
                                    if (value != null) {
                                      debugPrint('value.path: ${value.path}');
                                      // VehiclesImages ve = VehiclesImages(
                                      //     file: value, path: '');
                                      vehicleImageFile.add({
                                        'path': '',
                                        'file': value,
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
                              height: 15,
                            ),
                            Visibility(
                              visible: vehicleImageFile.isNotEmpty,
                              child: SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vehicleImageFile.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          (vehicleImageFile[index]['path'] ??
                                                      '')
                                                  .isNotEmpty
                                              ? Utils
                                                  .getOvalCachedImageNetworkDisplay(
                                                      context,
                                                      vehicleImageFile[index]
                                                              ['path'] ??
                                                          '')
                                              : ClipRRect(
                                                  child: Image.file(
                                                    File(vehicleImageFile[index]
                                                                ['file']
                                                            ?.path ??
                                                        ''),
                                                    width: 60.0,
                                                    height: 60.0,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: InkWell(
                                              onTap: () {
                                                if ((vehicleImageFile[index]
                                                            ['path'] ??
                                                        '')
                                                    .isEmpty) {
                                                  vehicleImageFile
                                                      .removeAt(index);
                                                } else {
                                                  vehicleDataBloc.add(
                                                      DeleteVehicleImage(
                                                          id: vehicleImageFile[
                                                              index]['id']));
                                                  vehicleImageFile
                                                      .removeAt(index);
                                                }
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
                                                    Icons.delete_outline_sharp,
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
                            SizedBox(
                              height: 40,
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                earningsController,
                                label:
                                    Utils.getText('Earnings', color: AppC.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40,
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                utilizationRateController,
                                label: Utils.getText('Utilization Rate',
                                    color: AppC.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40,
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                platformController,
                                label:
                                    Utils.getText('Platform', color: AppC.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40,
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                mileageController,
                                label:
                                    Utils.getText('Mileage', color: AppC.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40,
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                wholeSaleAmountController,
                                label: Utils.getText('Wholesale Amount',
                                    color: AppC.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                child: DropdownButton<Map<String, dynamic>>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Utils.getText('Transaction Type',
                                        color: AppC.grey),
                                  ),
                                  value: selectedCategoriesData,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 3,
                                  dropdownColor: AppC.white,
                                  underline: Container(
                                    height: 0,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (Map<String, dynamic>? value) {
                                    // This is called when the user selects an item.
                                    selectedCategoriesData = value;
                                    setState(() {});
                                  },
                                  items: categoriesData.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Utils.getText(
                                            value['category_name'] ?? ''),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                child: DropdownButton<String>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Utils.getText('Status',
                                        color: AppC.grey),
                                  ),
                                  value: selectedVehicleStatus,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 3,
                                  dropdownColor: AppC.white,
                                  underline: Container(
                                    height: 0,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    selectedVehicleStatus = value;
                                    setState(() {});
                                  },
                                  items: vehicleStatusList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                            const SizedBox(
                              height: 20,
                            ),
                            Utils.getBorderedMultilineTextField(
                              'Address',
                              addressController,
                              minLines: 3,
                              fillColor: AppC.white,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    checkBoxWithSingleText(
                                      value: bouncie,
                                      scale: 1,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          bouncie = value ?? false;
                                          widget.vehicle['bouncie'] =
                                              bouncie ? 1 : 0;
                                        });
                                      },
                                      label: 'Bouncie',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    checkBoxWithSingleText(
                                      value: permanentPlate,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          permanentPlate = value ?? false;
                                          widget.vehicle['permanent_plate'] =
                                              permanentPlate ? 1 : 0;
                                        });
                                      },
                                      label: 'Permanent Plate',
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    checkBoxWithSingleText(
                                      value: airTag,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          airTag = value ?? false;
                                          widget.vehicle['air_tag'] =
                                              airTag ? 1 : 0;
                                        });
                                      },
                                      label: 'AirTag',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    checkBoxWithSingleText(
                                      value: spareTire,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          spareTire = value ?? false;
                                          widget.vehicle['spare_tire'] =
                                              spareTire ? 1 : 0;
                                        });
                                      },
                                      label: 'Spare Tire',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Utils
                                        .getBackgroundFilledTextFieldFirstLetterCaps(
                                            'Car Number', carNumberController,
                                            hintTextColor: AppC.grey),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Utils
                                        .getBackgroundFilledTextFieldFirstLetterCaps(
                                            'Oil grade', oilGradeController,
                                            hintTextColor: AppC.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Utils
                                        .getBackgroundFilledTextFieldFirstLetterCaps(
                                            'Front tire', frontTireController,
                                            hintTextColor: AppC.grey),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Utils
                                        .getBackgroundFilledTextFieldFirstLetterCaps(
                                            'Rear tire', rearTireController,
                                            hintTextColor: AppC.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Utils
                                            .getBackgroundFilledTextFieldFirstLetterCaps(
                                          'Date',
                                          renewalDateController,
                                          hintTextColor: AppC.grey,
                                          suffixIcon: const Icon(
                                            Icons.date_range,
                                            color: AppC.appColor,
                                          ),
                                          readOnly: true,
                                          onTapCallback: () {
                                            Utils.datePicker(context, '',
                                                    initial: DateTime.parse(
                                                        "1970-01-01"))
                                                .then((value) {
                                              if (value != null) {
                                                renewalDateController.text = Utils
                                                    .convertDateTimeToTheFormats(
                                                        value.toString());
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppC.fieldBase,
                                            width: Num.borderWidthField,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  Num.subradiusButton))),
                                      child: Utils.getOutlinedButton(
                                          'Image Upload', () async {
                                        await imagePickHelper
                                            .getSingleImage(ImageSource.gallery)
                                            .then((value) {
                                          if (value != null) {
                                            debugPrint(
                                                'value.path: ${value.path}');
                                            // VehiclesImages ve = VehiclesImages(
                                            //     file: value, path: '');
                                            imageFile.add({
                                              'file': value,
                                              'path': '',
                                            });
                                            setState(() {});
                                          } else {
                                            return;
                                          }
                                        });
                                      },
                                          iconData: const Icon(
                                              Icons.cloud_upload,
                                              color: AppC.appColor,
                                              size: 15),
                                          verticalPadding: 0,
                                          radius: BorderRadius.zero,
                                          bgColor: AppC.trans,
                                          borderColor: AppC.trans,
                                          textColor: AppC.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: imageFile.isNotEmpty,
                                  child: SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imageFile.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          key: ValueKey(imageFile[index]['id']),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
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
                                                  : ClipRRect(
                                                      child: Image.file(
                                                        File(imageFile[index]
                                                                    ['file']
                                                                ?.path ??
                                                            ''),
                                                        width: 60.0,
                                                        height: 60.0,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: InkWell(
                                                  onTap: () {
                                                    if ((imageFile[index]
                                                                ['path'] ??
                                                            '')
                                                        .isEmpty) {
                                                      imageFile.removeAt(index);
                                                    } else {
                                                      vehicleDataBloc.add(
                                                          DeleteVehicleImage(
                                                              id: imageFile[
                                                                      index]
                                                                  ['id']));
                                                      imageFile.removeAt(index);
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  12)),
                                                      color: AppC.red.shade400,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0,
                                                        vertical: 0),
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                        Icons
                                                            .delete_outline_sharp,
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
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                                    'Upload Tire Image', () async {
                                  await imagePickHelper
                                      .getSingleImage(ImageSource.gallery)
                                      .then((value) {
                                    if (value != null) {
                                      debugPrint('value.path: ${value.path}');
                                      // VehiclesImages ve = VehiclesImages(
                                      //     file: value, path: '');
                                      tireImageFile.add({
                                        'file': value,
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
                            Visibility(
                              visible: tireImageFile.isNotEmpty,
                              child: SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tireImageFile.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      key: ValueKey(tireImageFile[index]['id']),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          (tireImageFile[index]['path'] ?? '')
                                                  .isNotEmpty
                                              ? Utils
                                                  .getOvalCachedImageNetworkDisplay(
                                                      context,
                                                      tireImageFile[index]
                                                              ['path'] ??
                                                          '')
                                              : ClipRRect(
                                                  child: Image.file(
                                                    File(tireImageFile[index]
                                                                ['file']
                                                            ?.path ??
                                                        ''),
                                                    width: 60.0,
                                                    height: 60.0,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: InkWell(
                                              onTap: () {
                                                if ((tireImageFile[index]
                                                            ['path'] ??
                                                        '')
                                                    .isEmpty) {
                                                  tireImageFile.removeAt(index);
                                                } else {
                                                  vehicleDataBloc.add(
                                                      DeleteVehicleImage(
                                                          id: tireImageFile[
                                                              index]['id']));
                                                  tireImageFile.removeAt(index);
                                                }
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
                                                    Icons.delete_outline_sharp,
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      showMore = !showMore;
                                      setState(() {});
                                    },
                                    child: Utils.getText(' Less ...',
                                        size: 16,
                                        color: AppC.appColor,
                                        weight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
