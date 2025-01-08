
class CategoryConfigResponse {
  CategoryConfigResponse({
    this.data,
    this.status,
    this.message,
  });
  CategoryConfigResponse.fromJson(Map<String, dynamic> json) {

    data = List<Map<String, dynamic>>.from(json['data'] ?? []);
    message = json['message'] ?? "";
    status = json['status'];

  }

  List<Map<String, dynamic>>? data;
  bool? status;
  String? message;

}