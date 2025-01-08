class CreateVehicleResponse {
  CreateVehicleResponse({
      this.message, 
      this.data,});

  CreateVehicleResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);}
  String? message;
  List<Map<String,dynamic>>? data;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['message'] = message;
  //   if (data != null) {
  //     map['data'] = data?.toJson();
  //   }
  //   return map;
  // }

}

// class VehicleData {
//   VehicleData( {
//       this.vehicleId,
//       this.vin,
//       this.make,
//       this.model,
//       this.year,
//       this.cohortId,
//       this.earnings,
//       this.utilizationRate,
//       this.platform,
//       this.mileage,
//       this.wholesaleAmount,
//       this.vehicleStatus,
//       this.active,
//       this.purchasePrice,
//       this.purchaseDate,
//       this.platformFrom,
//       this.vehicleName,
//       this.updatedAt,
//       this.createdAt,
//       this.id,});
//
//   VehicleData.fromJson(dynamic json) {
//     vehicleId = json['vehicle_id'];
//     vin = json['vin'];
//     make = json['make'];
//     model = json['model'];
//     year = json['year'];
//     cohortId = json['cohort_id'];
//     earnings = json['earnings'];
//     utilizationRate = json['utilization_rate'];
//     platform = json['platform'];
//     mileage = json['mileage'];
//     wholesaleAmount = json['wholesale_amount'];
//     vehicleStatus = json['vehicle_status'];
//     active = json['active'];
//     purchasePrice = json['purchase_price'];
//     purchaseDate = json['purchase_date'];
//     platformFrom = json['platform_from'];
//     vehicleName = json['vehicle_name'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     id = json['id'];
//   }
//   String? vehicleId;
//   String? vin;
//   String? make;
//   String? model;
//   String? year;
//   String? cohortId;
//   dynamic earnings;
//   dynamic utilizationRate;
//   dynamic platform;
//   dynamic mileage;
//   dynamic wholesaleAmount;
//   String? vehicleStatus;
//   String? active;
//   String? purchasePrice;
//   String? purchaseDate;
//   String? platformFrom;
//   String? vehicleName;
//      String? vehicleNumber;
//   String? updatedAt;
//   String? createdAt;
//   int? id;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['vehicle_id'] = vehicleId;
//     map['vin'] = vin;
//     map['make'] = make;
//     map['model'] = model;
//     map['year'] = year;
//     map['cohort_id'] = cohortId;
//     map['earnings'] = earnings;
//     map['utilization_rate'] = utilizationRate;
//     map['platform'] = platform;
//     map['mileage'] = mileage;
//     map['wholesale_amount'] = wholesaleAmount;
//     map['vehicle_status'] = vehicleStatus;
//     map['active'] = active;
//     map['purchase_price'] = purchasePrice;
//     map['purchase_date'] = purchaseDate;
//     map['platform_from'] = platformFrom;
//     map['vehicle_name'] = vehicleName;
//     map['updated_at'] = updatedAt;
//     map['created_at'] = createdAt;
//     map['id'] = id;
//     return map;
//   }
//
// }