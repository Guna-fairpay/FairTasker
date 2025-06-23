import 'dart:convert';

class AuthenticationResponse {
  AuthenticationResponse({
    this.status,
    this.user,
    this.userPermissions,
    this.message,
  });

  AuthenticationResponse.fromJson(dynamic json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userPermissions = json['userPermissions'] != null
        ? json['userPermissions'].cast<String>()
        : [];
    message = json['message'];
  }

  int? status;
  User? user;
  List<String>? userPermissions;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['userPermissions'] = userPermissions;
    map['message'] = message;
    return map;
  }
}

class User {
  User(
      {this.name,
      this.id,
      this.token,
      this.role,
      this.password,
      this.email,
      this.hrmId,
      this.departmentId});

  User.fromJson(dynamic json) {
    name = json['name'];
    token = json['token'];
    id = json['id'];
    branchId = json['branch_id'];
    hrmId = json['hrm_id'];
    departmentId = json['department_id'];
    role = json['role'] != null ? json['role'].cast<String>() : [];
    resource = json['resource'] != null ? json['resource'].cast<int>() : [];
    password = '';
    email = '';
  }

  String? password;
  String? name;
  String? token;
  String? email;
  int? id;
  int? branchId;
  int? hrmId;
  int? departmentId;
  List<String>? role;
  List<int>? resource;

  Map<String, dynamic> toJson() => {
    "name" : name,
    "token" : token,
    "id" : id,
    "hrm_id" : hrmId,
    "role" : role,
    "department_id" : departmentId,
    "branch_id" : branchId,
    "resource" : resource,
    "password" : password,
    "email" : email
  };

  @override
  String toString() => jsonEncode(toJson());
}
