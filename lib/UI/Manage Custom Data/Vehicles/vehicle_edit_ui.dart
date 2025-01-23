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
  final bool showHeader;
  final Map<String, dynamic> vehicle;

  const VehicleEditUI({
    super.key,
    required this.vehicle,
    this.showHeader = true
  });

  @override
  State<VehicleEditUI> createState() => _VehicleEditUIState();
}

class _VehicleEditUIState extends State<VehicleEditUI> {
  late VehicleDataBloc vehicleDataBloc;
  late final TextEditingController yearController;
  late final TextEditingController makeController;
  late final TextEditingController modelController;
  late final TextEditingController numberPlateController;
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
  List<String> vehicleStatusList = ['Active', 'InActive'];
  String? selectedVehicleStatus;
  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<dynamic> vehicleImageFile = [];
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
  TextEditingController plateNumberController =TextEditingController();

  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  List<dynamic> tireImageFile = [];
  Map<String, dynamic> cohortInitialSelection = {};
  List<dynamic> tollImage = [];
  List<dynamic> uploadRegSticker = [];
  List<dynamic> insuranceImage = [];
  TextEditingController tollTagsIdController=TextEditingController();
  TextEditingController spareTireController=TextEditingController();
  TextEditingController insuranceCostController=TextEditingController();
  TextEditingController insuranceAgentController=TextEditingController();
  TextEditingController currentOdometerController=TextEditingController();
  TextEditingController oilChangeOdometerController=TextEditingController();
  TextEditingController maintenanceCheckController=TextEditingController();



  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetDropdownVehicleData());
    vehicleDataBloc.add(const VehicleStatusCategory());
    yearController = TextEditingController(text: widget.vehicle['year'] ?? '');
    makeController = TextEditingController(text: widget.vehicle['make'] ?? '');
    modelController = TextEditingController(text: widget.vehicle['model'] ?? '');
    numberPlateController = TextEditingController(text: widget.vehicle['vehicle_number'] ?? '');
    vinController = TextEditingController(text: widget.vehicle['vin'] ?? '');
    purchaseDateController = TextEditingController(text: widget.vehicle['purchase_date'] ?? '');
    vehicleIdController = TextEditingController(text: (widget.vehicle['vehicle_id'] ?? '').toString());
    purchasePriceController = TextEditingController(text: (widget.vehicle['purchase_price'] ?? '').toString());
    earningsController = TextEditingController(text: (widget.vehicle['earnings'] ?? '').toString());
    utilizationRateController = TextEditingController(text: (widget.vehicle['utilization_rate'] ?? '').toString());
    platformController = TextEditingController(text: (widget.vehicle['platform'] ?? '').toString());
    mileageController = TextEditingController(text: (widget.vehicle['mileage'] ?? '').toString());
    wholeSaleAmountController = TextEditingController(text: (widget.vehicle['wholesale_amount'] ?? '').toString());
    addressController = TextEditingController(text: widget.vehicle['address'] ?? '');
    carNumberController = TextEditingController(text: (widget.vehicle['car_number'] ?? '').toString());
    oilGradeController = TextEditingController(text: widget.vehicle['oil_grade'] ?? '');
    frontTireController = TextEditingController(text: widget.vehicle['front_tire'] ?? '');
    rearTireController = TextEditingController(text: widget.vehicle['rear_tire'] ?? '');
    renewalDateController = TextEditingController(text: widget.vehicle['registration_renewal_date'] ?? '');
    currentOdometerController=TextEditingController(text: widget.vehicle['current_odometer'] ?? '');
    oilChangeOdometerController=TextEditingController(text: widget.vehicle['oil_change_odometer'] ?? '');
    maintenanceCheckController=TextEditingController(text: widget.vehicle['maintenance_check'] ?? '');
    tollTagsIdController=TextEditingController(text: widget.vehicle['toll_tags_id'] ?? '');
    spareTireController=TextEditingController(text: widget.vehicle['tire_size'] ?? '');
    insuranceCostController=TextEditingController(text: widget.vehicle['insurance_cost'] ?? '');
    insuranceAgentController=TextEditingController(text: widget.vehicle['insurance_agent'] ?? '');
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
            .toList() ?? [];
    tireImageFile = (widget.vehicle['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 2)
        .toList() ?? [];
    tollImage = (widget.vehicle['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 5)
        .toList() ?? [];
    uploadRegSticker = (widget.vehicle['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 3)
        .toList() ?? [];
    insuranceImage = (widget.vehicle['images'] as List<dynamic>?)
        ?.where((image) => image['vehicle_image_type'] == 4)
        .toList() ?? [];

    receiptImageFile.addAll(widget.vehicle['expenses']?['attachments'] ?? []);

    bouncie = (widget.vehicle['bouncie'] == 1);
    airTag = (widget.vehicle['air_tag'] == 1);
    permanentPlate = (widget.vehicle['permanent_plate'] == 1);
    spareTire = (widget.vehicle['spare_tire'] == 1);
    spareKey = (widget.vehicle['spare_key'] == 1);
    permanentPlate = (widget.vehicle['permanent_plate'] == 1);
    frontLicensePlate = (widget.vehicle['front_license_plate'] == 1);
    tollTags = (widget.vehicle['toll_tags'] == 1);

    if(widget.showHeader==false){
      showMore=true;
    }

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
    createVehicleData.numberPlate = numberPlateController.text;
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
    createVehicleData.tollTag = tollTags ? 1 : 0;
    createVehicleData.spareKey = spareKey ? 1 : 0;
    createVehicleData.frontLicensePlate = frontLicensePlate ? 1 : 0;
    createVehicleData.tireSize=spareTireController.text;
    createVehicleData.carNumber = carNumberController.text;
    createVehicleData.oilGrade = oilGradeController.text;
    createVehicleData.frontTire = frontTireController.text;
    createVehicleData.rearTire = rearTireController.text;
    createVehicleData.regStickerDate = renewalDateController.text;
    createVehicleData.currentOdometer=currentOdometerController.text;
    createVehicleData.oilChangeOdometer=oilChangeOdometerController.text;
    createVehicleData.maintenanceCheck=maintenanceCheckController.text;
    createVehicleData.tollTagsId=tollTagsIdController.text;
    createVehicleData.insuranceAgent=insuranceAgentController.text;
    createVehicleData.insuranceCost=insuranceCostController.text;

    createVehicleData.chosenFiles = vehicleImageFile
        .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
        .where((element) => element != null)
        .cast<File>()
        .toList();
    createVehicleData.chosenFiles = uploadRegSticker
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
  }

  void savePopUpMenu(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Utils.getText(
                          'Confirmation',
                          size: 18,
                          weight: FontWeight.bold,
                          color: const Color(0xff495057)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Utils.getAddFilledButton('Save', (){
                          _save();
                          Navigator.pop(context);
                        }),
                        // const SizedBox(width: 16,),
                        Utils.getAddFilledButton('Save With Spare Key Task', (){},bgColor: AppC.green),
                        // const SizedBox(width: 16,),
                        Utils.getAddFilledButton('Cancel', (){
                          Navigator.pop(context);
                        }, bgColor: AppC.redAccent),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );

      },

    );
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
      appBar: widget.showHeader
          ? const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ): null,
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
                      if (widget.showHeader)
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
                      Visibility(
                        visible: widget.showHeader,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: vehicleImageFile.isNotEmpty,
                                  child: vehicleImageFile.isNotEmpty // Check if the list is not empty
                                      ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            (vehicleImageFile.first['path'] ?? '').isNotEmpty
                                                ? Utils.getHeadCachedImageNetworkDisplay(
                                              context,
                                              vehicleImageFile.first['path'] ?? '',
                                            ) : ClipRRect(
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
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Utils.getTextFormField(
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
                            const SizedBox(height: 10),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Utils.getTextFormField(
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
                            const SizedBox(height: 10),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Utils.getTextFormField(
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
                            const SizedBox(height: 10),
                            Utils.getTextFormField(
                              '',
                              numberPlateController,
                              label:
                              Utils.getText('Vehicle Number', color: AppC.grey),
                            ),
                            const SizedBox(height: 10),
                            Utils.dropdownBox(
                              'Select Cohort',
                              cohortsData,
                                  (selectedValue) {
                                setState(() {
                                  selectedCohortsData =
                                      selectedValue; // Store the selected value
                                });
                              },
                              labelKey: 'cohort',
                              initialSelection: selectedCohortsData,
                            ),
                            const SizedBox(height: 10),
                            Utils.getTextFormField(
                              '',
                              vinController,
                              label: Utils.getText('Vin', color: AppC.grey),
                            ),
                            const SizedBox(height: 10),
                            Utils.getTextFormField(
                              '',
                              vehicleIdController,
                              label: Utils.getText('Vehicle Id', color: AppC.grey),),
                            const SizedBox(height: 10),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Utils.getTextFormField(
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
                                            Utils.convertDateTimeToTheFormats(
                                                value.toString());
                                      }
                                    });
                                  },
                                  label: Utils.getText('Purchase Date',
                                      color: AppC.grey),
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
                            const SizedBox(height: 10),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Utils.getTextFormField(
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
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 35,
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
                              height: 10,
                            ),
                            Visibility(
                              visible: receiptImageFile.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: SizedBox(
                                  height: 100, // Set a height for the ListView
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
                                                ? Utils.getOvalCachedImageNetworkDisplay(
                                                context,
                                                receiptImageFile[index]['path'] ?? '')
                                                : ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.file(
                                                File(receiptImageFile[index]['file']?.path ?? ''),
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: InkWell(
                                                onTap: () {
                                                  if ((receiptImageFile[index]['path'] ?? '').isEmpty) {
                                                    receiptImageFile.removeAt(index);
                                                  } else {
                                                    vehicleDataBloc.add(
                                                      DeleteExpenseImage(
                                                          id: receiptImageFile[index]['id']),
                                                    );
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
                                          size: 12,
                                        color: const Color(0xff0580b5),
                                          weight: FontWeight.w500,
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: showMore,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Visibility(
                                visible: widget.showHeader,
                                child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
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
                                                vehicleImageFile.add({'file': value, 'path': ''});
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
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: vehicleImageFile.isNotEmpty,
                                    child: SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: vehicleImageFile.length,
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              (vehicleImageFile[index]['path'] ?? '').isNotEmpty
                                                  ? Utils.getOvalCachedImageNetworkDisplay(context,
                                                  vehicleImageFile[index]['path'] ?? '')
                                                  : ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.file(
                                                  File(vehicleImageFile[index]['file']?.path ?? ''),
                                                  width: 100.0,
                                                  height: 100.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: InkWell(
                                                  onTap: () {
                                                    if ((vehicleImageFile[index]['path'] ?? '').isEmpty) {
                                                      vehicleImageFile.removeAt(index);
                                                    } else {
                                                      vehicleDataBloc.add(
                                                          DeleteVehicleImage(
                                                              id: vehicleImageFile[index]['id']));
                                                      vehicleImageFile.removeAt(index);
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
                                                        Icons
                                                            .delete_outline_outlined,
                                                        color: AppC.white,
                                                        size: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Utils.getTextFormField(
                                    '',
                                    earningsController,
                                    label: Utils.getText('Earnings', color: AppC.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Utils.getTextFormField(
                                    '',
                                    utilizationRateController,
                                    label: Utils.getText('Utilization Rate', color: AppC.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Utils.getTextFormField(
                                    '',
                                    platformController,
                                    label: Utils.getText('Platform', color: AppC.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Utils.getTextFormField(
                                    '',
                                    mileageController,
                                    label: Utils.getText('Mileage', color: AppC.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Utils.getTextFormField(
                                    '',
                                    wholeSaleAmountController,
                                    label: Utils.getText('Wholesale Amount', color: AppC.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Utils.dropdownBox(
                                    'Select Category',
                                    categoriesData,
                                        (selectedValue) {
                                      setState(() {
                                        selectedCategoriesData =
                                            selectedValue; // Store the selected value
                                      });
                                    },
                                    labelKey: 'category_name',
                                    initialSelection: selectedCategoriesData,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 35,
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
                                    height: 10,
                                  ),
                                ],
                                                            ),
                              ),
                            Utils.getBorderedMultilineTextField(
                              'Address',
                              addressController,
                              minLines: 3,
                              fillColor: AppC.white,
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      checkBoxWithSingleText(
                                        value: bouncie,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            bouncie = value ?? false;
                                            widget.vehicle['bouncie'] = bouncie ? 1 : 0;
                                          });
                                        },
                                        label: 'Bouncie',
                                      ),
                                      const SizedBox(height: 10,),
                                      checkBoxWithSingleText(
                                        value: tollTags,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            tollTags = value ?? false;
                                            widget.vehicle['toll_tags'] = tollTags ? 1 : 0;
                                          });
                                        },
                                        label: 'Toll tags',
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      checkBoxWithSingleText(
                                        value: airTag,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            airTag = value ?? false;
                                            widget.vehicle['air_tag'] = airTag ? 1 : 0;

                                          });
                                        },
                                        label: 'AirTag',
                                      ),
                                      const SizedBox(height: 10,),
                                      checkBoxWithSingleText(
                                        value: spareTire,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            spareTire = value ?? false;
                                            widget.vehicle['spare_tire'] = spareTire ? 1 : 0;

                                          });
                                        },
                                        label: 'Spare Tire',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Visibility(
                                          visible: tollTags,
                                          child:Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Utils.getTextFormField('Enter the toll tag id', tollTagsIdController),
                                          ) ),
                                      Visibility(
                                        visible: tollTags,
                                        child: Container(height: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppC.fieldBase,
                                                width: Num.borderWidthField,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(Num.subradiusButton))),
                                          child: Utils.getOutlinedButton('Toll Image', () async {
                                            await imagePickHelper
                                                .getSingleImage(ImageSource.gallery)
                                                .then((value) {
                                              if (value != null) {
                                                debugPrint('value.path: ${value.path}');
                                                // Attachments ve = Attachments(
                                                //     file: value, path: '');
                                                tollImage.add({'file': value, 'path': ''});
                                                setState(() {});
                                              } else {
                                                return;
                                              }
                                            });
                                          },
                                              iconData: const Icon(Icons.cloud_upload,
                                                  color: AppC.blue, size: 12),
                                              verticalPadding: 0,
                                              radius: BorderRadius.zero,
                                              bgColor: AppC.trans,
                                              borderColor: AppC.trans,
                                              textColor: AppC.grey),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Visibility(visible: spareTire,
                                      child:Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Utils.getTextFormField('e.g.,T165/70D18', spareTireController),
                                      ) ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: tollImage.isNotEmpty && tollTags,
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: tollImage.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            (tollImage[index]['path'] ?? '').isNotEmpty
                                                ? Utils.getOvalCachedImageNetworkDisplay(
                                                context, tollImage[index]['path'] ?? '')
                                                : ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.file(
                                                File(tollImage[index]['file']?.path ?? ''),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: InkWell(
                                                onTap: () {
                                                  if ((tollImage[index]['path'] ?? '').isEmpty) {
                                                    tollImage.removeAt(index);
                                                  } else {
                                                    // vehicleDataBloc.add(
                                                    //   DeleteExpenseImage(id: images[index]['id']),
                                                    //);
                                                    tollImage.removeAt(index);
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
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                checkBoxWithSingleText(
                                  value: spareKey,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      spareKey = value ?? false;
                                      widget.vehicle['spare_key'] = spareKey ? 1 : 0;
                                    });
                                  },
                                  label: 'Spare Key',

                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: checkBoxWithSingleText(
                                    value: permanentPlate,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        permanentPlate = value ?? false;
                                        widget.vehicle['permanent_plate'] = permanentPlate ? 1 : 0;
                                      });
                                    },
                                    label: 'Permanent Plate',
                                  ),
                                ),
                                Expanded(
                                  child: Visibility(visible: permanentPlate,
                                    child:checkBoxWithSingleText(
                                      value: frontLicensePlate,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          frontLicensePlate = value ?? false;
                                          widget.vehicle['front_license_plate'] = frontLicensePlate ? 1 : 0;
                                        });
                                      },
                                      label: 'Front license plate',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child:
                                  Container(height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppC.fieldBase,
                                          width: Num.borderWidthField,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(Num.subradiusButton)
                                        )
                                    ),
                                    child: Utils.getOutlinedButton('Tire Image Upload', () async {
                                      await imagePickHelper
                                          .getSingleImage(ImageSource.gallery)
                                          .then((value) {
                                        if (value != null) {
                                          debugPrint('value.path: ${value.path}');
                                          // Attachments ve = Attachments(
                                          //     file: value, path: '');
                                          tireImageFile.add({'file': value, 'path': ''});
                                          setState(() {});
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                        iconData: const Icon(Icons.cloud_upload,
                                            color: AppC.blue, size: 12),
                                        verticalPadding: 0,
                                        radius: BorderRadius.zero,
                                        bgColor: AppC.trans,
                                        borderColor: AppC.trans,
                                        textColor: AppC.grey),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Number Plate', numberPlateController,
                                      hintTextColor: AppC.grey),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: tireImageFile.isNotEmpty,
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: tireImageFile.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            (tireImageFile[index]['path'] ?? '')
                                                .isNotEmpty
                                                ? Utils
                                                .getOvalCachedImageNetworkDisplay(
                                                context,
                                                tireImageFile[index]
                                                ['path'] ?? '')
                                                : ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.file(
                                                File(tireImageFile[index]
                                                ['file']?.path ?? ''),
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: InkWell(
                                                onTap: () {
                                                  if ((tireImageFile[index]
                                                  ['path'] ?? '').isEmpty) {
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
                                        );
                                      },
                                    ),
                                  ),
                                ],),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Car Number', carNumberController,
                                      hintTextColor: AppC.grey),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Oil grade', oilGradeController,
                                      hintTextColor: AppC.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Front tire e.g., 215/55R17', frontTireController,
                                      hintTextColor: AppC.grey),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Rear tire e.g., 215/55R17', rearTireController,
                                      hintTextColor: AppC.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Utils.getText('Reg Stick date',weight: FontWeight.bold),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Utils.getTextFormField(
                                            'dd-mm-yyyy',
                                            renewalDateController,
                                            hintTextColor: AppC.grey,
                                            suffixIcon: const Icon(
                                              Icons.date_range,
                                              color: AppC.appColor,
                                              size: 15,
                                            ),
                                            readOnly: true,
                                            onTapCallback: () {
                                              Utils.datePicker(context, '',
                                                  initial: DateTime.tryParse(renewalDateController.text))
                                                  .then((value) {
                                                if (value != null) {
                                                  renewalDateController.text =
                                                      Utils.convertDateTimeToTheFormat(value.toString());
                                                }
                                              });
                                            },

                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppC.fieldBase,
                                              width: Num.borderWidthField,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(Num.subradiusButton))),
                                        child: Utils.getOutlinedButton('Upload Reg Sticker', () async {
                                          await imagePickHelper
                                              .getSingleImage(ImageSource.gallery)
                                              .then((value) {
                                            if (value != null) {
                                              debugPrint('value.path: ${value.path}');
                                              // Attachments ve = Attachments(
                                              //     file: value, path: '');
                                              uploadRegSticker.add({ 'file': value,
                                                'path': '',});
                                              debugPrint('uploadRegSticker: ${uploadRegSticker}');
                                              setState(() {});
                                            } else {
                                              return;
                                            }
                                          });
                                        },
                                            iconData: const Icon(Icons.cloud_upload,
                                                color: AppC.blue, size: 12),
                                            verticalPadding: 0,
                                            radius: BorderRadius.zero,
                                            bgColor: AppC.trans,
                                            borderColor: AppC.trans,
                                            textColor: AppC.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: uploadRegSticker.isNotEmpty,
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: uploadRegSticker.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            (uploadRegSticker[index]['path'] ?? '').isNotEmpty
                                                ? Utils.getOvalCachedImageNetworkDisplay(
                                                context, uploadRegSticker[index]['path'] ?? '')
                                                : ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.file(
                                                File(uploadRegSticker[index]['file']
                                                    ?.path ?? ''),
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: InkWell(
                                                onTap: () {
                                                  if ((uploadRegSticker[index]['path'] ?? '').isEmpty) {
                                                    uploadRegSticker.removeAt(index);
                                                  } else {
                                                    // vehicleDataBloc.add(
                                                    //   DeleteExpenseImage(id: images[index]['id']),
                                                    //);
                                                    uploadRegSticker.removeAt(index);
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
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.showHeader)
                              Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Utils.getTextFormField(
                                          'Current Odometer',
                                          currentOdometerController
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(child: Utils.getTextFormField(
                                        'Oil Change Odometer',
                                        oilChangeOdometerController
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Utils.getTextFormField('Maintenance Check(day from today)', maintenanceCheckController),
                                const SizedBox(height: 10,),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Utils.getTextFormField(
                                      'Insurance Agent',
                                      insuranceAgentController
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(child: Utils.getTextFormField(
                                    'Insurance Cost',
                                    insuranceCostController
                                ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Container(height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(Num.subradiusButton))),
                              child: Utils.getOutlinedButton('Insurance Image', () async {
                                await imagePickHelper
                                    .getSingleImage(ImageSource.gallery)
                                    .then((value) {
                                  if (value != null) {
                                    debugPrint('value.path: ${value.path}');
                                    // Attachments ve = Attachments(
                                    //     file: value, path: '');
                                    insuranceImage.add({'file': value, 'path': ''});
                                    setState(() {});
                                  } else {
                                    return;
                                  }
                                });
                              },
                                  iconData: const Icon(Icons.cloud_upload,
                                      color: AppC.blue, size: 12),
                                  verticalPadding: 0,
                                  radius: BorderRadius.zero,
                                  bgColor: AppC.trans,
                                  borderColor: AppC.trans,
                                  textColor: AppC.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Visibility(
                                visible: insuranceImage.isNotEmpty,
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: insuranceImage.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        (insuranceImage[index]['path'] ?? '').isNotEmpty
                                            ? Utils.getOvalCachedImageNetworkDisplay(
                                            context, insuranceImage[index]['path'] ?? '')
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.file(
                                            File(insuranceImage[index]['file']?.path ?? ''),
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: InkWell(
                                            onTap: () {
                                              if ((insuranceImage[index]['path'] ?? '').isEmpty) {
                                                insuranceImage.removeAt(index);
                                              } else {
                                                // vehicleDataBloc.add(
                                                //   DeleteExpenseImage(id: images[index]['id']),
                                                //);
                                                insuranceImage.removeAt(index);
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
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (widget.showHeader)
                              Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      showMore = !showMore;
                                      setState(() {});
                                    },
                                    child: Utils.getText(' Less ...',
                                        size: 12,
                                        color: const Color(0xff0580b5),
                                        weight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Utils.getAddFilledButton('Save', () {
                            if (!widget.showHeader) {
                              savePopUpMenu;
                            }
                            if (widget.showHeader) {
                              _save();
                            }
                            },bgColor: AppC.green),
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
