
class TaskListViewResponse {
  TaskListViewResponse({
    this.data,
    this.status,
    this.message,
  });
  TaskListViewResponse.fromJson(Map<String, dynamic> json) {
    data = List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  int? status;
  String? message;
}


