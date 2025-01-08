
class PrivateRentalResponse {
  PrivateRentalResponse({
    this.data,
    this.addData,
    this.message,
  });

  PrivateRentalResponse.fromJson(dynamic json) {
    addData = json['data']is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    data = json['data']['vehicles'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data']['vehicles'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data']['vehicles'] ?? []);
    message=json['message'];
  }
  List<Map<String,dynamic>>? data;
  List<Map<String,dynamic>>? addData;
  String? message;
}