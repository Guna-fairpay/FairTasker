class MaintenanceCheckListResponse {
  MaintenanceCheckListResponse({
    this.data,
    this.children,
    this.status,
  });
  MaintenanceCheckListResponse.fromJson(dynamic json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data'] ?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    status = json['status'];
  }
  List<Map<String, dynamic>>? data;
  List<Map<String, dynamic>>? children;
  int? status;

}
