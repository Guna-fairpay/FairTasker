class SubCategoriesResponse {
  SubCategoriesResponse({
    this.data,
    this.expenseTo,
    this.status,
    this.message,});

  SubCategoriesResponse.fromJson(dynamic json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);

    expenseTo = json['expenseTo'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['expenseTo'] ?? {})]
        : List<Map<String, dynamic>>.from(json['expenseTo'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }
  List<Map<String,dynamic>>? data;
  List<Map<String,dynamic>>? expenseTo;
  int? status;
  String? message;

  /*Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (expenseTo != null) {
      map['expenseTo'] = expenseTo?.map((v) => v.toJson()).toList();
    }
    return map;
  }*/

}

/*
class ExpenseTo {
  ExpenseTo({
      this.id, 
      this.cohortId, 
      this.expenseTo, 
      this.status, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  ExpenseTo.fromJson(dynamic json) {
    id = json['id'];
    cohortId = json['cohort_id'];
    expenseTo = json['expense_to'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? cohortId;
  String? expenseTo;
  int? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cohort_id'] = cohortId;
    map['expense_to'] = expenseTo;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class CategorySubData {
  CategorySubData({
      this.id, 
      this.name, 
      this.parentId, 
      this.expenseTo, 
      this.cohortId, 
      this.platform, 
      this.isGenerated, 
      this.createdBy, 
      this.updatedBy, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.subcategories, 
      this.subcategoriesCount,});

  CategorySubData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    expenseTo = json['expense_to'];
    cohortId = json['cohort_id'];
    platform = json['platform'];
    isGenerated = json['is_generated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['subcategories'] != null) {
      subcategories = [];
      json['subcategories'].forEach((v) {
        subcategories?.add(Subcategories.fromJson(v));
      });
    }
    subcategoriesCount = json['subcategories_count'];
  }
  int? id;
  String? name;
  dynamic parentId;
  dynamic expenseTo;
  dynamic cohortId;
  dynamic platform;
  int? isGenerated;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  List<Subcategories>? subcategories;
  int? subcategoriesCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['parent_id'] = parentId;
    map['expense_to'] = expenseTo;
    map['cohort_id'] = cohortId;
    map['platform'] = platform;
    map['is_generated'] = isGenerated;
    map['created_by'] = createdBy;
    map['updated_by'] = updatedBy;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (subcategories != null) {
      map['subcategories'] = subcategories?.map((v) => v.toJson()).toList();
    }
    map['subcategories_count'] = subcategoriesCount;
    return map;
  }

}

class Subcategories {
  Subcategories({
      this.id, 
      this.name, 
      this.parentId, 
      this.expenseTo, 
      this.cohortId, 
      this.platform, 
      this.isGenerated, 
      this.createdBy, 
      this.updatedBy, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.expenseToData,});

  Subcategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    expenseTo = json['expense_to'];
    cohortId = json['cohort_id'];
    platform = json['platform'];
    isGenerated = json['is_generated'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expenseToData = json['expense_to_data'] != null ? ExpenseToData.fromJson(json['expense_to_data']) : null;
  }
  int? id;
  String? name;
  int? parentId;
  int? expenseTo;
  dynamic cohortId;
  dynamic platform;
  int? isGenerated;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  ExpenseToData? expenseToData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['parent_id'] = parentId;
    map['expense_to'] = expenseTo;
    map['cohort_id'] = cohortId;
    map['platform'] = platform;
    map['is_generated'] = isGenerated;
    map['created_by'] = createdBy;
    map['updated_by'] = updatedBy;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (expenseToData != null) {
      map['expense_to_data'] = expenseToData?.toJson();
    }
    return map;
  }

}

class ExpenseToData {
  ExpenseToData({
      this.id, 
      this.cohortId, 
      this.expenseTo, 
      this.status, 
      this.deletedAt, 
      this.createdAt, 
      this.updatedAt,});

  ExpenseToData.fromJson(dynamic json) {
    id = json['id'];
    cohortId = json['cohort_id'];
    expenseTo = json['expense_to'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? cohortId;
  String? expenseTo;
  int? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cohort_id'] = cohortId;
    map['expense_to'] = expenseTo;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}*/
