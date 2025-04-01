class ExpenseSummaryResponse {
  ExpenseSummaryResponse({
    this.expense,
    this.status,
    this.message,
  });

  ExpenseSummaryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    status = json['status'];
    expense = json['expenses'] != null
        ? Map<String, dynamic>.from(json['expenses'])
        : null;
  }

  Map<String, dynamic>? expense;
  int? status;
  String? message;
}

