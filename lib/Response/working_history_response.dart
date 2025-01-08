/// status : true
/// data : {"current_page":1,"data":[{"user":{"id":21,"employee_id":4,"name":"sample fy2","email":"samplefy2@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-10T22:32:58.000000Z","updated_at":"2024-01-10T22:32:58.000000Z","total_working_hours":"01:01:34","list":[{"date":"2024-02-08","total_hours":"00:49:53"},{"date":"2024-02-09","total_hours":"00:09:28"},{"date":"2024-02-10","total_hours":"00:00:00"},{"date":"2024-02-14","total_hours":"00:02:13"}]}},{"user":{"id":22,"employee_id":5,"name":"sample sample","email":"sample@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T02:57:07.000000Z","updated_at":"2024-01-25T02:57:07.000000Z","total_working_hours":"03:12:56","list":[{"date":"2024-02-08","total_hours":"03:12:56"}]}},{"user":{"id":23,"employee_id":6,"name":"test test","email":"test@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T03:07:28.000000Z","updated_at":"2024-01-25T03:07:28.000000Z","total_working_hours":"44:33:16","list":[{"date":"2024-02-08","total_hours":"44:33:16"}]}},{"user":{"id":28,"employee_id":11,"name":"sample 7","email":"sample7@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T06:32:55.000000Z","updated_at":"2024-01-25T06:32:55.000000Z","total_working_hours":"00:02:15","list":[{"date":"2024-02-08","total_hours":"00:02:15"}]}}],"first_page_url":"https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1","from":1,"last_page":1,"last_page_url":"https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://apiorgportal.fairreturns.in/api/employeeWorkHours","per_page":50,"prev_page_url":null,"to":4,"total":4}

class WorkingHistoryResponse {
  WorkingHistoryResponse({
      this.status, 
      this.data,});

  WorkingHistoryResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  bool? status;
  List<Map<String,dynamic>>? data;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   if (data != null) {
  //     map['data'] = data?.toJson();
  //   }
  //   return map;
  // }

}

/// current_page : 1
/// data : [{
/// "user":{"id":21,
/// "employee_id":4,
/// "name":"sample fy2",
/// "email":"samplefy2@gmail.com",
/// "mobile":null,
/// "email_verified_at":null,
/// "deleted_at":null,"created_at":"2024-01-10T22:32:58.000000Z","updated_at":"2024-01-10T22:32:58.000000Z","total_working_hours":"01:01:34","list":[{"date":"2024-02-08","total_hours":"00:49:53"},{"date":"2024-02-09","total_hours":"00:09:28"},{"date":"2024-02-10","total_hours":"00:00:00"},{"date":"2024-02-14","total_hours":"00:02:13"}]}},{"user":{"id":22,"employee_id":5,"name":"sample sample","email":"sample@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T02:57:07.000000Z","updated_at":"2024-01-25T02:57:07.000000Z","total_working_hours":"03:12:56","list":[{"date":"2024-02-08","total_hours":"03:12:56"}]}},{"user":{"id":23,"employee_id":6,"name":"test test","email":"test@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T03:07:28.000000Z","updated_at":"2024-01-25T03:07:28.000000Z","total_working_hours":"44:33:16","list":[{"date":"2024-02-08","total_hours":"44:33:16"}]}},{"user":{"id":28,"employee_id":11,"name":"sample 7","email":"sample7@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-25T06:32:55.000000Z","updated_at":"2024-01-25T06:32:55.000000Z","total_working_hours":"00:02:15","list":[{"date":"2024-02-08","total_hours":"00:02:15"}]}}]
/// first_page_url : "https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1"
/// from : 1
/// last_page : 1
/// last_page_url : "https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1"
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://apiorgportal.fairreturns.in/api/employeeWorkHours?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}]
/// next_page_url : null
/// path : "https://apiorgportal.fairreturns.in/api/employeeWorkHours"
/// per_page : 50
/// prev_page_url : null
/// to : 4
/// total : 4

// class Data {
//   Data({
//       this.currentPage,
//       this.data,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.links,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total,});
//
//   Data.fromJson(dynamic json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = [];
//       json['data'].forEach((v) {
//         data?.add(WorkingHistoryData.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = [];
//       json['links'].forEach((v) {
//         links?.add(Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }
//   int? currentPage;
//   List<WorkingHistoryData>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   dynamic nextPageUrl;
//   String? path;
//   int? perPage;
//   dynamic prevPageUrl;
//   int? to;
//   int? total;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['current_page'] = currentPage;
//     if (data != null) {
//       map['data'] = data?.map((v) => v.toJson()).toList();
//     }
//     map['first_page_url'] = firstPageUrl;
//     map['from'] = from;
//     map['last_page'] = lastPage;
//     map['last_page_url'] = lastPageUrl;
//     if (links != null) {
//       map['links'] = links?.map((v) => v.toJson()).toList();
//     }
//     map['next_page_url'] = nextPageUrl;
//     map['path'] = path;
//     map['per_page'] = perPage;
//     map['prev_page_url'] = prevPageUrl;
//     map['to'] = to;
//     map['total'] = total;
//     return map;
//   }
//
// }

/// url : null
/// label : "&laquo; Previous"
/// active : false

// class Links {
//   Links({
//       this.url,
//       this.label,
//       this.active,});
//
//   Links.fromJson(dynamic json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }
//   dynamic url;
//   String? label;
//   bool? active;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['url'] = url;
//     map['label'] = label;
//     map['active'] = active;
//     return map;
//   }
//
// }

/// user : {"id":21,"employee_id":4,"name":"sample fy2","email":"samplefy2@gmail.com","mobile":null,"email_verified_at":null,"deleted_at":null,"created_at":"2024-01-10T22:32:58.000000Z","updated_at":"2024-01-10T22:32:58.000000Z","total_working_hours":"01:01:34","list":[{"date":"2024-02-08","total_hours":"00:49:53"},{"date":"2024-02-09","total_hours":"00:09:28"},{"date":"2024-02-10","total_hours":"00:00:00"},{"date":"2024-02-14","total_hours":"00:02:13"}]}
//
// class WorkingHistoryData {
//   WorkingHistoryData({
//       this.user,});
//
//   WorkingHistoryData.fromJson(dynamic json) {
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//   User? user;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (user != null) {
//       map['user'] = user?.toJson();
//     }
//     return map;
//   }
//
// }

/// id : 21
/// employee_id : 4
/// name : "sample fy2"
/// email : "samplefy2@gmail.com"
/// mobile : null
/// email_verified_at : null
/// deleted_at : null
/// created_at : "2024-01-10T22:32:58.000000Z"
/// updated_at : "2024-01-10T22:32:58.000000Z"
/// total_working_hours : "01:01:34"
/// list : [{"date":"2024-02-08","total_hours":"00:49:53"},{"date":"2024-02-09","total_hours":"00:09:28"},{"date":"2024-02-10","total_hours":"00:00:00"},{"date":"2024-02-14","total_hours":"00:02:13"}]

// class User {
//   User({
//       this.id,
//       this.employeeId,
//       this.idToGetTaskHistory,
//       this.name,
//       this.email,
//       this.mobile,
//       this.emailVerifiedAt,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.totalWorkingHours,
//       this.list,});
//
//   User.fromJson(dynamic json) {
//     id = json['id'];
//     employeeId = json['employee_id'];
//     taskCount = 0;
//     idToGetTaskHistory = '';
//     name = json['name'];
//     email = json['email'];
//     mobile = json['mobile'];
//     emailVerifiedAt = json['email_verified_at'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     totalWorkingHours = json['total_working_hours'];
//     if (json['list'] != null) {
//       list = [];
//       json['list'].forEach((v) {
//         list?.add(HoursList.fromJson(v));
//       });
//     }
//   }
//   int? id;
//   int? employeeId;
//   int? taskCount;
//   String? idToGetTaskHistory;
//   String? name;
//   String? email;
//   dynamic mobile;
//   dynamic emailVerifiedAt;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   String? totalWorkingHours;
//   List<HoursList>? list;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['employee_id'] = employeeId;
//     map['name'] = name;
//     map['email'] = email;
//     map['mobile'] = mobile;
//     map['email_verified_at'] = emailVerifiedAt;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['total_working_hours'] = totalWorkingHours;
// /*    if (list != null) {
//       map['list'] = list?.map((v) => v.toJson()).toList();
//     }*/
//     return map;
//   }
//
// }

/// date : "2024-02-08"
/// total_hours : "00:49:53"

// class HoursList {
//   HoursList({
//       this.date,
//       this.startTime,
//       this.endTime,
//       this.totalHours});
//
//   HoursList.fromJson(dynamic json) {
//     date = json['date'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     totalHours = json['total_hours'];
//   }
//   String? date;
//   String? startTime;
//   String? endTime;
//   String? totalHours;
//
//   /*Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['date'] = date;
//     map['total_hours'] = totalHours;
//     return map;
//   }*/
//
// }