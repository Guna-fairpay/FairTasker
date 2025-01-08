class VehicleStatusChecklistResponse {
  VehicleStatusChecklistResponse({
      this.data,});

  VehicleStatusChecklistResponse.fromJson(dynamic json) {

    data = (json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []));
    categories = json['data']['categories'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data']['categories'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data']['categories'] ?? []);
    percentage = json['data']['percentage'];

   // data = json['data'] != null ? VehicleChecklistData.fromJson(json['data']) : null;
  }
  List<Map<String,dynamic>>? data;
  List<Map<String,dynamic>>? categories;
  dynamic percentage;
  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (data != null) {
  //     map['data'] = data?.toJson();
  //   }
  //   return map;
  // }

}

// class VehicleChecklistData {
//   VehicleChecklistData({
//       this.categories,
//       this.percentage,});
//
//   VehicleChecklistData.fromJson(dynamic json) {
//
//     categories = json['categories'] is Map<String, dynamic>
//         ? [Map<String, dynamic>.from(json['categories'] ?? {})]
//         : List<Map<String, dynamic>>.from(json['categories'] ?? []);
//     // if (json['categories'] != null) {
//     //   categories = [];
//     //   json['categories'].forEach((v) {
//     //     categories?.add(VehicleStatusChecklistCategories.fromJson(v));
//     //   });
//     // }
//     percentage = json['percentage'];
//   }
//   List<Map<String,dynamic>>? categories;
//   int? percentage;
//
//   // Map<String, dynamic> toJson() {
//   //   final map = <String, dynamic>{};
//   //   if (categories != null) {
//   //     map['categories'] = categories?.map((v) => v.toJson()).toList();
//   //   }
//   //   map['percentage'] = percentage;
//   //   return map;
//   // }
//
// }

// class VehicleStatusChecklistCategories {
//   VehicleStatusChecklistCategories({
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
//       this.checkCount,
//       this.checkAll,
//   this.isExpandable});
//
//   VehicleStatusChecklistCategories.fromJson(dynamic json) {
//     isExpandable = true;
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
//         checklists?.add(VehicleChecklists.fromJson(v));
//       });
//     }
//     checkCount = json['checkCount'];
//     checkAll = json['checkAll'];
//   }
//   bool? isExpandable = true;
//   int? id;
//   String? categoryName;
//   dynamic orderNo;
//   int? status;
//   int? statusPercentage;
//   int? isStatus;
//   dynamic deletedAt;
//   dynamic createdAt;
//   dynamic updatedAt;
//   List<VehicleChecklists>? checklists;
//   int? checkCount;
//   int? checkAll;
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
//     map['checkCount'] = checkCount;
//     map['checkAll'] = checkAll;
//     return map;
//   }
//
// }
//
// class VehicleChecklists {
//   VehicleChecklists({
//       this.id,
//       this.vin,
//       this.categoryId,
//       this.checklistId,
//       this.value,
//       this.orderNo,
//       this.categoryOrder,
//       this.platform,
//       this.createdBy,
//       this.updatedBy,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.checklistName,
//       this.taskName,
//       this.checked,
//       this.note,
//       this.vehicleStatusId,
//       this.expenseAmount,});
//
//   VehicleChecklists.fromJson(dynamic json) {
//     id = json['id'];
//     vin = json['vin'];
//     categoryId = json['category_id'];
//     checklistId = json['checklist_id'];
//     value = json['value'];
//     orderNo = json['order_no'];
//     categoryOrder = json['category_order'];
//     platform = json['platform'];
//     createdBy = json['created_by'];
//     updatedBy = json['updated_by'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     checklistName = json['checklist_name'];
//     taskName = json['task_name'];
//     checked = json['checked'];
//     note = json['note'];
//     vehicleStatusId = json['vehicle_status_id'];
//     expenseAmount = json['expense_amount'];
//   }
//   int? id;
//   String? vin;
//   int? categoryId;
//   int? checklistId;
//   int? value;
//   int? orderNo;
//   int? categoryOrder;
//   String? platform;
//   dynamic createdBy;
//   dynamic updatedBy;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   String? checklistName;
//   String? taskName;
//   int? checked;
//   dynamic note;
//   dynamic vehicleStatusId;
//   dynamic expenseAmount;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['vin'] = vin;
//     map['category_id'] = categoryId;
//     map['checklist_id'] = checklistId;
//     map['value'] = value;
//     map['order_no'] = orderNo;
//     map['category_order'] = categoryOrder;
//     map['platform'] = platform;
//     map['created_by'] = createdBy;
//     map['updated_by'] = updatedBy;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['checklist_name'] = checklistName;
//     map['task_name'] = taskName;
//     map['checked'] = checked;
//     map['note'] = note;
//     map['vehicle_status_id'] = vehicleStatusId;
//     map['expense_amount'] = expenseAmount;
//     return map;
//   }
//
// }