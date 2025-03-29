
class WorkingTaskResponse {
  List<Map<String, dynamic>>? history2;
  List<Map<String, dynamic>>? history3;

  WorkingTaskResponse({this.history2, this.history3});

  WorkingTaskResponse.fromJson(dynamic json) {
    if (json['history'] != null && json['history'] is Map<String, dynamic>) {
      var historyMap = json['history'] as Map<String, dynamic>;

      history2 = historyMap.containsKey('2')
          ? List<Map<String, dynamic>>.from(historyMap['2'] as List)
          : [];

      history3 = historyMap.containsKey('3')
          ? List<Map<String, dynamic>>.from(historyMap['3'] as List)
          : [];
    } else {
      history2 = [];
      history3 = [];
    }

    print("Parsed history2: ${history2?.length}, history3: ${history3?.length}");
  }

}
