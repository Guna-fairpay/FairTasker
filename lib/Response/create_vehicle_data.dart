import 'dart:io';

class CreateVehicleData {
  int? id;
  String year = '';
  String make = '';
  String model = '';
  String vehicleNumber = '';
  int? selectedCohort;
  int? categoryId;
  String vin = '';
  String vehicleId = '';
  String earnings = '';
  String utilizationRate = '';
  String platform = '';
  String mileage = '';
  String wholesaleAmount = '';
  int? selectedVehicleStatus;
  List<File> chosenFiles = [];
  List<File> chosenPurchaseReceipts = [];
  int isActive = 0;
  String rentalStatus = '';
  String purchasePrice = '';
  String purchaseDate = '0';
  String address = '';
  int bouncie = 0;
  int airTag = 0;
  int tollTag = 0;
  int spareTire = 0;
  String tollTagsId = '';
  String tireSize = '';
  List<File> tollImage = [];
  int spareKey = 0;
  int permanentPlate = 0;
  int frontLicensePlate = 0;
  List<File> tireImage = [];
  String numberPlate = '';
  String carNumber = '';
  String oilGrade = '';
  String frontTire = '';
  String rearTire = '';

  String regStickerDate = '0';
  List<File> uploadRegSticker = [];
  String insuranceAgent = '';
  String insuranceCost = '';
  String currentOdometer = '';
  String oilChangeOdometer = '';
  String maintenanceCheck = '';
  List<File> insuranceImage = [];

  // ✅ Constructor
  CreateVehicleData();

  // ✅ Convert JSON to Object
  factory CreateVehicleData.fromJson(Map<String, dynamic> json) {
    return CreateVehicleData()
      ..id = json['id']
      ..year = json['year'] ?? ''
      ..make = json['make'] ?? ''
      ..model = json['model'] ?? ''
      ..vehicleNumber = json['vehicleNumber'] ?? ''
      ..insuranceImage = (json['insuranceImage'] as List<dynamic>?)
          ?.map((path) => File(path))
          .toList() ??
          [];
  }

  // ✅ Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'make': make,
      'model': model,
      'vehicleNumber': vehicleNumber,
      'insuranceImage': insuranceImage.map((file) => file.path).toList(),
    };
  }
}
