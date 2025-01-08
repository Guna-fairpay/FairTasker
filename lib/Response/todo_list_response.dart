class TodoListResponse {
  TodoListResponse({
    this.status,
    this.message,
    this.todos,
  });

  TodoListResponse.fromJson(dynamic json) {
    todos = json['todos'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['todos'] ?? {})]
        : List<Map<String, dynamic>>.from(json['todos'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];
  }
  int? status;
  String? message;
  List<Map<String, dynamic>>? todos;
}

class CleanCarTimeValues {
  int? minutes;
  CleanCarTimeValues({this.minutes});
}
