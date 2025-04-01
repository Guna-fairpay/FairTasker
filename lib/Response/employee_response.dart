
class EmployeeListResponse {
  EmployeeListResponse({
    this.data,
    this.status,
    this.message,
  });
  EmployeeListResponse.fromJson(Map<String, dynamic> json) {

    data = List<Map<String, dynamic>>.from(json['role'] ?? []);
    // data = json['department'] is Map<String, dynamic>
    //     ? [Map<String, dynamic>.from(json['department'] ?? {})]
    //     : List<Map<String, dynamic>>.from(json['department'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];


  }

  List<Map<String, dynamic>>? data;
  int? status;
  String? message;

}

class EmployeeResponse {
  EmployeeResponse({

    this.status,
    this.message,
   // this.role,
  });
  EmployeeResponse.fromJson(Map<String, dynamic> json) {

    message = json['message'] ?? "";
    status =json['status'];
   // role=json['role'] ?? "";
  }

  int? status;
  String? message;
  //String? role;


}