

class UsersListResponse {
  UsersListResponse({
    this.data,
    this.status,
    this.message,
  });

  UsersListResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['role'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }

  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}

class PermissionUsersListResponse {
  PermissionUsersListResponse({
    this.status,
    this.data,
  });

  PermissionUsersListResponse.fromJson(Map<String, dynamic> json) {
    data = List<int>.from(json['rolePermissions'] ?? []);
    status = json['status'];
  }

  List<int>? data;
  int? status;
}

class UsersResponse {
  UsersResponse({
    this.status,
    this.message,
  });
  UsersResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status = json['status'];
  }
  int? status;
  String? message;
}
