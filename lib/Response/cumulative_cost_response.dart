class CumulativeCostResponse {
  CumulativeCostResponse({
      this.data,});

  CumulativeCostResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String, dynamic>>? data;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (data != null) {
  //     map['data'] = data?.toJson();
  //   }
  //   return map;
  // }

}

// class CumulativeCostData {
//   CumulativeCostData({
//       this.expenses,
//       // this.vehicle,
//   });
//
//   CumulativeCostData.fromJson(dynamic json) {
//     if (json['expenses'] != null) {
//       expenses = [];
//       json['expenses'].forEach((v) {
//         expenses?.add(CumulativeCostExpenses.fromJson(v));
//       });
//     }
//     // vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
//   }
//   List<CumulativeCostExpenses>? expenses;
//   // Vehicle? vehicle;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (expenses != null) {
//       map['expenses'] = expenses?.map((v) => v.toJson()).toList();
//     }
//     /*if (vehicle != null) {
//       map['vehicle'] = vehicle?.toJson();
//     }*/
//     return map;
//   }
//
// }
//
// // class Vehicle {
// //   Vehicle({
// //       this.id,
// //       this.vehicleId,
// //       this.vehicleName,
// //       this.vin,
// //       this.make,
// //       this.model,
// //       this.year,
// //       this.vehicleNumber,
// //       this.cohortId,
// //       this.earnings,
// //       this.utilizationRate,
// //       this.vehicleStatus,
// //       this.active,
// //       this.platform,
// //       this.platformFrom,
// //       this.mileage,
// //       this.wholesaleAmount,
// //       this.rowOrder,
// //       this.note,
// //       this.purchaseDate,
// //       this.purchasePrice,
// //       this.deletedAt,
// //       this.createdAt,
// //       this.updatedAt,});
// //
// //   Vehicle.fromJson(dynamic json) {
// //     id = json['id'];
// //     vehicleId = json['vehicle_id'];
// //     vehicleName = json['vehicle_name'];
// //     vin = json['vin'];
// //     make = json['make'];
// //     model = json['model'];
// //     year = json['year'];
// //     vehicleNumber = json['vehicle_number'];
// //     cohortId = json['cohort_id'];
// //     earnings = json['earnings'];
// //     utilizationRate = json['utilization_rate'];
// //     vehicleStatus = json['vehicle_status'];
// //     active = json['active'];
// //     platform = json['platform'];
// //     platformFrom = json['platform_from'];
// //     mileage = json['mileage'];
// //     wholesaleAmount = json['wholesale_amount'];
// //     rowOrder = json['row_order'];
// //     note = json['note'];
// //     purchaseDate = json['purchase_date'];
// //     purchasePrice = json['purchase_price'];
// //     deletedAt = json['deleted_at'];
// //     createdAt = json['created_at'];
// //     updatedAt = json['updated_at'];
// //   }
// //   int? id;
// //   int? vehicleId;
// //   String? vehicleName;
// //   String? vin;
// //   String? make;
// //   String? model;
// //   String? year;
// //   String? vehicleNumber;
// //   int? cohortId;
// //   int? earnings;
// //   int? utilizationRate;
// //   int? vehicleStatus;
// //   int? active;
// //   String? platform;
// //   dynamic platformFrom;
// //   int? mileage;
// //   int? wholesaleAmount;
// //   int? rowOrder;
// //   dynamic note;
// //   String? purchaseDate;
// //   int? purchasePrice;
// //   dynamic deletedAt;
// //   String? createdAt;
// //   String? updatedAt;
// //
// //   Map<String, dynamic> toJson() {
// //     final map = <String, dynamic>{};
// //     map['id'] = id;
// //     map['vehicle_id'] = vehicleId;
// //     map['vehicle_name'] = vehicleName;
// //     map['vin'] = vin;
// //     map['make'] = make;
// //     map['model'] = model;
// //     map['year'] = year;
// //     map['vehicle_number'] = vehicleNumber;
// //     map['cohort_id'] = cohortId;
// //     map['earnings'] = earnings;
// //     map['utilization_rate'] = utilizationRate;
// //     map['vehicle_status'] = vehicleStatus;
// //     map['active'] = active;
// //     map['platform'] = platform;
// //     map['platform_from'] = platformFrom;
// //     map['mileage'] = mileage;
// //     map['wholesale_amount'] = wholesaleAmount;
// //     map['row_order'] = rowOrder;
// //     map['note'] = note;
// //     map['purchase_date'] = purchaseDate;
// //     map['purchase_price'] = purchasePrice;
// //     map['deleted_at'] = deletedAt;
// //     map['created_at'] = createdAt;
// //     map['updated_at'] = updatedAt;
// //     return map;
// //   }
// //
// // }
//
// class CumulativeCostExpenses {
//   CumulativeCostExpenses({
//       this.id,
//       this.expenseDate,
//       // this.vehicleId,
//       this.vin,
//       // this.cohortId,
//       // this.subcategoryId,
//       // this.categoryId,
//       this.expenseAmount,
//       this.expenseDescription,
//       // this.majorRepair,
//       // this.expenseTo,
//       // this.partsId,
//       // this.checklistId,
//       // this.platform,
//       // this.odometer,
//       // this.deletedAt,
//       // this.createdAt,
//       // this.updatedAt,
//       this.category,
//       this.subcategory,});
//
//   CumulativeCostExpenses.fromJson(dynamic json) {
//     id = json['id'];
//     expenseDate = json['expense_date'];
//     // vehicleId = json['vehicle_id'];
//     vin = json['vin'];
//     // cohortId = json['cohort_id'];
//     // subcategoryId = json['subcategory_id'];
//     // categoryId = json['category_id'];
//     expenseAmount = json['expense_amount'];
//     expenseDescription = json['expense_description'];
//     // majorRepair = json['major_repair'];
//     // expenseTo = json['expense_to'];
//     // partsId = json['parts_id'];
//     // checklistId = json['checklist_id'];
//     // platform = json['platform'];
//     // odometer = json['odometer'];
//     // deletedAt = json['deleted_at'];
//     // createdAt = json['created_at'];
//     // updatedAt = json['updated_at'];
//     category = json['category'] != null ? Category.fromJson(json['category']) : null;
//     subcategory = json['subcategory'] != null ? Subcategory.fromJson(json['subcategory']) : null;
//   }
//   int? id;
//   String? expenseDate;
//   // dynamic vehicleId;
//   String? vin;
//   // int? cohortId;
//   // int? subcategoryId;
//   // int? categoryId;
//   dynamic expenseAmount;
//   String? expenseDescription;
//   // int? majorRepair;
//   // int? expenseTo;
//   // dynamic partsId;
//   // dynamic checklistId;
//   // dynamic platform;
//   // dynamic odometer;
//   // dynamic deletedAt;
//   // String? createdAt;
//   // String? updatedAt;
//   Category? category;
//   Subcategory? subcategory;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['expense_date'] = expenseDate;
//     // map['vehicle_id'] = vehicleId;
//     map['vin'] = vin;
//     // map['cohort_id'] = cohortId;
//     // map['subcategory_id'] = subcategoryId;
//     // map['category_id'] = categoryId;
//     map['expense_amount'] = expenseAmount;
//     map['expense_description'] = expenseDescription;
//     // map['major_repair'] = majorRepair;
//     // map['expense_to'] = expenseTo;
//     // map['parts_id'] = partsId;
//     // map['checklist_id'] = checklistId;
//     // map['platform'] = platform;
//     // map['odometer'] = odometer;
//     // map['deleted_at'] = deletedAt;
//     // map['created_at'] = createdAt;
//     // map['updated_at'] = updatedAt;
//     if (category != null) {
//       map['category'] = category?.toJson();
//     }
//     if (subcategory != null) {
//       map['subcategory'] = subcategory?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Subcategory {
//   Subcategory({
//       this.id,
//       this.name,
//       // this.parentId,
//       // this.expenseTo,
//       // this.cohortId,
//       // this.platform,
//       // this.isGenerated,
//       // this.createdBy,
//       // this.updatedBy,
//       // this.deletedAt,
//       // this.createdAt,
//       // this.updatedAt
//   });
//
//   Subcategory.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     // parentId = json['parent_id'];
//     // expenseTo = json['expense_to'];
//     // cohortId = json['cohort_id'];
//     // platform = json['platform'];
//     // isGenerated = json['is_generated'];
//     // createdBy = json['created_by'];
//     // updatedBy = json['updated_by'];
//     // deletedAt = json['deleted_at'];
//     // createdAt = json['created_at'];
//     // updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? name;
//   // int? parentId;
//   // int? expenseTo;
//   // int? cohortId;
//   // dynamic platform;
//   // int? isGenerated;
//   // dynamic createdBy;
//   // dynamic updatedBy;
//   // dynamic deletedAt;
//   // String? createdAt;
//   // String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     // map['parent_id'] = parentId;
//     // map['expense_to'] = expenseTo;
//     // map['cohort_id'] = cohortId;
//     // map['platform'] = platform;
//     // map['is_generated'] = isGenerated;
//     // map['created_by'] = createdBy;
//     // map['updated_by'] = updatedBy;
//     // map['deleted_at'] = deletedAt;
//     // map['created_at'] = createdAt;
//     // map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }
//
// class Category {
//   Category({
//       this.id,
//       this.name,
//       // this.parentId,
//       // this.expenseTo,
//       // this.cohortId,
//       // this.platform,
//       // this.isGenerated,
//       // this.createdBy,
//       // this.updatedBy,
//       // this.deletedAt,
//       // this.createdAt,
//       // this.updatedAt,
//   });
//
//   Category.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     // parentId = json['parent_id'];
//     // expenseTo = json['expense_to'];
//     // cohortId = json['cohort_id'];
//     // platform = json['platform'];
//     // isGenerated = json['is_generated'];
//     // createdBy = json['created_by'];
//     // updatedBy = json['updated_by'];
//     // deletedAt = json['deleted_at'];
//     // createdAt = json['created_at'];
//     // updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? name;
//   // dynamic parentId;
//   // dynamic expenseTo;
//   // int? cohortId;
//   // dynamic platform;
//   // int? isGenerated;
//   // dynamic createdBy;
//   // dynamic updatedBy;
//   // dynamic deletedAt;
//   // String? createdAt;
//   // String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     // map['parent_id'] = parentId;
//     // map['expense_to'] = expenseTo;
//     // map['cohort_id'] = cohortId;
//     // map['platform'] = platform;
//     // map['is_generated'] = isGenerated;
//     // map['created_by'] = createdBy;
//     // map['updated_by'] = updatedBy;
//     // map['deleted_at'] = deletedAt;
//     // map['created_at'] = createdAt;
//     // map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }