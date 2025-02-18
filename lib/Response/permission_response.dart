
class PermissionListResponse {
  PermissionListResponse({
    this.data,
    this.status,
    this.message,
  });
  PermissionListResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['permission'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}

class PermissionResponse {
  PermissionResponse({
    this.status,
    this.message,
  });
  PermissionResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status =json['status'];
  }
  int? status;
  String? message;
}