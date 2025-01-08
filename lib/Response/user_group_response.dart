class UserGroupResponse {
  UserGroupResponse({
      this.status, 
      this.message, 
      this.data,});

  UserGroupResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  int? status;
  String? message;
  List<Map<String, dynamic>>? data;

}

// class UserGroupData {
//   UserGroupData({
//       this.id,
//       this.userId,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   UserGroupData.fromJson(dynamic json) {
//     id = json['id'];
//     userId = json['userId'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? userId;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['userId'] = userId;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }