
class LeaveManagementEmployeeListResponse {
  LeaveManagementEmployeeListResponse({
    this.data,
    this.status,
    this.message,
  });
  LeaveManagementEmployeeListResponse.fromJson(Map<String, dynamic> json) {

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