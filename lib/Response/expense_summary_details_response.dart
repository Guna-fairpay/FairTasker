class ExpenseSummaryDetailResponse {
  ExpenseSummaryDetailResponse({
    this.message,
    this.expenses,
  });

  ExpenseSummaryDetailResponse.fromJson(dynamic json) {
    // message = json['message'];
    expenses = json['expenses'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['expenses'] ?? {})]
        : List<Map<String, dynamic>>.from(json['expenses'] ?? []);
    message = json['message'] ?? "";
    // expenses = json['expenses'] != null ? ExpensesData.fromJson(json['expenses']) : null;
  }
  String? message;
  List<Map<String, dynamic>>? expenses;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['message'] = message;
  //   if (expenses != null) {
  //     map['expenses'] = expenses?.toJson();
  //   }
  //   return map;
  // }
}

/*
class ExpensesData {
  ExpensesData({
      this.id, 
      this.expenseDate, 
      this.vehicleId, 
      this.vin, 
      this.cohortId, 
      this.subcategoryId, 
      this.categoryId, 
      this.expenseAmount, 
      this.expenseDescription, 
      this.majorRepair, 
      this.expenseTo, 
      this.partsId, 
      this.checklistId, 
      this.platform, 
      this.odometer,
    this.categoryName,
    this.subCategoryName,
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.attachments,});

  ExpensesData.fromJson(dynamic json) {
    id = json['id'];
    expenseDate = json['expense_date'];
    vehicleId = json['vehicle_id'];
    vin = json['vin'];
    cohortId = json['cohort_id'];
    subcategoryId = json['subcategory_id'];
    categoryId = json['category_id'];
    expenseAmount = json['expense_amount'];
    expenseDescription = json['expense_description'];
    majorRepair = json['major_repair'];
    expenseTo = json['expense_to'];
    partsId = json['parts_id'];
    checklistId = json['checklist_id'];
    platform = json['platform'];
    odometer = json['odometer'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(Attachments.fromJson(v));
      });
    }
  }
  int? id;
  String? expenseDate;
  int? vehicleId;
  String? vin;
  int? cohortId;
  int? subcategoryId;
  int? categoryId;
  int? expenseAmount;
  String? expenseDescription;
  dynamic majorRepair;
  int? expenseTo;
  dynamic partsId;
  dynamic checklistId;
  String? platform;
  dynamic odometer;
  dynamic deletedAt;
  String? createdAt;
  String? categoryName;
  String? subCategoryName;
  String? updatedAt;
  List<Attachments>? attachments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['expense_date'] = expenseDate;
    map['vehicle_id'] = vehicleId;
    map['vin'] = vin;
    map['cohort_id'] = cohortId;
    map['subcategory_id'] = subcategoryId;
    map['category_id'] = categoryId;
    map['expense_amount'] = expenseAmount;
    map['expense_description'] = expenseDescription;
    map['major_repair'] = majorRepair;
    map['expense_to'] = expenseTo;
    map['parts_id'] = partsId;
    map['checklist_id'] = checklistId;
    map['platform'] = platform;
    map['odometer'] = odometer;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;

    return map;
  }

}*/
