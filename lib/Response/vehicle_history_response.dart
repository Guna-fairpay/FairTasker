
class VehicleHistoryResponse {
  VehicleHistoryResponse({
    this.todo,
    this.data,
    this.lastPage,
    this.total,
    this.status,
    this.message,
    this.hasMoreData,
    this.currentPage,
  });

  VehicleHistoryResponse.fromJson(Map<String, dynamic> json) {
    // log("Response:\t$json", name: "VehicleHistoryResponse");
    if (json['todo'] is List) {
      todo = List<Map<String, dynamic>>.from(json['todo']);
    } else if (json['todo'] is Map) {
      todo = [json['todo'] as Map<String, dynamic>];
    } else {
      todo = [];
    }
    if (json['todo']['data'] is List) {
      data = List<Map<String, dynamic>>.from(json['todo']['data']);
    } else if (json['todo']['data'] is Map) {
      data = [json['todo']['data'] as Map<String, dynamic>];
    } else {
      data = [];
    }
    currentPage = json['todo']['current_page'];
    lastPage = json['todo']['last_page'];
    totalPageCount = (json['todo']['total'] ?? 0);
    total = ((json['todo']['total'] ?? 0) / (json['todo']['per_page'] ?? 1)).ceil();
    message = json['message'] ?? "";
    status = json['status'];
    hasMoreData = currentPage != lastPage;
  }

  List<Map<String, dynamic>>? todo;
  List<Map<String, dynamic>>? data;
  int? lastPage;
  int? total;
  int? totalPageCount;
  int? status;
  int? currentPage;
  bool? hasMoreData;
  String? message;
}
