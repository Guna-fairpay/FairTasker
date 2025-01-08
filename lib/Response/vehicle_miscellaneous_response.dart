class VehicleMiscellaneousResponse {
  VehicleMiscellaneousResponse({
      this.vehicles,});

  VehicleMiscellaneousResponse.fromJson(dynamic json) {

    vehicles = json['vehicles'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['vehicles'] ?? {})]
        : List<Map<String, dynamic>>.from(json['vehicles'] ?? []);


    // if (json['vehicles'] != null) {
    //   vehicles = [];
    //   json['vehicles'].forEach((v) {
    //     vehicles?.add(VehiclesMiscellaneous.fromJson(v));
    //   });
    // }
  }
  List<Map<String,dynamic>>? vehicles;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (vehicles != null) {
  //     map['vehicles'] = vehicles?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class VehiclesMiscellaneous {
//   VehiclesMiscellaneous({
//       this.id,
//       this.vehicleId,
//       this.vehicleName,
//       this.vin,
//       this.make,
//       this.model,
//       this.year,
//       this.vehicleNumber,
//       this.cohortId,
//       this.earnings,
//       this.utilizationRate,
//       this.vehicleStatus,
//       this.active,
//       this.platform,
//       this.platformFrom,
//       this.mileage,
//       this.wholesaleAmount,
//       this.rowOrder,
//       this.note,
//       this.purchaseDate,
//       this.purchasePrice,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   VehiclesMiscellaneous.fromJson(dynamic json) {
//     id = json['id'];
//     vehicleId = json['vehicle_id'];
//     vehicleName = json['vehicle_name'];
//     vin = json['vin'];
//     make = json['make'];
//     model = json['model'];
//     year = json['year'];
//     vehicleNumber = json['vehicle_number'];
//     cohortId = json['cohort_id'];
//     earnings = json['earnings'];
//     utilizationRate = json['utilization_rate'];
//     vehicleStatus = json['vehicle_status'];
//     active = json['active'];
//     platform = json['platform'];
//     platformFrom = json['platform_from'];
//     mileage = json['mileage'];
//     wholesaleAmount = json['wholesale_amount'];
//     rowOrder = json['row_order'];
//     note = json['note'];
//     purchaseDate = json['purchase_date'];
//     purchasePrice = json['purchase_price'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   int? vehicleId;
//   String? vehicleName;
//   String? vin;
//   String? make;
//   String? model;
//   String? year;
//   dynamic vehicleNumber;
//   int? cohortId;
//   int? earnings;
//   int? utilizationRate;
//   int? vehicleStatus;
//   int? active;
//   dynamic platform;
//   dynamic platformFrom;
//   dynamic mileage;
//   dynamic wholesaleAmount;
//   int? rowOrder;
//   dynamic note;
//   String? purchaseDate;
//   dynamic purchasePrice;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['vehicle_id'] = vehicleId;
//     map['vehicle_name'] = vehicleName;
//     map['vin'] = vin;
//     map['make'] = make;
//     map['model'] = model;
//     map['year'] = year;
//     map['vehicle_number'] = vehicleNumber;
//       map['vehicle_number'] = vehicleNumber;
//     map['cohort_id'] = cohortId;
//     map['earnings'] = earnings;
//     map['utilization_rate'] = utilizationRate;
//     map['vehicle_status'] = vehicleStatus;
//     map['active'] = active;
//     map['platform'] = platform;
//     map['platform_from'] = platformFrom;
//     map['mileage'] = mileage;
//     map['wholesale_amount'] = wholesaleAmount;
//     map['row_order'] = rowOrder;
//     map['note'] = note;
//     map['purchase_date'] = purchaseDate;
//     map['purchase_price'] = purchasePrice;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }