class WorkingHistoryCountResponse {
  WorkingHistoryCountResponse({
      this.status, 
      this.history,});

  WorkingHistoryCountResponse.fromJson(dynamic json) {
    status = json['status'];
    history = json['history'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['history'] ?? {})]
        : List<Map<String, dynamic>>.from(json['history'] ?? []);
  }
  int? status;
  List<Map<String, dynamic>>? history;


}

// class History {
//   History({
//       this.userId,
//       this.taskCount,
//       this.users,});
//
//   History.fromJson(dynamic json) {
//     userId = json['user_id'];
//     taskCount = json['task_count'];
//     users = json['users'] != null ? Users.fromJson(json['users']) : null;
//   }
//   String? userId;
//   int? taskCount;
//   Users? users;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['user_id'] = userId;
//     map['task_count'] = taskCount;
//     if (users != null) {
//       map['users'] = users?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Users {
//   Users({
//       this.id,
//       this.hrmId,
//       this.firstName,
//       this.lastName,
//       this.phone,
//       this.email,
//       this.emailVerifiedAt,
//       this.department,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.departments,});
//
//   Users.fromJson(dynamic json) {
//     id = json['id'];
//     hrmId = json['hrm_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     phone = json['phone'];
//     email = json['email'];
//     emailVerifiedAt = json['email_verified_at'];
//     department = json['department'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     departments = json['departments'] != null ? Departments.fromJson(json['departments']) : null;
//   }
//   int? id;
//   dynamic hrmId;
//   String? firstName;
//   String? lastName;
//   String? phone;
//   String? email;
//   dynamic emailVerifiedAt;
//   String? department;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   Departments? departments;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['hrm_id'] = hrmId;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['phone'] = phone;
//     map['email'] = email;
//     map['email_verified_at'] = emailVerifiedAt;
//     map['department'] = department;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     if (departments != null) {
//       map['departments'] = departments?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Departments {
//   Departments({
//       this.id,
//       this.name,
//       this.head,
//       this.createdAt,
//       this.updatedAt,});
//
//   Departments.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     head = json['head'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? name;
//   String? head;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['head'] = head;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }