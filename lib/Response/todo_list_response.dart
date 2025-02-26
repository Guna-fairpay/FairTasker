class TodoListResponse {
  TodoListResponse({
    this.status,
    this.message,
    this.todos,
    this.editTodos,
  });

  TodoListResponse.fromJson(dynamic json) {
    todos = json['todos'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['todos'] ?? {})]
        : List<Map<String, dynamic>>.from(json['todos'] ?? []);
    editTodos= Map<String, dynamic>.from(json['todo'] ?? {});
    message = json['message'] ?? "";
    status = json['status'];
  }
  int? status;
  String? message;
  List<Map<String, dynamic>>? todos;
  Map<String, dynamic>? editTodos;
}

class CleanCarTimeValues {
  int? minutes;
  CleanCarTimeValues({this.minutes});
}
