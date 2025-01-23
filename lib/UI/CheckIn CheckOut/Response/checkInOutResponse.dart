

class CheckInOutReasonResponse{
  CheckInOutReasonResponse(
  {
    this.data,
});

  CheckInOutReasonResponse.fromJson(dynamic json)
  {
    data = json['data']is Map<String, dynamic>? [Map<String, dynamic>.from(json['data'] ?? {})]
    : List<Map<String, dynamic>>.from(json['data'] ?? []);
}
List<Map<String, dynamic>>? data;
}