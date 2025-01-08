
class DepartmentListResponse {
  DepartmentListResponse({
    this.data,
    this.status,
    this.message,
  });
  DepartmentListResponse.fromJson(Map<String, dynamic> json) {

     //data = List<Map<String, dynamic>>.from(json['department'] ?? []);
    data = json['department'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['department'] ?? {})]
        : List<Map<String, dynamic>>.from(json['department'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

}

class DepartmentResponse {
  DepartmentResponse({
    this.data,
    this.status,
    this.message,
  });
  DepartmentResponse.fromJson(Map<String, dynamic> json) {

    //data = List<Map<String, dynamic>>.from(json['department'] ?? []);
    data = json['department'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['department'] ?? {})]
        : List<Map<String, dynamic>>.from(json['department'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

}