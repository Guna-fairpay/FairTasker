class PaymentResponse {
  PaymentResponse({
    this.data,
  });
  PaymentResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
  }
  List<Map<String, dynamic>>? data;

}