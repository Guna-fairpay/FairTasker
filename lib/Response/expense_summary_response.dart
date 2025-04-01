class ExpenseSummaryResponse {
  ExpenseSummaryResponse({
    this.data,
    this.status,
    this.message,
  });

  ExpenseSummaryResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}

// class ExpenseSummaryData {
//   ExpenseSummaryData({
//       this.id,
//       this.expenseDate,
//       // this.vehicleId,
//       this.vin,
//       this.cohortId,
//       this.subcategoryId,
//       this.categoryName,
//       this.subCategoryName,
//     this.categoryId,
//       this.expenseAmount,
//       this.expenseDescription,
//       // this.majorRepair,
//       // this.expenseTo
//       // this.partsId,
//       // this.checklistId,
//       // this.platform,
//       // this.deletedAt,
//       // this.createdAt,
//       // this.updatedAt,
//       this.attachments,
//   });
//
//   ExpenseSummaryData.fromJson(dynamic json) {
//     id = json['id'];
//     expenseDate = json['expense_date'];
//     // vehicleId = json['vehicle_id'];
//     vin = json['vin'];
//     cohortId = json['cohort_id'];
//     subcategoryId = json['subcategory_id'];
//     categoryId = json['category_id'];
//     if (json['expense_amount'] != null) {
//       if (json['expense_amount'] is int) {
//         expenseAmount = json['expense_amount'] as int;
//       } else if (json['expense_amount'] is String) {
//         expenseAmount = int.tryParse(json['expense_amount']);
//       }
//     }
//     expenseDescription = json['expense_description'];
//     categoryName = '';
//     subCategoryName = '';
//     // majorRepair = json['major_repair'];
//     // expenseTo = json['expense_to'];
//     // partsId = json['parts_id'];
//     // checklistId = json['checklist_id'];
//     // platform = json['platform'];
//     // deletedAt = json['deleted_at'];
//     // createdAt = json['created_at'];
//     // updatedAt = json['updated_at'];
//     categoryName = '';
//     subCategoryName = '';
//     if (json['attachments'] != null) {
//       attachments = [];
//       json['attachments'].forEach((v) {
//         attachments?.add(Attachments.fromJson(v));
//       });
//     }
//   }
//   int? id;
//   String? expenseDate;
//   // dynamic vehicleId;
//   String? vin;
//   int? cohortId;
//   int? subcategoryId;
//   int? categoryId;
//   String? categoryName;
//   String? subCategoryName;
//   int? expenseAmount;
//   String? expenseDescription;
//   // int? majorRepair;
//   // int? expenseTo;
//   // dynamic partsId;
//   // dynamic checklistId;
//   // dynamic platform;
//   // dynamic deletedAt;
//   // String? createdAt;
//   // String? updatedAt;
//   List<Attachments>? attachments;
// }
//
// class Attachments {
//   Attachments({
//       this.id,
//       this.expenseId,
//       this.name,
//       this.path,
//       this.file,
//       // this.fileType,
//       // this.deletedAt,
//       // this.createdAt,
//       // this.updatedAt,
//   });
//
//   Attachments.fromJson(dynamic json) {
//     id = json['id'];
//     expenseId = json['expense_id'];
//     name = json['name'];
//     path = json['path'];
//     // fileType = json['file_type'];
//     // deletedAt = json['deleted_at'];
//     // createdAt = json['created_at'];
//     // updatedAt = json['updated_at'];
//   }
//   int? id;
//   int? expenseId;
//   String? name;
//   String? path;
//   File? file;
//   // String? fileType;
//   // String? deletedAt;
//   // String? createdAt;
//   // String? updatedAt;
// }
