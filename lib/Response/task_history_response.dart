

// class Task {
//   final int id;
//   final dynamic userId;
//   // dynamic keyName;
//   final dynamic title;
//   final dynamic todoDate;
//   final dynamic todoTime;
//   final dynamic status;
//   final dynamic vin;
//   final dynamic vehicleName;
//   // final User user;
//
//   Task({
//     required this.id,
//     required this.userId,
//     // required this.keyName,
//     required this.title,
//     required this.todoDate,
//     required this.todoTime,
//     required this.status,
//     required this.vin,
//     required this.vehicleName,
//     // required this.user,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       userId: json['user_id'],
//       title: json['title'],
//       todoDate: json['todo_date'],
//       todoTime: json['todo_time'],
//       status: json['status'],
//       vin: json['vin'],
//       vehicleName: json['vehicle_name'],
//       // keyName : '',
//       // user: User.fromJson(json['users']),
//     );
//   }
// }


class TaskHistoryResponse {
  TaskHistoryResponse({
    this.status,
    this.history,
    this.taskCount,});

  TaskHistoryResponse.fromJson(dynamic json) {
    status = json['status'];
    history: json['history'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['history'] ?? {})]
        : List<Map<String, dynamic>>.from(json['history'] ?? []);
    status: json['status'];
    //taskCount: Map<String, dynamic>.from(json['taskCount']);
    taskCount = json['taskCount'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['taskCount'] ?? {})]
        : List<Map<String, dynamic>>.from(json['taskCount'] ?? []);
  }
  int? status;
  List<Map<String,dynamic>>? history;
  List<Map<String,dynamic>>? taskCount;

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   map['status'] = status;
//   /*if (data != null) {
//     map['data'] = data?.map((v) => v.toJson()).toList();
//   }*/
//   return map;
// }

}


// class TaskHistoryResponse {
//   TaskHistoryResponse({
//      this.status,
//      this.history,
//     this.taskCount,
//   });
//
// TaskHistoryResponse.fromJson(dynamic json) {
//
//     history: json['history'] is Map<String, dynamic>
//       ? [Map<String, dynamic>.from(json['history'] ?? {})]
//       : List<Map<String, dynamic>>.from(json['history'] ?? []);
//       status: json['status'];
//       //taskCount: Map<String, dynamic>.from(json['taskCount']);
//     taskCount = json['taskCount'] is Map<String, dynamic>
//         ? [Map<String, dynamic>.from(json['taskCount'] ?? {})]
//         : List<Map<String, dynamic>>.from(json['taskCount'] ?? []);
//   // Map<TaskHistoryConfigurationData, List<Task>> history = {};
//   // json['history'].forEach((key, value) {
//   //   List<Task> tasks = [];
//   //   for (var task in value) {
//   //     tasks.add(Task.fromJson(task));
//   //   }
//   //   history[TaskHistoryConfigurationData(id: int.parse(key), name: '')] = tasks;
//   // });
//
//   }
//
//    int? status;
//    List<Map<String,dynamic>>? history;
//    Map<String, dynamic>? taskCount;
//
// }