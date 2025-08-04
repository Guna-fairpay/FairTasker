
class OdometerResponse {
  OdometerResponse({
    this.data,});
  OdometerResponse.fromJson(dynamic json) {
    data = json['data'];
  }
  int? data;
}