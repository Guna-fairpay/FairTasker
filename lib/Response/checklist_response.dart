
class ChecklistResponse {
  ChecklistResponse({
    this.data,
    this.status,
  });

  ChecklistResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    status = json['status'];
  }
  List<Map<String,dynamic>>? data;
  int? status;

}