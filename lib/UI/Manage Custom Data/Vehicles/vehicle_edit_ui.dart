import 'dart:io';
import 'dart:developer' as d;
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Component/close_badge.dart';
import '../../../Component/header.dart';
import '../../../Component/image_viewer.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Response/create_expense_field_data.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/image_pick_helper.dart';
import '../../../Utilities/num.dart';
import '../../../Response/create_vehicle_data.dart';
import '../../../Bloc/vehicle_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Todo/create_sparekey_data.dart';
import '../../dialog/show_attachments_dialog.dart';
//Set vehicle
class VehicleEditUI extends StatefulWidget {
  final bool showHeader;
  late final Map<String, dynamic> vehicle;
  final Map<String, dynamic> todoItems;
  final dynamic selectedVehicle;

  VehicleEditUI({
    super.key,
    required this.vehicle,
    this.showHeader = true,
    required this.todoItems,
    required this.selectedVehicle,
  }) {
    d.log("${vehicle}", name: "VEHICLE_DATA");
    d.log("${todoItems}", name: "TODO_DATA");
    d.log("${selectedVehicle}", name: "SELECTED_VEHICLE");
  }
  @override
  State<VehicleEditUI> createState() => _VehicleEditUIState();
}

class _VehicleEditUIState extends State<VehicleEditUI> {
  TodoViewBloc? todoViewBloc;
  late VehicleDataBloc vehicleDataBloc;
  final TextEditingController yearController = TextEditingController();
  final TextEditingController makeController  = TextEditingController();
  final TextEditingController modelController  = TextEditingController();
  final TextEditingController vehicleNumberController  = TextEditingController();
  final TextEditingController purchasePriceController  = TextEditingController();
  final TextEditingController purchaseDateController  = TextEditingController();
  final TextEditingController vinController  = TextEditingController();
  final TextEditingController vehicleIdController  = TextEditingController();
  final TextEditingController earningsController  = TextEditingController();
  final TextEditingController utilizationRateController  = TextEditingController();
  final TextEditingController platformController  = TextEditingController();
  final TextEditingController mileageController  = TextEditingController();
  final TextEditingController wholeSaleAmountController  = TextEditingController();
  CreateExpenseFieldData? createExpenseFieldData;
  List<Map<String, dynamic>> cohortsData = [];
  dynamic selectedCohortsData;
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedCategoriesData;
  List<String> vehicleStatusList = ['Active', 'InActive'];
  String? selectedVehicleStatus;
  ImagePickHelper imagePickHelper = ImagePickHelper();
  MultiImagePickHelper imageHelper = MultiImagePickHelper();
  List<dynamic> vehicleImageFile = [];
  List<dynamic> receiptImageFile = [];
  CreateVehicleData? createVehicleData;
  bool loading = false;
  bool showMore = false;
  bool isYearFieldEmpty = false;
  bool isMakeFieldEmpty = false;
  bool isModelFieldEmpty = false;
  bool isPurchaseFieldEmpty = false;
  bool isPurchaseDateFieldEmpty = false;
  bool categoriesDataIsSelected = false;
  final TextEditingController addressController  = TextEditingController();
  final TextEditingController carNumberController  = TextEditingController();
  final TextEditingController oilGradeController  = TextEditingController();
  final TextEditingController frontTireController  = TextEditingController();
  final TextEditingController rearTireController  = TextEditingController();
  final TextEditingController renewalDateController  = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  List<dynamic> tireImageFile = List.empty(growable: true);
  List<dynamic> tollImage = List.empty(growable: true);
  List<dynamic> uploadRegSticker = List.empty(growable: true);
  List<dynamic> insuranceImage = List.empty(growable: true);
  Map<String, dynamic> cohortInitialSelection = {};
  TextEditingController tollTagsIdController = TextEditingController();
  TextEditingController spareTireController = TextEditingController();
  TextEditingController insuranceCostController = TextEditingController();
  TextEditingController insuranceAgentController = TextEditingController();
  TextEditingController currentOdometerController = TextEditingController();
  TextEditingController oilChangeOdometerController = TextEditingController();
  TextEditingController maintenanceCheckController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void didUpdateWidget(covariant VehicleEditUI oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedVehicle != widget.selectedVehicle ||
        oldWidget.todoItems != widget.todoItems) {
      d.log("DID UPDATED WIDGET", name:"UPDATE_WIDGET" );
      _reinitialize();
    }
  }

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    todoViewBloc=TodoViewBloc();
    vehicleDataBloc.add(const GetDropdownVehicleData());
    vehicleDataBloc.add(const VehicleStatusCategory());
    vehicleDataBloc.add(const GetAddedVehicleListData());
    _reinitialize();
  }

  void _reinitialize() {
    d.log("${widget.vehicle}", name: "VEHICLE_UPDATED");
    setState(() {
      yearController.text = widget.selectedVehicle['year'] ?? '';
      makeController.text = widget.selectedVehicle['make'] ?? '';
      modelController.text = widget.selectedVehicle['model']?.toString() ?? '';
      vehicleNumberController.text = widget.selectedVehicle['vehicle_number']?.toString() ?? '';
      vinController.text = widget.selectedVehicle['vin']?.toString() ?? '';
      purchaseDateController.text = widget.selectedVehicle['purchase_date']?.toString() ?? '';
      vehicleIdController.text = widget.selectedVehicle['vehicle_id']?.toString() ?? '';
      purchasePriceController.text = widget.selectedVehicle['purchase_price']?.toString() ?? '';
      earningsController.text = widget.selectedVehicle['earnings']?.toString() ?? '';
      utilizationRateController.text = widget.selectedVehicle['utilization_rate']?.toString() ?? '';
      platformController.text = widget.selectedVehicle['platform']?.toString() ?? '';
      mileageController.text = widget.selectedVehicle['mileage']?.toString() ?? '';
      wholeSaleAmountController.text = widget.selectedVehicle['wholesale_amount']?.toString() ?? '';
      addressController.text = widget.selectedVehicle['address']?.toString() ?? '';
      carNumberController.text = widget.selectedVehicle['car_number']?.toString() ?? '';
      oilGradeController.text = widget.selectedVehicle['oil_grade']?.toString() ?? '';
      frontTireController.text = widget.selectedVehicle['front_tire']?.toString() ?? '';
      rearTireController.text = widget.selectedVehicle['rear_tire']?.toString() ?? '';
      renewalDateController.text = widget.selectedVehicle['registration_renewal_date']?.toString() ?? '';
      //renewalDateController.text = DateFormat('dd-MM-yyyy').parse(widget.selectedVehicle['registration_renewal_date'].toString()).toString() ?? '';
      currentOdometerController.text = widget.selectedVehicle['current_odometer']?.toString() ?? '';
      oilChangeOdometerController.text =  widget.selectedVehicle['oil_change_odometer']?.toString() ?? '';
      maintenanceCheckController.text = widget.selectedVehicle['maintenance_check']?.toString() ?? '';
      tollTagsIdController.text = widget.selectedVehicle['toll_tags_id']?.toString() ?? '';
      spareTireController.text = widget.selectedVehicle['tire_size']?.toString() ?? '';
      insuranceCostController.text = widget.selectedVehicle['insurance_cost']?.toString() ?? '';
      insuranceAgentController.text = widget.selectedVehicle['insurance_agent']?.toString() ?? '';

      vehicleImageFile.clear();
      tireImageFile.clear();
      tollImage.clear();
      uploadRegSticker.clear();
      insuranceImage.clear();
      receiptImageFile.clear();
      for (Map<String, dynamic> c in cohortsData) {
        if (c['id'] == widget.selectedVehicle['cohort_id']) {
          selectedCohortsData = c;
        }
      }
      for (Map<String, dynamic> c in categoriesData) {
        if (c['id'] == widget.selectedVehicle['vehicle_status']) {
          selectedCategoriesData = c;
        }
      }
      selectedVehicleStatus =
      (widget.selectedVehicle['active'] ?? vehicleStatusList[1]) == 1
          ? vehicleStatusList[0]
          : vehicleStatusList[1];

      vehicleImageFile = (widget.selectedVehicle['images'] as List<dynamic>?)
          ?.where((image) => image['vehicle_image_type'] == 1)
          .toList() ??
          [];
      var tireImages = (widget.selectedVehicle['images'] as List<dynamic>?)
          ?.where((image) => image['vehicle_image_type'] == 2)
          .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
          .toList() ??
          [];
      tireImageFile.addAll(tireImages);
      var tollImages = (widget.selectedVehicle['images'] as List<dynamic>?)
          ?.where((image) => image['vehicle_image_type'] == 5)
          .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
          .toList() ??
          [];
      tollImage.addAll(tollImages);
      var uploadRegStickers = (widget.selectedVehicle['images'] as List<dynamic>?)
          ?.where((image) => image['vehicle_image_type'] == 3)
          .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
          .toList() ??
          [];
      uploadRegSticker.addAll(uploadRegStickers);
      var insuranceImages = (widget.selectedVehicle['images'] as List<dynamic>?)
          ?.where((image) => image['vehicle_image_type'] == 4)
          .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
          .toList() ??
          [];
      insuranceImage.addAll(insuranceImages);
      receiptImageFile.addAll(widget.selectedVehicle['expenses']?['attachments'] ?? []);
      bouncie = (widget.selectedVehicle['bouncie'] == 1);
      airTag = (widget.selectedVehicle['air_tag'] == 1);
      permanentPlate = (widget.selectedVehicle['permanent_plate'] == 1);
      spareTire = (widget.selectedVehicle['spare_tire'] == 1);
      spareKey = (widget.selectedVehicle['spare_key'] == 1);
      permanentPlate = (widget.selectedVehicle['permanent_plate'] == 1);
      frontLicensePlate = (widget.selectedVehicle['front_license_plate'] == 1);
      tollTags = (widget.selectedVehicle['toll_tags'] == 1);
    });
    if (widget.showHeader == false) {
      showMore = true;
    }
    print("tollImage $tollImage");
    d.log("$tollImage", name: "vehicle_edit");
    d.log("${widget.showHeader}", name: "showHeader");
  }

  void _save() async {

    formKey.currentState?.save();
    FocusScope.of(context).unfocus();
    print("save function triggered");
    setState(() {
      isYearFieldEmpty = yearController.text.isEmpty;
      isMakeFieldEmpty = makeController.text.isEmpty;
      isModelFieldEmpty = modelController.text.isEmpty;
      isPurchaseFieldEmpty = purchasePriceController.text.isEmpty;
      isPurchaseDateFieldEmpty = purchaseDateController.text.isEmpty;
    });

    final createVehicleData = CreateVehicleData()
      ..id = widget.vehicle['id']
      ..year = yearController.text
      ..make = makeController.text
      ..model = modelController.text
      ..vin = vinController.text
      ..vehicleId = vehicleIdController.text
      ..earnings = earningsController.text
      ..utilizationRate = utilizationRateController.text
      ..platform = platformController.text
      ..mileage = mileageController.text
      ..wholesaleAmount = wholeSaleAmountController.text
      ..purchaseDate = purchaseDateController.text
      ..purchasePrice = purchasePriceController.text
      ..address = addressController.text
      ..vehicleNumber = vehicleNumberController.text
      ..carNumber = carNumberController.text
      ..oilGrade = oilGradeController.text
      ..frontTire = frontTireController.text
      ..rearTire = rearTireController.text
      ..insuranceAgent = insuranceAgentController.text
      ..insuranceCost = insuranceCostController.text
      ..bouncie = boolToInt(bouncie)
      ..airTag = boolToInt(airTag)
      ..permanentPlate = boolToInt(permanentPlate)
      ..spareTire = boolToInt(spareTire)
      ..tollTag = boolToInt(tollTags)
      ..spareKey = spareKey == true ? 1 : 0
      ..frontLicensePlate = boolToInt(frontLicensePlate)
      ..tireSize = spareTireController.text
      ..regStickerDate = renewalDateController.text
      ..currentOdometer = currentOdometerController.text
      ..oilChangeOdometer = oilChangeOdometerController.text
      ..maintenanceCheck = maintenanceCheckController.text
      ..tollTagsId = tollTagsIdController.text
      ..selectedVehicleStatus = selectedCategoriesData?['id']
      ..selectedCohort = selectedCohortsData?['id']
      ..isActive = selectedVehicleStatus == 'Active' ? 1 : 0;

    setState(() {
      createVehicleData.insuranceImage = insuranceImage.whereType<File>().toList();
      createVehicleData.tollImage = tollImage.whereType<File>().toList();
      createVehicleData.tireImage = tireImageFile.whereType<File>().toList();
      createVehicleData.uploadRegSticker = uploadRegSticker.whereType<File>().toList();
      vehicleDataBloc.add(UpdateVehicleDataEvent(createVehicleData: createVehicleData));
    });
    await _fetchUpdatedImages();
    imageCache.clear();
    imageCache.clearLiveImages();

  }



  Future<void> _fetchUpdatedImages() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      vehicleImageFile = widget.vehicle['images'] ?? [];
    });
  }

  @override
  void dispose() {
    yearController.dispose();
    makeController.dispose();
    modelController.dispose();
    vehicleNumberController.dispose();
    vinController.dispose();
    purchaseDateController.dispose();
    vehicleIdController.dispose();
    purchasePriceController.dispose();
    earningsController.dispose();
    utilizationRateController.dispose();
    platformController.dispose();
    mileageController.dispose();
    wholeSaleAmountController.dispose();
    addressController.dispose();
    carNumberController.dispose();
    oilGradeController.dispose();
    frontTireController.dispose();
    rearTireController.dispose();
    renewalDateController.dispose();
    currentOdometerController.dispose();
    oilChangeOdometerController.dispose();
    maintenanceCheckController.dispose();
    tollTagsIdController.dispose();
    spareTireController.dispose();
    insuranceCostController.dispose();
    insuranceAgentController.dispose();
    super.dispose();
  }

  int boolToInt(bool value) => value ? 1 : 0;

  Future<List<File>?> _pickImages2({ImageSource source = ImageSource.gallery}) async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    return images.map((e) => File(e.path)).toList();
  }

  void savePopUpMenu() {
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Utils.getText('Confirmation',
                          size: 18, weight: FontWeight.bold, color: const Color(0xff495057)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Utils.getAddFilledButton('Save', () {
                          formKey.currentState?.save();
                          FocusScope.of(context).unfocus();
                          _save();
                          Navigator.pop(context);
                        }),
                        Utils.getAddFilledButton('Save With Spare Key Task', () {
                          _save();
                          CreateSpareKeyData sparekeyData = CreateSpareKeyData()
                            ..title = "Spare Key"
                            ..branchId = widget.todoItems['branch_id'] != null
                                ? int.tryParse(widget.todoItems['branch_id'].toString())
                                : null
                            ..cohortId = widget.todoItems['cohort_id'] != null
                                ? int.tryParse(widget.todoItems['cohort_id'].toString())
                                : null
                            ..identifierId = widget.todoItems['identifier_id'] != null
                                ? int.tryParse(widget.todoItems['identifier_id'].toString())
                                : null
                            ..location = widget.todoItems['location'] ?? ''
                            ..locationId = widget.todoItems['location_id'] ?? ''
                            ..notes = widget.todoItems['notes'] ?? ''
                            ..startAt = widget.todoItems['todo_date'] ?? ''
                            ..timeSensitive = '0'
                            ..todoTime = widget.todoItems['todo_time'] ?? ''
                            ..todoUserType = widget.todoItems['todo_user_type'] != null
                                ? int.tryParse(widget.todoItems['todo_user_type'].toString())
                                : null
                            ..userGroupId = widget.todoItems['user_group_id'] != null
                                ? int.tryParse(widget.todoItems['user_group_id'].toString())
                                : null
                            ..userId = widget.todoItems['user_id'] ?? ''
                            ..vehicleName = widget.vehicle['vehicle_name'] ?? ''
                            ..vehicles = widget.todoItems['vehicles'] ?? []
                            ..vendorId = widget.todoItems['vendor_id'] != null
                                ? int.tryParse(widget.todoItems['vendor_id'].toString())
                                : null
                            ..vendorName = widget.todoItems['vendor_name'] ?? ''
                            ..vehicleNumber = widget.vehicle['vehicle_number']
                            ..vin = widget.vehicle['vin'] ?? '';
                          todoViewBloc!.add(AddSpareKeyTask(createSpareKeyTaskData: sparekeyData));
                          formKey.currentState?.save();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        }, bgColor: AppC.green),
                        Utils.getAddFilledButton('Cancel', () {
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
    double scale = 1.0,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: scale,
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

  bool isImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showHeader
        ? Scaffold(
      resizeToAvoidBottomInset: true,
        backgroundColor: AppC.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(35.0),
          child: HeaderView(),
        ),
        body: body)
        : body;
  }

  Widget get body => BlocProvider(
    create: (context) => vehicleDataBloc,
    child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
      listener: (context, state)
      {
        if (state is VehicleDataLoading) {
          EasyLoading.show();
        }
        else if (state is DropdownVehicleDataLoaded)
        {
          EasyLoading.dismiss();
          print("vehicle data ${widget.vehicle['vehicle_name']}");
          createExpenseFieldData = state.createExpenseFieldData;
          if (state.createExpenseFieldData != null) {
            setState(() {
              loading = false;
            });
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
          }
          setState(() {
            loading = false;
          });
        }
        else if (state is VehicleStatusCategoryLoaded) {
          setState(() {
            categoriesData = state.vehicleStatusDataList ?? [];
            categoriesDataIsSelected = true;
            selectedCategoriesData = categoriesData.isNotEmpty ? categoriesData[0] : null;
            loading= false;
          });
        }
        else if (state is VehicleDataUpdatedState) {
          print("VehicleDataUpdatedState");
          print("widget.vehicle (before): ${widget.vehicle}");
          setState(() {
            widget.vehicle = state.updatedVehicle;
            loading = false;
          });
          Utils.showMobileToast('Vehicle updated successfully!');
        }
        else {
          setState(() {
            loading = false;
          });
        }
        if (renewalDateController.text.isNotEmpty) {
          try {
            final parsed = DateTime.parse(renewalDateController.text);
            renewalDateController.text = DateFormat('dd-MM-yyyy').format(parsed);
          } catch (e) {
            // handle or ignore invalid date format
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
            key: formKey,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
                        Utils.getText('Edit Vehicle', size: 20, weight: FontWeight.bold)
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
                              child: vehicleImageFile.isNotEmpty
                                  ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    (vehicleImageFile.first['path'] ?? '').isNotEmpty
                                        ? Utils.getHeadCachedImageNetworkDisplay(
                                        context, vehicleImageFile.first['path'] ?? '')
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
                                  : const SizedBox(),
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
                              borderColor: isYearFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                            if (isYearFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline, color: Colors.red),
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
                              borderColor: isMakeFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                            if (isMakeFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline, color: Colors.red),
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
                              borderColor: isModelFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                            if (isModelFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline, color: Colors.red),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Utils.getTextFormField(
                          '',
                          vehicleNumberController,
                          label: Utils.getText('Vehicle Number', color: AppC.grey),
                        ),
                        const SizedBox(height: 10),
                        Utils.dropdownBox(
                          'Select Cohort',
                          cohortsData,
                              (selectedValue) {
                            setState(() {
                              selectedCohortsData = selectedValue;
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
                          label: Utils.getText('Vehicle Id', color: AppC.grey),
                        ),
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
                                Utils.datePicker(context, '', initial: DateTime.parse("1970-01-01"))
                                    .then((value) {
                                  if (value != null) {
                                    purchaseDateController.text =
                                        Utils.convertDateToYearMonthDateFormat(value.toString());
                                  }
                                });
                              },
                              label: Utils.getText('Purchase Date', color: AppC.grey),
                              borderColor: isPurchaseDateFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                            if (isPurchaseDateFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline, color: Colors.red),
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
                              label: Utils.getText('Purchase Price', color: AppC.grey),
                              borderColor: isPurchaseFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                            if (isPurchaseFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline, color: Colors.red),
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
                                borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                            child: Utils.getOutlinedButton('Purchase Receipt', () async {
                              await imagePickHelper.getSingleImage(ImageSource.gallery).then((value) {
                                if (value != null) {
                                  receiptImageFile.add({'file': value, 'path': ''});
                                  setState(() {});
                                }
                              });
                            },
                                iconData: const Icon(Icons.cloud_upload, color: AppC.appColor, size: 15),
                                verticalPadding: 0,
                                radius: BorderRadius.zero,
                                bgColor: AppC.trans,
                                borderColor: AppC.trans,
                                textColor: AppC.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: receiptImageFile.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(
                              height: 100,
                              child:
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: receiptImageFile.length,
                                itemBuilder: (context, index)
                                {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        (receiptImageFile[index]['path'] ?? '').isNotEmpty
                                            ? Utils.getOvalCachedImageNetworkDisplay(
                                            context, receiptImageFile[index]['path'] ?? '')
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
                                                  DeleteExpenseImage(id: receiptImageFile[index]['id']),
                                                );
                                                receiptImageFile.removeAt(index);
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppC.red,
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
                                  Utils.getText(
                                    ' More ...',
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
                                      borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                  child: Utils.getOutlinedButton('Vehicle Image', () async {
                                    await imagePickHelper.getSingleImage(ImageSource.gallery).then((value) {
                                      if (value != null) {
                                        vehicleImageFile.add({'file': value, 'path': ''});
                                        setState(() {});
                                      }
                                    });
                                  },
                                      iconData: const Icon(Icons.cloud_upload, color: AppC.appColor, size: 15),
                                      verticalPadding: 0,
                                      radius: BorderRadius.zero,
                                      bgColor: AppC.trans,
                                      borderColor: AppC.trans,
                                      textColor: AppC.grey),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                              ? Utils.getOvalCachedImageNetworkDisplay(
                                              context, vehicleImageFile[index]['path'] ?? '')
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
                                                  vehicleDataBloc
                                                      .add(DeleteVehicleImage(id: vehicleImageFile[index]['id']));
                                                  vehicleImageFile.removeAt(index);
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppC.red,
                                                ),
                                                alignment: Alignment.center,
                                                child: const Icon(Icons.delete_outline_outlined,
                                                    color: AppC.white, size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppC.fieldBase,
                                        width: Num.borderWidthField,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                  child: DropdownButton<String>(
                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Utils.getText('Status', color: AppC.grey),
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
                                      selectedVehicleStatus = value;
                                      setState(() {});
                                    },
                                    items: vehicleStatusList.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Utils.getText(value),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Utils.getBorderedMultilineTextField(
                          'Address',
                          addressController,
                          minLines: 3,
                          fillColor: AppC.white,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                              Column(
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
                                  const SizedBox(height: 10),
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
                                  const SizedBox(height: 10),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Visibility(
                                      visible: tollTags,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Utils.getTextFormField('Enter the toll tag id', tollTagsIdController),
                                      )),
                                  Visibility(
                                    visible: tollTags,
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppC.fieldBase,
                                            width: Num.borderWidthField,
                                          ),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                      child: Utils.getOutlinedButton(
                                        'Toll Image',
                                            () async {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          var result = await _pickImages2();
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          if (result != null) {
                                            var files = tollImage.whereType<File>().map((e) => e.path);
                                            for (var element in result) {
                                              if (!files.contains(element.path)) {
                                                tollImage.add(element);
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                                        verticalPadding: 0,
                                        radius: BorderRadius.zero,
                                        bgColor: AppC.trans,
                                        borderColor: AppC.trans,
                                        textColor: AppC.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Visibility(
                                  visible: spareTire,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Utils.getTextFormField('e.g.,T165/70D18',
                                        spareTireController,
                                      validator: (value){
                                        final SpareTireRegex = RegExp(r'^[A-Z]?\d{3}/\d{2}[A-Z]\d{2}$');
                                        if (!SpareTireRegex.hasMatch(value ?? '')) {
                                          return 'T165/70D18';
                                        }
                                        return null;
                                      }
                                    ),
                                  )
                              ),
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
                                    return CloseBadge(
                                        onTapView: () {
                                          ShowAttachmentsDialog.of.show(context,
                                              attachments: tollImage, title: "", currentAttachment: tollImage[index]);
                                        },
                                        onTapDelete: () {
                                          setState(() {
                                            if (tollImage[index] is File) {
                                              tollImage.removeAt(index);
                                            } else {
                                              int? tollImageId = (widget.vehicle['images'] as List<dynamic>?)?.firstWhere(
                                                      (image) =>
                                                  tollImage[index].split('/').last ==
                                                      image['path'].split('/').last,
                                                  orElse: () => null)?['id'];
                                              if (tollImageId != null) {
                                                context
                                                    .read<VehicleDataBloc>()
                                                    .add(DeleteVehicleImage(id: tollImageId));
                                                tollImage.removeAt(index);
                                              }
                                            }
                                            tollImage = List.from(tollImage);
                                          });
                                          context
                                              .read<VehicleDataBloc>()
                                              .add(const GetAddedVehicleListData());
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
                                          child: ImageViewer(
                                            fit: BoxFit.cover,
                                            imageInput: tollImage[index],
                                            isNotImage: !(tollImage[index] as Object).isImage,
                                          ),
                                        ));
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            checkBoxWithSingleText(
                              value: permanentPlate,
                              onChanged: (bool? value) {
                                setState(() {
                                  permanentPlate = value ?? false;
                                  widget.vehicle['permanent_plate'] = permanentPlate ? 1 : 0;
                                });
                              },
                              label: 'Permanent Plate',
                            ),
                            Expanded(
                              child: Visibility(
                                visible: permanentPlate,
                                child: checkBoxWithSingleText(
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
                        const SizedBox(height: 10),
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                              child:
                              Utils.getOutlinedButton(
                                'Tire Image Upload',
                                    () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  var result = await _pickImages2();
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if (result != null) {
                                    var files = tireImageFile.whereType<File>().map((e) => e.path);
                                    for (var element in result) {
                                      if (!files.contains(element.path)) {
                                        tireImageFile.add(element);
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                                radius: BorderRadius.zero,
                                bgColor: AppC.trans,
                                borderColor: AppC.trans,
                                textColor: AppC.grey,
                                verticalPadding: 0,
                              ),
                            ),
                            Expanded(
                              child: Utils.getTextFormField('Number Plate', vehicleNumberController,
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
                                    return CloseBadge(
                                        onTapView: () {
                                          ShowAttachmentsDialog.of.show(context,
                                              attachments: tireImageFile,
                                              title: "",
                                              currentAttachment: tireImageFile[index]);
                                        },
                                        onTapDelete: () async {
                                          setState(() {
                                            if (tireImageFile[index] is File) {
                                              tireImageFile.removeAt(index);
                                            }
                                          });
                                          int? imageId;
                                          if (tireImageFile[index] is! File) {
                                            final image = (widget.vehicle['images'] as List<dynamic>?)?.firstWhere(
                                                  (image) =>
                                              tireImageFile[index].split('/').last ==
                                                  image['path'].split('/').last,
                                              orElse: () => null,
                                            );
                                            if (image != null) {
                                              imageId = image['id'];
                                              context.read<VehicleDataBloc>().add(DeleteVehicleImage(id: imageId));
                                            }
                                          }
                                          if (imageId != null) {
                                            await Future.delayed(const Duration(milliseconds: 300));
                                          }
                                          setState(() {
                                            tireImageFile.removeAt(index);
                                          });
                                          context
                                              .read<VehicleDataBloc>()
                                              .add(const GetAddedVehicleListData());
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
                                          child: ImageViewer(
                                            fit: BoxFit.cover,
                                            imageInput: tireImageFile[index],
                                            isNotImage: !(tireImageFile[index] as Object).isImage,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField('Car Number', carNumberController,
                                  hintTextColor: AppC.grey),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Utils.getTextFormField('Oil grade', oilGradeController,
                                  hintTextColor: AppC.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField('Front tire e.g., 215/55R17',
                                  frontTireController,
                                  hintTextColor: AppC.grey,
                                validator: (value){
                                  final FrontTireRegex = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                                  if (!FrontTireRegex.hasMatch(value ?? '')) {
                                    return '215/55R17';
                                  }
                                  return null;
                                }
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Utils.getTextFormField('Rear tire e.g., 215/55R17',
                                rearTireController,
                                  hintTextColor: AppC.grey,
                                  validator: (value){
                                    final BackTireRegex = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                                    if (!BackTireRegex.hasMatch(value ?? '')) {
                                      return '215/55R17';
                                    }
                                    return null;
                                  }
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Utils.getText('Reg Sticker date', weight: FontWeight.bold),
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
                                        suffixIcon: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.date_range,
                                            color: AppC.appColor,
                                            size: 15,
                                          ),
                                        ),

                                        readOnly: true,
                                        onTapCallback: () {
                                          //d.log("${renewalDateController.text}" ,name: 'renewalDateController.text');
                                          renewalDateController.text = DateFormat('dd-MM-yyyy').format(DateTime?.tryParse(renewalDateController.text) ?? DateTime.now());
                                          d.log("${renewalDateController.text}" ,name: 'renewalDateController.text');
                                          Utils.datePicker(context, '',
                                              initial: DateFormat('dd-MM-yyyy').parse(renewalDateController.text))
                                              .then((value) {
                                            if (value != null) {
                                              renewalDateController.text =
                                                  DateFormat('dd-MM-yyyy').format(value);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppC.fieldBase,
                                        width: Num.borderWidthField,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                  child: Utils.getOutlinedButton(
                                    'Upload Reg Sticker',
                                        () async {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      var result = await _pickImages2();
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if (result != null) {
                                        var files = uploadRegSticker.whereType<File>().map((e) => e.path);
                                        for (var element in result) {
                                          if (!files.contains(element.path)) {
                                            uploadRegSticker.add(element);
                                          }
                                        }
                                        setState(() {});
                                      }
                                    },
                                    iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                                    verticalPadding: 0,
                                    radius: BorderRadius.zero,
                                    bgColor: AppC.trans,
                                    borderColor: AppC.trans,
                                    textColor: AppC.grey,
                                  ),
                                ),
                              ],
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
                                    return CloseBadge(
                                        onTapView: () {
                                          ShowAttachmentsDialog.of.show(context,
                                              attachments: uploadRegSticker,
                                              title: "",
                                              currentAttachment: uploadRegSticker[index]);
                                        },
                                        onTapDelete: () {
                                          setState(() {
                                            if (uploadRegSticker[index] is File) {
                                              uploadRegSticker.removeAt(index);
                                            } else {
                                              int? Id = (widget.vehicle['images'] as List<dynamic>?)?.firstWhere(
                                                      (image) =>
                                                  uploadRegSticker[index].split('/').last ==
                                                      image['path'].split('/').last,
                                                  orElse: () => null)?['id'];
                                              if (uploadRegSticker != null) {
                                                context
                                                    .read<VehicleDataBloc>()
                                                    .add(DeleteVehicleImage(id: Id));
                                                uploadRegSticker.removeAt(index);
                                              }
                                            }
                                            uploadRegSticker = List.from(uploadRegSticker);
                                          });
                                          context
                                              .read<VehicleDataBloc>()
                                              .add(const GetAddedVehicleListData());
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
                                          child: ImageViewer(
                                            fit: BoxFit.cover,
                                            imageInput: uploadRegSticker[index],
                                            isNotImage: !(uploadRegSticker[index] as Object).isImage,
                                          ),
                                        ));
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
                                    child: Utils.getTextFormField('Current Odometer', currentOdometerController),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child:
                                    Utils.getTextFormField('Oil Change Odometer', oilChangeOdometerController),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Utils.getTextFormField(
                                  'Maintenance Check(day from today)', maintenanceCheckController),
                              const SizedBox(height: 10),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField('Insurance Agent', insuranceAgentController),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Utils.getTextFormField('Insurance Cost', insuranceCostController),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                          child: Utils.getOutlinedButton(
                            'Insurance Image',
                                () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              var result = await _pickImages2();
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (result != null) {
                                var files = insuranceImage.whereType<File>().map((e) => e.path);
                                for (var element in result) {
                                  if (!files.contains(element.path)) {
                                    insuranceImage.add(element);
                                  }
                                }
                                setState(() {});
                              }
                            },
                            iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                            verticalPadding: 0,
                            radius: BorderRadius.zero,
                            bgColor: AppC.trans,
                            borderColor: AppC.trans,
                            textColor: AppC.grey,
                          ),
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
                                return CloseBadge(
                                    onTapView: () {
                                      ShowAttachmentsDialog.of.show(context,
                                          attachments: insuranceImage,
                                          title: "",
                                          currentAttachment: insuranceImage[index]);
                                    },
                                    onTapDelete: () {
                                      setState(() {
                                        if (insuranceImage[index] is File) {
                                          insuranceImage.removeAt(index);
                                        } else {
                                          int? Id = (widget.vehicle['images'] as List<dynamic>?)?.firstWhere(
                                                  (image) =>
                                              insuranceImage[index].split('/').last ==
                                                  image['path'].split('/').last,
                                              orElse: () => null)?['id'];
                                          if (insuranceImage != null) {
                                            context
                                                .read<VehicleDataBloc>()
                                                .add(DeleteVehicleImage(id: Id));
                                            insuranceImage.removeAt(index);
                                          }
                                        }
                                        insuranceImage = List.from(insuranceImage);
                                      });
                                      context
                                          .read<VehicleDataBloc>()
                                          .add(const GetAddedVehicleListData());
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
                                      child: ImageViewer(
                                        fit: BoxFit.cover,
                                        imageInput: insuranceImage[index],
                                        isNotImage: !(insuranceImage[index] as Object).isImage,
                                      ),
                                    ));
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
                                      size: 12, color: const Color(0xff0580b5), weight: FontWeight.w500)),
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (spareKey == false) {
                          savePopUpMenu();
                        } else if (spareKey == true) {
                          _save();
                        }
                      }, bgColor: AppC.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
