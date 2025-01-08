
class BranchResponse {
  BranchResponse({
    this.data,
    this.message,
    this.status,
  });

  BranchResponse.fromJson(dynamic json) {

    data = json['data'] is Map<String, dynamic>
        ? [Map<String, dynamic>.from(json['data']?? {})]
        : List<Map<String, dynamic>>.from(json['data'] ?? []);
    message=json['message'];
    status=json['status'];
  }
  List<Map<String,dynamic>>? data;
  String? message;
  int? status;
}