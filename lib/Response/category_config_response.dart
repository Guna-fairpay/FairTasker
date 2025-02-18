
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

class CategoryConfigMessageResponse {
  CategoryConfigMessageResponse({
    this.status,
    this.message,
  });
  CategoryConfigMessageResponse.fromJson(dynamic json) {
    message = json['message'] ?? "";
    status =json['status'];
  }

  bool? status;
  String? message;
}