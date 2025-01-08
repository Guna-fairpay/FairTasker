
class GetWorkingHoursDataResponse {
  GetWorkingHoursDataResponse(
      {
        this.status,
        this.data,
        this.message,
      });

  GetWorkingHoursDataResponse.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] is Map<String, dynamic>) {
      data = (json['data']['data'] as List?)?.map((item) {
        return Map<String, dynamic>.from(item ?? {});
      }).toList();
      dataLength = (json['data']['data'] as List?)?.length;
    } else if (json['data'] is List) {
      dataLength = data?.length;
      for(int i=0;i<dataLength!;i++)
      {
        data = List<Map<String, dynamic>>.from(json['data']['data'][i]['user'] ?? []);
      }
    } else {
      data = [];
      dataLength = 0;
    }
    message = json['message'];
  }

  dynamic status;
  int? dataLength;
  List<Map<String, dynamic>>? data;
  String? message;
}