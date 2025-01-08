
class AuthenticationResponse {
  AuthenticationResponse({
      this.status, 
      this.user, 
      this.userPermissions, 
      this.message,});

  AuthenticationResponse.fromJson(dynamic json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userPermissions = json['userPermissions'] != null ? json['userPermissions'].cast<String>() : [];
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
  User({
    this.name,
    this.id,
    this.token,
    this.role,
  this.password,
  this.email,
    this.hrmId
  });

  User.fromJson(dynamic json) {
    name = json['name'];
    token = json['token'];
    id = json['id'];
    branchId=json['branch_id'];
    hrmId = json['hrm_id'];
    role = json['role'] != null ? json['role'].cast<String>() : [];
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
  List<String>? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['token'] = token;
    map['id'] = id;
    map['role'] = role;
    return map;
  }

}