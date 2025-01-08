
class JobListResponse {
  JobListResponse({
      this.status, 
      this.tasks,});

  JobListResponse.fromJson(dynamic json) {
    status = json['status'];
    tasks = json['tasks'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['tasks'] ?? {})]
        : List<Map<String, dynamic>>.from(json['tasks'] ?? []);
    // if (json['tasks'] != null) {
    //   tasks = [];
    //   json['tasks'].forEach((v) {
    //     tasks?.add(Tasks.fromJson(v));
    //   });
    // }
  }
  int? status;
  List<Map<String, dynamic>>? tasks;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   if (tasks != null) {
  //     map['tasks'] = tasks?.map((v) => v.toJson()).toList();
  //   }
  //   return map;
  // }

}
//
// class Tasks {
//   Tasks({
//     this.id,
//     this.taskType,
//     this.taskName,
//     this.description,
//     this.taskDate,
//     this.startTime,
//     this.endTime,
//     this.duration,
//     this.priority,
//     this.assignedTo,
//     this.assignedDate,
//     this.status,
//     this.track,
//     this.createdBy,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.users,
//     this.createBy,});
//
//   Tasks.fromJson(dynamic json) {
//     id = json['id'];
//     taskType = json['task_type'];
//     taskName = json['task_name'];
//     description = json['description'];
//     taskDate = json['task_date'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     duration = json['duration'];
//     priority = json['priority'];
//     assignedTo = json['assigned_to'];
//     assignedDate = json['assigned_date'];
//     status = json['status'];
//     track = json['track'];
//     createdBy = json['created_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     users = json['users'];
//     createBy = json['create_by'] != null ? CreateBy?.fromJson(json['create_by']) : null;
//   }
//   int? id;
//   dynamic taskType;
//   String? taskName;
//   String? description;
//   String? taskDate;
//   String? startTime;
//   String? endTime;
//   String? duration;
//   String? priority;
//   String? assignedTo;
//   String? assignedDate;
//   String? status;
//   String? track;
//   String? createdBy;
//   String? createdAt;
//   String? updatedAt;
//   dynamic deletedAt;
//   dynamic users;
//   CreateBy? createBy;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['task_type'] = taskType;
//     map['task_name'] = taskName;
//     map['description'] = description;
//     map['task_date'] = taskDate;
//     map['start_time'] = startTime;
//     map['end_time'] = endTime;
//     map['duration'] = duration;
//     map['priority'] = priority;
//     map['assigned_to'] = assignedTo;
//     map['assigned_date'] = assignedDate;
//     map['status'] = status;
//     map['track'] = track;
//     map['created_by'] = createdBy;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['deleted_at'] = deletedAt;
//     map['users'] = users;
//     if (createBy != null) {
//       map['create_by'] = createBy?.toJson();
//     }
//     return map;
//   }
// }
// class CreateBy {
//   CreateBy({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.phone,
//     this.email,
//     this.emailVerifiedAt,
//     this.department,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.departments,});
//
//   CreateBy.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     phone = json['phone'];
//     email = json['email'];
//     emailVerifiedAt = json['email_verified_at'];
//     department = json['department'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     departments = json['departments'];
//   }
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? phone;
//   String? email;
//   dynamic emailVerifiedAt;
//   dynamic department;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   dynamic departments;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['phone'] = phone;
//     map['email'] = email;
//     map['email_verified_at'] = emailVerifiedAt;
//     map['department'] = department;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['departments'] = departments;
//     return map;
//   }
//
// }