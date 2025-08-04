
class TaskCategoryGroupResponse {
  TaskCategoryGroupResponse({
    this.data,
    this.message,
  });
  TaskCategoryGroupResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
  }
  List<Map<String,dynamic>>? data;
  String? message;
}