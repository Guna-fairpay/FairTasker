

class WorkingHoursResponse {
  WorkingHoursResponse({
    this.history,
});

  WorkingHoursResponse.fromJson(dynamic json){
    history = json['history'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['history'] ?? {})]
        : List<Map<String, dynamic>>.from(json['history'] ?? []);
  }
  List<Map<String, dynamic>>? history;
}

