
class EmployeeListResponse {
  EmployeeListResponse({
    this.data,
    this.status,
    this.message,
  });
  EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['role'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}

class EditEmployeeResponse {
  EditEmployeeResponse({
    this.status,
    this.role,
    this.user,
    this.userRole,
  });
  EditEmployeeResponse.fromJson(Map<String, dynamic> json) {
    status =json['status'];
    role = List<Map<String, dynamic>>.from(json['role'] ?? []);
    user = Map<String, dynamic>.from(json['user'] ?? {});
    userRole = List<int>.from(json['userRole'] ?? []);
  }
  int? status;
  List<Map<String, dynamic>>?role=[];
  Map<String, dynamic>?user={};
  List<int>?userRole=[];
}

class EmployeeResponse {
  EmployeeResponse({
    this.status,
    this.message,
  });
  EmployeeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status =json['status'];
  }
  int? status;
  String? message;
  }