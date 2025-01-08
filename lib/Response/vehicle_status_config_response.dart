class VehicleStatusConfigResponse {
  VehicleStatusConfigResponse({
      this.vehicle, 
      this.categories,});

  VehicleStatusConfigResponse.fromJson(dynamic json) {

    vehicle = json['vehicle'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['vehicle'] ?? {})]
        : List<Map<String, dynamic>>.from(json['vehicle'] ?? []);

    categories = json['categories'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['categories'] ?? {})]
        : List<Map<String, dynamic>>.from(json['categories'] ?? []);

    // vehicle = json['vehicle'] != null ? VehicleConfigData.fromJson(json['vehicle']) : null;
    // if (json['categories'] != null) {
    //   categories = [];
    //   json['categories'].forEach((v) {
    //     categories?.add(VehicleConfigCategories.fromJson(v));
    //   });
    // }
  }
  List<Map<String, dynamic>>? vehicle;
  List<Map<String, dynamic>>? categories;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (vehicle != null) {
  //     map['vehicle'] = vehicle?.toJson();
  //   }
  //   if (categories != null) {
  //     map['categories'] = categories?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class VehicleConfigCategories {
//   VehicleConfigCategories({
//       this.id,
//       this.categoryName,
//       this.orderNo,
//       this.status,
//       this.statusPercentage,
//       this.isStatus,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.checklists,
//       this.checked,
//       this.vehicleConfigCount,
//       this.vehicleStatusCount,
//       this.activeCategory,});
//
//   VehicleConfigCategories.fromJson(dynamic json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     orderNo = json['order_no'];
//     status = json['status'];
//     statusPercentage = json['status_percentage'];
//     isStatus = json['isStatus'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['checklists'] != null) {
//       checklists = [];
//       json['checklists'].forEach((v) {
//         checklists?.add(Checklists.fromJson(v));
//       });
//     }
//     checked = json['checked'];
//     vehicleConfigCount = json['vehicle_config_count'];
//     vehicleStatusCount = json['vehicle_status_count'];
//     activeCategory = json['activeCategory'];
//   }
//   int? id;
//   String? categoryName;
//   dynamic orderNo;
//   int? status;
//   int? statusPercentage;
//   int? isStatus;
//   dynamic deletedAt;
//   dynamic createdAt;
//   dynamic updatedAt;
//   List<Checklists>? checklists;
//   int? checked;
//   int? vehicleConfigCount;
//   int? vehicleStatusCount;
//   int? activeCategory;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['category_name'] = categoryName;
//     map['order_no'] = orderNo;
//     map['status'] = status;
//     map['status_percentage'] = statusPercentage;
//     map['isStatus'] = isStatus;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     if (checklists != null) {
//       map['checklists'] = checklists?.map((v) => v.toJson()).toList();
//     }
//     map['checked'] = checked;
//     map['vehicle_config_count'] = vehicleConfigCount;
//     map['vehicle_status_count'] = vehicleStatusCount;
//     map['activeCategory'] = activeCategory;
//     return map;
//   }
//
// }
//
// class Checklists {
//   Checklists({
//       this.id,
//       this.categoryId,
//       this.orderNo,
//       this.label,
//       this.checklist,
//       this.type,
//       this.status,
//       this.task,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.checklistOrder,
//       this.checked,
//       this.configId,
//       this.checklistId,});
//
//   Checklists.fromJson(dynamic json) {
//     id = json['id'];
//     categoryId = json['category_id'];
//     orderNo = json['order_no'];
//     label = json['label'];
//     checklist = json['checklist'];
//     type = json['type'];
//     status = json['status'];
//     task = json['task'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     checklistOrder = json['checklist_order'];
//     checked = json['checked'];
//     configId = json['config_id'];
//     checklistId = json['checklist_id'];
//   }
//   int? id;
//   int? categoryId;
//   int? orderNo;
//   String? label;
//   String? checklist;
//   int? type;
//   int? status;
//   dynamic task;
//   dynamic deletedAt;
//   dynamic createdAt;
//   dynamic updatedAt;
//   int? checklistOrder;
//   int? checklistId;
//   int? checked;
//   int? configId;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['category_id'] = categoryId;
//     map['order_no'] = orderNo;
//     map['label'] = label;
//     map['checklist'] = checklist;
//     map['type'] = type;
//     map['status'] = status;
//     map['task'] = task;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['checklist_order'] = checklistOrder;
//     map['checked'] = checked;
//     map['config_id'] = configId;
//     return map;
//   }
//
// }
//
// class VehicleConfigData {
//   VehicleConfigData({
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
//   VehicleConfigData.fromJson(dynamic json) {
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
//   String? vehicleNumber;
//   int? cohortId;
//   dynamic earnings;
//   int? utilizationRate;
//   int? vehicleStatus;
//   int? active;
//   String? platform;
//   dynamic platformFrom;
//   dynamic mileage;
//   dynamic wholesaleAmount;
//   int? rowOrder;
//   dynamic note;
//   String? purchaseDate;
//   int? purchasePrice;
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