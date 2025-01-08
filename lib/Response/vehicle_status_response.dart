class VehicleStatusResponse {
  VehicleStatusResponse({
    this.data,
    this.status,
    this.message,});

  VehicleStatusResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class VehicleStatusData {
//   VehicleStatusData({
//       this.id,
//       this.categoryName,
//       this.orderNo,
//       this.status,
//       this.statusPercentage,
//       this.isStatus,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//   this.count});
//
//   VehicleStatusData.fromJson(dynamic json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     orderNo = json['order_no'];
//     status = json['status'];
//     statusPercentage = json['status_percentage'];
//     isStatus = json['isStatus'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     isSelected = false;
//   }
//   int? id;
//   String? categoryName;
//   bool? isSelected;
//   dynamic orderNo;
//   int? status;
//   int? count = 0;
//   int? statusPercentage;
//   int? isStatus;
//   dynamic deletedAt;
//   dynamic createdAt;
//   dynamic updatedAt;
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
//     return map;
//   }
//
// }