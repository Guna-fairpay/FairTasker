class VehicleHistoryResponse {
  VehicleHistoryResponse({
    this.todo,
    this.data,
    this.lastPage,
    this.total,
    this.status,
    this.message,
  });

  VehicleHistoryResponse.fromJson(Map<String, dynamic> json) {
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
    lastPage = json['todo']['last_page'];
    total = json['todo']['total'];
    message = json['message'] ?? "";
    status = json['status'];
  }

  List<Map<String, dynamic>>? todo;
  List<Map<String, dynamic>>? data;
  int? lastPage;
  int? total;
  int? status;
  String? message;
}
