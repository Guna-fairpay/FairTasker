
class RolesListResponse {
  RolesListResponse({
    this.data,
    this.status,
    this.message,
  });
  RolesListResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['role'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;


}

class EditRoleResponse {
  EditRoleResponse({
    this.rolePermission,
    this.status,
  });
  EditRoleResponse.fromJson(Map<String, dynamic> json) {
    rolePermission = List<int>.from(json['rolePermissions'] ?? []);
    status = json['status'];
  }
  List<int>? rolePermission;
  int? status;
}

class RolesResponse {
  RolesResponse({
    this.status,
    this.message,
  });
  RolesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status =json['status'];
  }
  int? status;
  String? message;
}