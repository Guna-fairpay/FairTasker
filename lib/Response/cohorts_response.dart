
class CohortsResponse {
  CohortsResponse({
    this.cohortData,
    this.expenseData,
    this.status,
    this.message,
  });
  CohortsResponse.fromJson(Map<String, dynamic> json) {

    // cohortData = List<Map<String, dynamic>>.from(json['cohortsData'] ?? []);
    // expenseData = List<Map<String, dynamic>>.from(json['expenseCategories'] ?? []);
    // message = json['message'] ?? "";
    // status = json['status'];
    cohortData = json['cohortsData'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['cohortsData'] ?? {})]
        : List<Map<String, dynamic>>.from(json['cohortsData'] ?? []);
    expenseData = json['expenseCategories'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['expenseCategories'] ?? {})]
        : List<Map<String, dynamic>>.from(json['expenseCategories'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? cohortData;
  List<Map<String, dynamic>>? expenseData;
  int? status;
  String? message;

}