

class UserListResponse {
  UserListResponse({
    this.data,
    this.message,
  });

  UserListResponse.fromJson(dynamic json) {
    data = json['usersList'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['usersList'] ?? {})]
        : List<Map<String, dynamic>>.from(json['usersList'] ?? []);
    message = json['message'] ?? "";
  }
  List<Map<String,dynamic>>? data;
  String? message;
}