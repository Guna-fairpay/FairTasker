
class GetTodoListResponse {
  GetTodoListResponse({
    this.data,
    this.children,
    this.status,
  });
  GetTodoListResponse.fromJson(dynamic json) {

    data = json['todos'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['todos'] ?? {})]
        : List<Map<String, dynamic>>.from(json['todos'] ?? []);
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  List<Map<String, dynamic>>? children;
  int? status;
}