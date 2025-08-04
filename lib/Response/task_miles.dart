class TaskMilesResponse {
  TaskMilesResponse({
    this.data,});

  TaskMilesResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String,dynamic>>? data;
}

class PreviousOdometer {
  PreviousOdometer({
    this.data,});
  PreviousOdometer.fromJson(dynamic json) {
    data = json['data'];
  }
  int? data;
}