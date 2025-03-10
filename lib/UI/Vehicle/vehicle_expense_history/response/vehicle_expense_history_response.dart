class VehicleExpenseHistoryResponse {
  VehicleExpenseHistoryResponse({
    this.data,
    this.expenses,
    this.message,
  });

  VehicleExpenseHistoryResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    expenses = Map<String, dynamic>.from(json['expenses'] ?? {});
    message = json['message'] ?? '';
  }
  List<Map<String, dynamic>>? data;
  Map<String, dynamic>? expenses;
  String? message;
}