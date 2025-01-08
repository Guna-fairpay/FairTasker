class VehicleGroupingResponse {
  VehicleGroupingResponse({
      this.status, 
      this.message, 
      this.vehicleGroupData,});

  VehicleGroupingResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    vehicleGroupData = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  int? status;
  String? message;
  List<Map<String,dynamic>>? vehicleGroupData;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   map['message'] = message;
  //   if (vehicleGroupData != null) {
  //     map['data'] = vehicleGroupData?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}

// class VehicleGroupData {
//   VehicleGroupData({
//       this.id,
//       this.name,
//       this.vin,
//       this.isSelected,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   VehicleGroupData.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     vin = json['vin'];
//     isSelected = false;
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? name;
//
//   String? vin;
//   bool? isSelected = false;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['vin'] = vin;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }