
class LeaveManagementListResponse {
  LeaveManagementListResponse({
    this.data,
    this.status,
    this.message,
  });
  LeaveManagementListResponse.fromJson(Map<String, dynamic> json) {

    //data = List<Map<String, dynamic>>.from(json['data'] ?? []);
    data = json['data']['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data']['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data']['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  bool? status;
  String? message;

}

class LeaveManagementResponse {
  LeaveManagementResponse({
    this.status,
    this.message,
  });
  LeaveManagementResponse.fromJson(Map<String, dynamic> json) {

    message = json['message'] ?? "";
    status = json['status'];
  }

  bool? status;
  String? message;

}