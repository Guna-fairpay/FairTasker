class BaseResponse {
  final Map<String, dynamic>? data;
  BaseResponse({this.data});
  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(data: json);
  Map<String, dynamic> toJson() => data ?? {};
}