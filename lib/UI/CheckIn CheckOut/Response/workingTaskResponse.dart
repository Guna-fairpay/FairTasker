
class WorkingTaskResponse {
  List<Map<String, dynamic>> allHistory = [];

  WorkingTaskResponse();

  WorkingTaskResponse.fromJson(dynamic json) {
    final historyMap = json['history'];

    if (historyMap != null && historyMap is Map<String, dynamic>) {
      for (var entry in historyMap.entries) {
        if (entry.value is List) {
          allHistory.addAll(entry.value.whereType<Map<String, dynamic>>());
        }
      }
    }

    print("Total history tasks: ${allHistory.length}");
  }
}
