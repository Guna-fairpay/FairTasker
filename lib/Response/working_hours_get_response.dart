class WorkingHoursGetResponse {
  WorkingHoursGetResponse({
      this.status, 
      this.data, 
      this.message,});

  WorkingHoursGetResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'];
  }
  bool? status;
  List<Map<String, dynamic>>? data;
  String? message;


}

// class WorkingHoursData{
//   int? id;
//
//   WorkingHoursData.fromJson(dynamic json) {
//     id = json['id'];
//   }
// }