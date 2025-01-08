

class GetActiveHoursResponse {
  GetActiveHoursResponse({
    this.status,
    this.data,
  });

  GetActiveHoursResponse.fromJson(dynamic json){
    status = json['status'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }

  dynamic status;
  List<Map<String, dynamic>>? data;
}