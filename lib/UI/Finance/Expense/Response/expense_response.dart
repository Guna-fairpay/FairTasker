

class ExpenseResponse {
  ExpenseResponse({
    this.data,
    this.totalExpensesAmount,
    this.status,
    this.message,
  });
  ExpenseResponse.fromJson(Map<String, dynamic> json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    totalExpensesAmount = double.parse(json['totalExpensesAmount'].toString());
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  double? totalExpensesAmount;
  int? status;
  String? message;

}