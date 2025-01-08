
class GeneralResponse {
  GeneralResponse({
      this.status,
      this.error,
    this.message});
  GeneralResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
  }

  int? status;
  String? message;
  String? error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}