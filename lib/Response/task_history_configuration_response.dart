
class TaskHistoryConfigurationResponse {
  TaskHistoryConfigurationResponse({
      this.status, 
      this.data,});

  TaskHistoryConfigurationResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  dynamic status;
  List<Map<String,dynamic>>? data;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['status'] = status;
  //   /*if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }*/
  //   return map;
  // }

}

// class TaskHistoryConfigurationData {
//   TaskHistoryConfigurationData({
//       this.id,
//       this.name,
//       this.totalAmount,
//       this.amount,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,});
//
//   TaskHistoryConfigurationData.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     totalAmount = 0;
//     amount = json['amount'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   dynamic name;
//   int? totalAmount;
//   dynamic amount;
//   dynamic deletedAt;
//   dynamic createdAt;
//   dynamic updatedAt;
//
// /*
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['amount'] = amount;
//     map['deleted_at'] = deletedAt;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
// */
//
// }