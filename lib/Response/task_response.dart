
class TaskListResponse {
  TaskListResponse({
    this.data,
    this.status,
    this.message,
  });
  TaskListResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}

class TaskResponse {
  TaskResponse({
    this.status,
    this.message,
  });
  TaskResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status =json['status'];
  }

  int? status;
  String? message;
}

class TaskExpenseResponse {
  TaskExpenseResponse({
    this.data,

  });
  TaskExpenseResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String, dynamic>>? data;

}
