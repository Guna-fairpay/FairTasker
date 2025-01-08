
class VoiceResponse {
  VoiceResponse({
    this.status,
    this.data,});

  VoiceResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  int? status;
  List<Map<String, dynamic>>? data;


}