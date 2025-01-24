import 'dart:developer';

class WorkingTaskResponse {
  List<Map<String, dynamic>>? history;
  List<Map<String, dynamic>>? taskCount;

  WorkingTaskResponse({this.history});

  WorkingTaskResponse.fromJson(dynamic json) {
    //log("$json");
    if (json['history'] != null) {
      // Ensure history is parsed as a list of maps
      history = List<Map<String, dynamic>>.from(json['history'] ?? []);
    } else {
      history = [];
    }
    if (json['taskCount'] != null) {
      // Ensure history is parsed as a list of maps
      taskCount = (json['taskCount'] as Map<String, dynamic>)
          .entries
          .map((e) => {e.key: e.value})
          .toList();
    } else {
      history = [];
    }
    print("task count ${taskCount?[0]}");
  }
}