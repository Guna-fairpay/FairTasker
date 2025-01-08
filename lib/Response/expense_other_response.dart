

class ExpenseOtherResponse {
  ExpenseOtherResponse({
    this.data,
    this.message,
    this.totalExpensesAmount,
  });

  // Constructor to parse the JSON response
  ExpenseOtherResponse.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message=json['message'];
    totalExpensesAmount=json['totalExpensesAmount'];

  }

  List<Map<String, dynamic>>? data;  // List of expense data
  String? message;  // Message or error message from the API response
  dynamic totalExpensesAmount;

  // Method to convert the object back to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
    };
  }
}