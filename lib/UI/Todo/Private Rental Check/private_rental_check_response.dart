

class PrivateRentalCheckResponse {
  PrivateRentalCheckResponse({
    required this.status,
    required this.data,
});

  PrivateRentalCheckResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    status = json['status'];
  }
  List<Map<String, dynamic>> data = [];
  var status;
}