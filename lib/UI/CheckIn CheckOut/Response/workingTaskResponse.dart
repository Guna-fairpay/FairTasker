class WorkingTaskResponse {
  List<Map<String, dynamic>>? history;

  WorkingTaskResponse({this.history});

  WorkingTaskResponse.fromJson(dynamic json) {
    if (json['history'] != null) {
      // Ensure history is parsed as a list of maps
      history = (json['history'] as Map<String, dynamic>)
          .entries
          .map((e) => {e.key: e.value})
          .toList();
    } else {
      history = [];
    }
  }
}