

class ExpenseCategories {
  ExpenseCategories({
    this.data,
    this.expenseTo,
  });

  ExpenseCategories.fromJson(dynamic json) {
    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);

    expenseTo = json['expenseTo'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['expenseTo'] ?? {})]
        : List<Map<String, dynamic>>.from(json['expenseTo'] ?? []);

  }
  List<Map<String,dynamic>>? data;
  List<Map<String,dynamic>>? expenseTo;

}