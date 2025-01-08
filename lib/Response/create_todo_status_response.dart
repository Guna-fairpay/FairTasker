
class CreateTodoStatusResponse  {
  CreateTodoStatusResponse({
      this.status, 
      this.todo, 
      this.statusTodo,});

  CreateTodoStatusResponse.fromJson(dynamic json) {
    status = json['status'];
    todo = json['todo'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['todo'] ?? {})]
        : List<Map<String, dynamic>>.from(json['todo'] ?? []);

    statusTodo = json['statusTodo'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['statusTodo'] ?? {})]
        : List<Map<String, dynamic>>.from(json['statusTodo'] ?? []);
  }
  int? status;
  List<Map<String, dynamic>>? todo;
  List<Map<String, dynamic>>? statusTodo;
}
