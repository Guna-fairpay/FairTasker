
class CustomerResponse {
  CustomerResponse({
    this.data,
    this.message,
  });

  CustomerResponse.fromJson(dynamic json) {

    data = json['data']['customers'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data']['customers'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data']['customers'] ?? []);
    message=json['message'];
  }
  List<Map<String,dynamic>>? data;
  String? message;
}