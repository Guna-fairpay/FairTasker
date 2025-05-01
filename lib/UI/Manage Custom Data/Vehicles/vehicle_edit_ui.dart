import 'dart:io';
import 'dart:developer' as d;
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
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
  late final Map<String, dynamic>? vehicle;
  final Map<String, dynamic> todoItems;
  final dynamic selectedVehicle;

  VehicleEditUI({
    super.key,
    this.vehicle,
    this.showHeader = true,
    required this.todoItems,
    required this.selectedVehicle,
  }) {
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

  DateTime? renewalDate;

  bool bouncie = false;
  bool tollTags = false;
  bool airTag = false;
  bool permanentPlate = false;
  bool spareTire = false;
  bool spareKey = false;
  bool frontLicensePlate = false;
  List<dynamic> images = List.empty(growable: true);
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
      currentOdometerController.text = widget.selectedVehicle['current_odometer']?.toString() ?? '';
      oilChangeOdometerController.text =  widget.selectedVehicle['oil_change_odometer']?.toString() ?? '';
      maintenanceCheckController.text = widget.selectedVehicle['maintenance_check']?.toString() ?? '';
      tollTagsIdController.text = widget.selectedVehicle['toll_tags_id']?.toString() ?? '';
      spareTireController.text = widget.selectedVehicle['tire_size']?.toString() ?? '';
      insuranceCostController.text = widget.selectedVehicle['insurance_cost']?.toString() ?? '';
      insuranceAgentController.text = widget.selectedVehicle['insurance_agent']?.toString() ?? '';
      renewalDate = (widget.selectedVehicle['registration_renewal_date']??'').toString()
          .toDateTime(inputFormat: 'yyyy-MM-dd');
      Console.of.log("renewalDate $renewalDate");
      Console.of.log("renewalDate ${widget.selectedVehicle['registration_renewal_date']}");
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
      ..id = widget.vehicle?['id'] ?? ''
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
      ..regStickerDate = renewalDate.toString()
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
      vehicleDataBloc.add(UpdateVehicleDataEvent(createVehicleData: createVehicleData, vin: widget.selectedVehicle['vin']));
    });
    await _fetchUpdatedImages();
    imageCache.clear();
    imageCache.clearLiveImages();

  }



  Future<void> _fetchUpdatedImages() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      vehicleImageFile = widget.vehicle?['images'] ?? [];
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
                            ..vehicleName = widget.vehicle?['vehicle_name'] ?? ''
                            ..vehicles = widget.todoItems['vehicles'] ?? []
                            ..vendorId = widget.todoItems['vendor_id'] != null
                                ? int.tryParse(widget.todoItems['vendor_id'].toString())
                                : null
                            ..vendorName = widget.todoItems['vendor_name'] ?? ''
                            ..vehicleNumber = widget.vehicle?['vehicle_number']
                            ..vin = widget.vehicle?['vin'] ?? '';
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
    create: (context) => vehicleDataBloc..add(setVehicleInitialEvent(vehicle: widget.selectedVehicle, todoItems: widget.todoItems)),
    child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
      listener: (context, state)
      {
        if (state is VehicleDataLoading) {
          Utils.dismissKeyboard(context);
          EasyLoading.show();
        }
        else if(state is setVehicleLoader){
          EasyLoading.dismiss();
        }
        else if(state is setVehicleLoaded){
          EasyLoading.dismiss();
          d.log("${state.currentVehicle?['vehicle_id'] ?? ''}");
          yearController.text = state.currentVehicle['year'] ?? '';
          makeController.text = state.currentVehicle['make'] ?? '';
          modelController.text = state.currentVehicle['model']?.toString() ?? '';
          vehicleNumberController.text = state.currentVehicle['vehicle_number']?.toString() ?? '';
          vinController.text = state.currentVehicle['vin']?.toString() ?? '';
          purchaseDateController.text = state.currentVehicle['purchase_date']?.toString() ?? '';
          vehicleIdController.text = state.currentVehicle['vehicle_id']?.toString() ?? '';
          purchasePriceController.text = state.currentVehicle['purchase_price']?.toString() ?? '';
          earningsController.text = state.currentVehicle['earnings']?.toString() ?? '';
          utilizationRateController.text = state.currentVehicle['utilization_rate']?.toString() ?? '';
          platformController.text = state.currentVehicle['platform']?.toString() ?? '';
          mileageController.text = state.currentVehicle['mileage']?.toString() ?? '';
          wholeSaleAmountController.text = state.currentVehicle['wholesale_amount']?.toString() ?? '';
          addressController.text = state.currentVehicle['address']?.toString() ?? '';
          carNumberController.text = state.currentVehicle['car_number']?.toString() ?? '';
          oilGradeController.text = state.currentVehicle['oil_grade']?.toString() ?? '';
          frontTireController.text = state.currentVehicle['front_tire']?.toString() ?? '';
          rearTireController.text = state.currentVehicle['rear_tire']?.toString() ?? '';
          renewalDateController.text = state.currentVehicle['registration_renewal_date']?.toString() ?? '';
          currentOdometerController.text = state.currentVehicle['current_odometer']?.toString() ?? '';
          oilChangeOdometerController.text =  state.currentVehicle['oil_change_odometer']?.toString() ?? '';
          maintenanceCheckController.text = state.currentVehicle['maintenance_check']?.toString() ?? '';
          tollTagsIdController.text = state.currentVehicle['toll_tags_id']?.toString() ?? '';
          spareTireController.text = state.currentVehicle['tire_size']?.toString() ?? '';
          insuranceCostController.text = state.currentVehicle['insurance_cost']?.toString() ?? '';
          insuranceAgentController.text = state.currentVehicle['insurance_agent']?.toString() ?? '';
          renewalDate = (state.currentVehicle['registration_renewal_date']??'').toString()
              .toDateTime(inputFormat: 'yyyy-MM-dd');
          vehicleImageFile.clear();
          tireImageFile.clear();
          tollImage.clear();
          uploadRegSticker.clear();
          insuranceImage.clear();
          receiptImageFile.clear();
          for (Map<String, dynamic> c in cohortsData) {
            if (c['id'] == state.currentVehicle['cohort_id']) {
              selectedCohortsData = c;
            }
          }
          for (Map<String, dynamic> c in categoriesData) {
            if (c['id'] == state.currentVehicle['vehicle_status']) {
              selectedCategoriesData = c;
            }
          }
          selectedVehicleStatus =
          (state.currentVehicle['active'] ?? vehicleStatusList[1]) == 1
              ? vehicleStatusList[0]
              : vehicleStatusList[1];

          images = (state.currentVehicle['images'] as List<dynamic>?) ?? [];
          vehicleImageFile = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 1)
              .toList() ??
              [];
          var tireImages = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 2)
              .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
              .toList() ??
              [];
          tireImageFile.addAll(tireImages);
          var tollImages = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 5)
              .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
              .toList() ??
              [];
          tollImage.addAll(tollImages);
          var uploadRegStickers = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 3)
              .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
              .toList() ??
              [];
          uploadRegSticker.addAll(uploadRegStickers);
          var insuranceImages = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 4)
              .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
              .toList() ??
              [];
          insuranceImage.addAll(insuranceImages);
          receiptImageFile.addAll(state.currentVehicle['expenses']?['attachments'] ?? []);
          bouncie = (state.currentVehicle['bouncie'] == 1);
          airTag = (state.currentVehicle['air_tag'] == 1);
          permanentPlate = (state.currentVehicle['permanent_plate'] == 1);
          spareTire = (state.currentVehicle['spare_tire'] == 1);
          spareKey = (state.currentVehicle['spare_key'] == 1);
          permanentPlate = (state.currentVehicle['permanent_plate'] == 1);
          frontLicensePlate = (state.currentVehicle['front_license_plate'] == 1);
          tollTags = (state.currentVehicle['toll_tags'] == 1);
        }
        else if(state is setVehicleImageLoaded){
          EasyLoading.dismiss();
          var insuranceImages = (state.currentVehicle['images'] as List<dynamic>?)
              ?.where((image) => image['vehicle_image_type'] == 4)
              .map((e) => "${Str.STORAGE_BASE_URL}${e['path']}")
              .toList() ??
              [];
          insuranceImage.addAll(insuranceImages);
          receiptImageFile.addAll(state.currentVehicle['expenses']?['attachments'] ?? []);
        }
        else {
          setState(() {
            loading = false;
          });
        }
        Console.of.debug(renewalDate);
        /*if (renewalDateController.text.isNotEmpty) {
          d.log("${renewalDateController.text}", name: "before");
          if(renewalDateController.text != "0000-00-00"){
            final parsed = DateFormat("MM-dd-yyyy").parse(renewalDateController.text);
            renewalDateController.text = DateFormat('MM-dd-yyyy').format(parsed);
          } else{
            renewalDateController.text = '';
          }
        }*/
       // d.log("${renewalDateController.text}", name: "RenewalDate");
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utils.getTextFormField(
                          "Address",
                          addressController,
                        inputAction: TextInputAction.newline,
                        textType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 5,
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
                                      widget.vehicle?['bouncie'] = bouncie ? 1 : 0;
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
                                      widget.vehicle?['toll_tags'] = tollTags ? 1 : 0;
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
                                      widget.vehicle?['air_tag'] = airTag ? 1 : 0;
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
                                      widget.vehicle?['spare_tire'] = spareTire ? 1 : 0;
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
                                        Utils.dismissKeyboard(context);
                                        var result = await _pickImages2();
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
                                            int? tollImageId = (images).firstWhere(
                                                    (image) =>
                                                tollImage[index].split('/').last ==
                                                    image['path'].split('/').last,
                                                orElse: () => null)?['id'];
                                            if (tollImageId != null) {
                                              context
                                                  .read<VehicleDataBloc>()
                                                  .add(DeleteSetVehicleImage(id: tollImageId, vin: widget.selectedVehicle['vin'].toString()));
                                              tollImage.removeAt(index);
                                            } else {
                                              Console.of.error("tollImageId is null ${tollImage[index].toString().split("/").lastOrNull} ${images}");
                                            }
                                          }
                                          tollImage = List.from(tollImage);
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
                                widget.vehicle?['spare_key'] = spareKey ? 1 : 0;
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
                                widget.vehicle?['permanent_plate'] = permanentPlate ? 1 : 0;
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
                                    widget.vehicle?['front_license_plate'] = frontLicensePlate ? 1 : 0;
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
                                var result = await _pickImages2();
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
                                          final image = (images).firstWhere(
                                                (image) =>
                                            tireImageFile[index].split('/').last ==
                                                image['path'].split('/').last,
                                            orElse: () => null,
                                          );
                                          if (image != null) {
                                            imageId = image['id'];
                                            context.read<VehicleDataBloc>().add(DeleteSetVehicleImage(id: imageId, vin: widget.selectedVehicle['vin'].toString()));
                                          }
                                        }
                                        if (imageId != null) {
                                          await Future.delayed(const Duration(milliseconds: 300));
                                        }
                                        setState(() {
                                          tireImageFile.removeAt(index);
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
                            child: CustomDateTimePicker<DateTime>(
                              controller: renewalDateController,
                              format: "MM-dd-yyyy",
                              suffixIcon: Icon(Icons.calendar_month_rounded,
                                  size: 18, color: context.theme.hintColor),
                              textAlign: TextAlign.center,
                              value: renewalDate, /*renewalDateController.text.isNotEmpty
                                  ? DateFormat('MM-dd-yyyy').tryParse(renewalDateController.text)
                                  : null,*/
                              onChanged: (value){
                                d.log("Renewal Date: $value");
                                setState(() {
                                  renewalDate = value;
                                  d.log("Renewal Date: ${renewalDate}");
                                });
                              },
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
                                    var result = await _pickImages2();
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
                                            int? Id = (images).firstWhere(
                                                    (image) =>
                                                uploadRegSticker[index].split('/').last ==
                                                    image['path'].split('/').last,
                                                orElse: () => null)?['id'];
                                            if (uploadRegSticker != null) {
                                              context
                                                  .read<VehicleDataBloc>()
                                                  .add(DeleteSetVehicleImage(id: Id, vin: widget.selectedVehicle['vin'].toString()));
                                              uploadRegSticker.removeAt(index);
                                            }
                                          }
                                          uploadRegSticker = List.from(uploadRegSticker);
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
                            var result = await _pickImages2();
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
                                        int? Id = (images).firstWhere(
                                                (image) =>
                                            insuranceImage[index].split('/').last ==
                                                image['path'].split('/').last,
                                            orElse: () => null)?['id'];
                                        if (insuranceImage != null) {
                                          context
                                              .read<VehicleDataBloc>()
                                              .add(DeleteSetVehicleImage(id: Id, vin: widget.selectedVehicle['vin'].toString()));
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getAddFilledButton('Save', () {
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
