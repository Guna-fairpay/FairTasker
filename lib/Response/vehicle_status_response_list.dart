class VehicleStatusResponseList {
  VehicleStatusResponseList({
    this.data,
    this.vehiclesCount,
  });

  VehicleStatusResponseList.fromJson(dynamic json) {
    // if (json['data'] != null) {
    //   data = [];
    //   json['data'].forEach((v) {
    //     data?.add(VehicleStatusListData.fromJson(v));
    //   });
    // }
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    vehiclesCount = json['vehiclesCount'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['vehiclesCount'] ?? {})]
        : List<Map<String, dynamic>>.from(json['vehiclesCount'] ?? []);

  }
  List<Map<String,dynamic>>? data;
  List<Map<String,dynamic>>? vehiclesCount;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class VehicleStatusListData {
//   VehicleStatusListData({
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
//       this.updatedAt,
//       this.isConfig,
//       this.vehicleStatusText,
//       this.cohort,
//       this.vehicleStatusValue,
//       this.images,
//       this.countDays,
//       this.lastChecklist,
//       this.checklistCategory,
//       this.categoryId,
//       this.cumulativeCost,
//       this.nextCategoryId,
//       this.nextCategoryName,
//       this.configCount,
//       this.vehicleStatusCount,
//       this.details,
//   this.count});
//
//   VehicleStatusListData.fromJson(dynamic json) {
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
//     isConfig = json['isConfig'];
//     vehicleStatusText = json['vehicle_status_text'];
//     cohort = json['cohort'];
//     vehicleStatusValue = json['vehicle_status_value'];
//     if (json['images'] != null) {
//       images = [];
//       json['images'].forEach((v) {
//         images?.add(Images.fromJson(v));
//       });
//     }
//     countDays = json['count_days'];
//     lastChecklist = json['last_checklist'];
//     checklistCategory = json['checklist_category'];
//     categoryId = json['category_id'];
//     cumulativeCost = json['cumulative_cost'];
//     nextCategoryId = json['nextCategory_id'];
//     nextCategoryName = json['nextCategory_name'];
//     configCount = json['configCount'];
//     vehicleStatusCount = json['vehicleStatusCount'];
//     details = json['details'] != null ? Details.fromJson(json['details']) : null;
//   }
//   dynamic id;
//   int? vehicleId;
//   String? vehicleName;
//   String? vin;
//   String? make;
//   String? model;
//   String? year;
//   dynamic vehicleNumber;
//   dynamic cohortId;
//   dynamic earnings;
//   dynamic utilizationRate;
//   dynamic vehicleStatus;
//   dynamic active;
//   String? platform;
//   dynamic platformFrom;
//   dynamic mileage;
//   dynamic wholesaleAmount;
//   dynamic rowOrder;
//   dynamic note;
//   String? purchaseDate;
//   dynamic purchasePrice;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   dynamic isConfig;
//   String? vehicleStatusText;
//   String? cohort;
//   dynamic vehicleStatusValue;
//   List<Images>? images;
//   String? countDays;
//   String? lastChecklist;
//   String? checklistCategory;
//   dynamic categoryId;
//   String? cumulativeCost;
//   dynamic nextCategoryId;
//   String? nextCategoryName;
//   dynamic configCount;
//   dynamic vehicleStatusCount;
//   Details? details;
//   int? count = 0;
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
//     map['isConfig'] = isConfig;
//     map['vehicle_status_text'] = vehicleStatusText;
//     map['cohort'] = cohort;
//     map['vehicle_status_value'] = vehicleStatusValue;
//     if (images != null) {
//       map['images'] = images?.map((v) => v.toJson()).toList();
//     }
//     map['count_days'] = countDays;
//     map['last_checklist'] = lastChecklist;
//     map['checklist_category'] = checklistCategory;
//     map['category_id'] = categoryId;
//     map['cumulative_cost'] = cumulativeCost;
//     map['nextCategory_id'] = nextCategoryId;
//     map['nextCategory_name'] = nextCategoryName;
//     map['configCount'] = configCount;
//     map['vehicleStatusCount'] = vehicleStatusCount;
//     if (details != null) {
//       map['details'] = details?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Details {
//   Details({
//       this.totalEarnings,
//       this.totalExpenses,
//       this.reservationCount,
//       this.totalSoldAmount,
//       this.soldDate,});
//
//   Details.fromJson(dynamic json) {
//     totalEarnings = json['totalEarnings'];
//     totalExpenses = json['totalExpenses'];
//     reservationCount = json['reservationCount'];
//     totalSoldAmount = json['totalSoldAmount'];
//     soldDate = json['soldDate'];
//   }
//   dynamic totalEarnings;
//   dynamic totalExpenses;
//   dynamic reservationCount;
//   dynamic totalSoldAmount;
//   dynamic soldDate;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['totalEarnings'] = totalEarnings;
//     map['totalExpenses'] = totalExpenses;
//     map['reservationCount'] = reservationCount;
//     map['totalSoldAmount'] = totalSoldAmount;
//     map['soldDate'] = soldDate;
//     return map;
//   }
//
// }
//
// class Images {
//   Images({
//       this.id,
//       this.vin,
//       this.name,
//       this.path,
//       this.imageType,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   Images.fromJson(dynamic json) {
//     id = json['id'];
//     vin = json['vin'];
//     name = json['name'];
//     path = json['path'];
//     imageType = json['image_type'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   dynamic id;
//   String? vin;
//   String? name;
//   String? path;
//   dynamic imageType;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['vin'] = vin;
//     map['name'] = name;
//     map['path'] = path;
//     map['image_type'] = imageType;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }