
class WorkingTaskResponse {
  List<Map<String, dynamic>>? history2;
  List<Map<String, dynamic>>? history3;

  WorkingTaskResponse({this.history2, this.history3});

  WorkingTaskResponse.fromJson(dynamic json) {
    if (json['history'] != null) {
      history2 = json['history']['2'] != null
          ? List<Map<String, dynamic>>.from(json['history']['2'])
          : [];
      history3 = json['history']['3'] != null
          ? List<Map<String, dynamic>>.from(json['history']['3'])
          : [];
    } else {
      history2 = [];
      history3 = [];
    }

    print("Parsed history: ${history2?.length}");
  }
}
