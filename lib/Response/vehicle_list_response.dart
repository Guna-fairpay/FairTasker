class VehicleListResponse {
  VehicleListResponse({
    this.data,
    this.status,
    this.message,
  });

  VehicleListResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

  /*Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }*/
}
/*
class VehiclesData {
  VehiclesData({
      this.id, 
      this.vehicleId, 
      this.vehicleName, 
       this.vehicleNumber,
      this.vin, 
      this.make, 
      this.model, 
      this.year, 
      this.cohortId, 
      this.earnings, 
      this.utilizationRate, 
      this.vehicleStatus, 
      this.active, 
      this.platform, 
      this.platformFrom, 
      this.mileage, 
      this.wholesaleAmount, 
      this.rowOrder, 
      this.note, 
      this.purchaseDate,
      this.purchasePrice,
      // this.deletedAt,
      this.createdAt, 
      this.updatedAt, 
      this.images, 
      this.cohort,
      this.isSelected,
      this.isMultipleVehSelected,
      this.expenseSummaryData,
      // this.isLoader
  });

  VehiclesData.fromJson(dynamic json) {



  // debugPrint('json[id]1: ${json['vehicle_number']}');
    id = json['id'];
    // debugPrint('json[id]2: ${json['vehicle_id']}');
    vehicleId = json['vehicle_id'];
    //debugPrint('json[id]3: ${json['vehicle_name']}');
    vehicleName = json['vehicle_name'];
     vehicleNumber= json['vehicle_number'];
    //debugPrint('json[id]4: ${json['vin']}');
    vin = json['vin'];
    //debugPrint('json[id]5: ${json['make']}');
    make = json['make'];
    //debugPrint('json[id]6: ${json['model']}');
    model = json['model'];
    //debugPrint('json[id]7: ${json['year']}');
    year = json['year'];
    //debugPrint('json[id]8: ${json['cohort_id']}');
    cohortId = json['cohort_id'];
    //debugPrint('json[id]0: ${json['earnings']}');
    earnings = json['earnings'];
    //debugPrint('json[id]11: ${json['utilization_rate']}');
    utilizationRate = json['utilization_rate'];
    //debugPrint('json[id]12: ${json['vehicle_status']}');
    vehicleStatus = json['vehicle_status'];
    //debugPrint('json[id]13: ${json['active']}');
    active = json['active'];
    //debugPrint('json[id]14: ${json['platform']}');
    platform = json['platform'];
    //debugPrint('json[id]15: ${json['platform_from']}');
    platformFrom = json['platform_from'];
    //debugPrint('json[id]16: ${json['mileage']}');
    mileage = json['mileage'];
    //debugPrint('json[id]17: ${json['wholesale_amount']}');
    wholesaleAmount = json['wholesale_amount'];
    //debugPrint('json[id]18: ${json['row_order']}');
    rowOrder = json['row_order'];
    //debugPrint('json[id]20: ${json['note']}');
    note = json['note'];
    //debugPrint('json[id]21: ${json['purchase_date']}');
    purchaseDate = json['purchase_date'];
    //debugPrint('json[id]22: ${json['purchase_price']}');
    purchasePrice = json['purchase_price'];
    //debugPrint('json[id]23: ${json['id']}');
    isSelected = false;
    //debugPrint('json[id]24: ${json['created_at']}');
    // deletedAt = json['deleted_at'];

   
    createdAt = json['created_at'];
    //debugPrint('json[id]25: ${json['updated_at']}');
    updatedAt = json['updated_at'];
    isMultipleVehSelected = false;
    //debugPrint('json[id]26: ${json['expenses']}');
    expenseSummaryData = json['expenses'] != null ? ExpenseSummaryData.fromJson(json['expenses']) : null;
    //debugPrint('json[id]27: ${json['images']}');
    if (json['images'] != null) {
      images = [];
      //debugPrint('json[id]28: ${json['images']}');
      json['images'].forEach((v) {
        images?.add(VehiclesImages.fromJson(v));
      });
    }
    //debugPrint('json[id]30: ${json['cohort']}');
    cohort = json['cohort'] != null ? VehiclesCohort.fromJson(json['cohort']) : null;
  }
  dynamic id;
  dynamic vehicleId;
  String? vehicleName;
  String? vehicleNumber;
  String? vin;
  String? make;
  String? model;
  String? year;
  dynamic cohortId;
  dynamic earnings;
  dynamic utilizationRate;
  dynamic vehicleStatus;
  dynamic active;
  String? platform;
  String? platformFrom;
  dynamic mileage;
  dynamic wholesaleAmount;
  dynamic rowOrder;
  String? note;
  String? purchaseDate;
  dynamic purchasePrice;
  // dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  List<VehiclesImages>? images;
  VehiclesCohort? cohort;
  bool? isSelected = false;
  bool? isMultipleVehSelected = false;
  dynamic deleteId;
  dynamic vehicleGroupId;
  String? vehicleGroupName;
  ExpenseSummaryData? expenseSummaryData;
 


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vehicle_id'] = vehicleId;
    map['vehicle_name'] = vehicleName;
      map['vehicle_number'] = vehicleNumber;
    map['vin'] = vin;
    map['make'] = make;
    map['model'] = model;
    map['year'] = year;
    map['cohort_id'] = cohortId;
    map['earnings'] = earnings;
    map['utilization_rate'] = utilizationRate;
    map['vehicle_status'] = vehicleStatus;
    map['active'] = active;
    map['platform'] = platform;
    map['platform_from'] = platformFrom;
    map['mileage'] = mileage;
    map['wholesale_amount'] = wholesaleAmount;
    map['row_order'] = rowOrder;
    map['note'] = note;
    map['purchase_date'] = purchaseDate;
    map['purchase_price'] = purchasePrice;
    // map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    if (cohort != null) {
      map['cohort'] = cohort?.toJson();
    }
 

    return map;
  }

}

class VehiclesCohort {
  VehiclesCohort({
      this.id, 
      this.vehicleId, 
      this.cohort, 
      // this.startDate,
      // this.endDate,
      this.description, 
      this.active, 
      // this.createdBy,
      // this.updatedBy,
      // this.deletedAt,
      this.createdAt, 
      this.updatedAt,});

  VehiclesCohort.fromJson(dynamic json) {
    //debugPrint('json[id]1: ${json['id']}');

    id = json['id'];
    vehicleId = json['vehicle_id'];
    cohort = json['cohort'];
    // startDate = json['start_date'];
    // endDate = json['end_date'];
    description = json['description'];
    active = json['active'];
    // createdBy = json['created_by'];
    // updatedBy = json['updated_by'];
    // deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  dynamic id;
  dynamic vehicleId;
  String? cohort;
  // dynamic startDate;
  // dynamic endDate;
  String? description;
  dynamic active;
  // dynamic createdBy;
  // dynamic updatedBy;
  // dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vehicle_id'] = vehicleId;
    map['cohort'] = cohort;
    // map['start_date'] = startDate;
    // map['end_date'] = endDate;
    map['description'] = description;
    map['active'] = active;
    // map['created_by'] = createdBy;
    // map['updated_by'] = updatedBy;
    // map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class VehiclesImages {
  VehiclesImages({
      this.id, 
      this.vin, 
      this.name, 
      this.path, 
      this.file,
      // this.deletedAt,
      this.createdAt, 
      this.updatedAt,});

  VehiclesImages.fromJson(dynamic json) {
    //debugPrint('json[id]2: ${json['id']}');
    id = json['id'];
    vin = json['vin'];
    name = json['name'];
    path = json['path'];
    // file = File('');
    // deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  dynamic id;
  String? vin;
  String? name;
  String? path;
  File? file;
  // dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vin'] = vin;
    map['name'] = name;
    map['file'] = file;
    map['path'] = path;
    // map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
class VehicleStatusDatas{
  VehicleStatusDatas({
    this.id,
    this.category_Id,
    this.status,
    this.label,

  });
  VehicleStatusDatas.fromJson(dynamic json){
    id=json['id'];
    category_Id=json['category_Id'];
    status=json['status'];
    label=json['lable'];

  }
  dynamic id;
  String? category_Id;
  String? status;
  String? label;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['vin'] = category_Id;
    map['name'] = status;
    map['file'] = label;
    return map;
  }
}
*//*class ExpenseSummaryData {
  ExpenseSummaryData({
    // this.id,
    this.expenseDate,
    // this.vehicleId,
    // this.vin,
    // this.cohortId,
    // this.subcategoryId,
    // this.categoryId,
    this.expenseAmount,
    this.expenseDescription,
    // this.majorRepair,
    // this.expenseTo
    // this.partsId,
    // this.checklistId,
    // this.platform,
    // this.deletedAt,
    // this.createdAt,
    // this.updatedAt,
    this.attachments,
  });

  ExpenseSummaryData.fromJson(dynamic json) {
    // id = json['id'];
    expenseDate = json['expense_date'];
    // vehicleId = json['vehicle_id'];
    // vin = json['vin'];
    // cohortId = json['cohort_id'];
    // subcategoryId = json['subcategory_id'];
    // categoryId = json['category_id'];
    if (json['expense_amount'] != null) {
      if (json['expense_amount'] is int) {
        expenseAmount = json['expense_amount'] as int;
      } else if (json['expense_amount'] is String) {
        expenseAmount = int.tryParse(json['expense_amount']);
      }
    }
    expenseDescription = json['expense_description'];
    // majorRepair = json['major_repair'];
    // expenseTo = json['expense_to'];
    // partsId = json['parts_id'];
    // checklistId = json['checklist_id'];
    // platform = json['platform'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(Attachments.fromJson(v));
      });
    }
  }
  // int? id;
  String? expenseDate;
  // dynamic vehicleId;
  // String? vin;
  // int? cohortId;
  // int? subcategoryId;
  // int? categoryId;
  int? expenseAmount;
  String? expenseDescription;
  // int? majorRepair;
  // int? expenseTo;
  // dynamic partsId;
  // dynamic checklistId;
  // dynamic platform;
  // dynamic deletedAt;
  // String? createdAt;
  // String? updatedAt;
  List<Attachments>? attachments;
}

class Attachments {
  Attachments({
    this.id,
    this.expenseId,
    // this.name,
    this.path,
    // this.fileType,
    // this.deletedAt,
    // this.createdAt,
    // this.updatedAt,
  });

  Attachments.fromJson(dynamic json) {
    id = json['id'];
    expenseId = json['expense_id'];
    // name = json['name'];
    path = json['path'];
    // fileType = json['file_type'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }
  int? id;
  int? expenseId;
  // String? name;
  String? path;
// String? fileType;
// String? deletedAt;
// String? createdAt;
// String? updatedAt;
}*/
