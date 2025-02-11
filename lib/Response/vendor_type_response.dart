
class VendorTypeResponse{
  VendorTypeResponse({
    this.data,
  });

  VendorTypeResponse.fromJson(json) {
    data = List<Map<String, dynamic>>.from(json ?? []);
  }
  List<Map<String, dynamic>>? data;
}