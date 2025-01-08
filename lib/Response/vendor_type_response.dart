
class VendorTypeResponse{
  VendorTypeResponse({
    this.data,
  });

  VendorTypeResponse.fromJson(json) {

    data = List<Map<String, dynamic>>.from(json ?? []);



    // if (json != null) {
    //   data = [];
    //   json.forEach((v) {
    //     data?.add(VendorType.fromJson(v));
    //   });
    // }
  }
  List<Map<String, dynamic>>? data;

// Map<String, dynamic> toJson() {
//   final map = <String, dynamic>{};
//   if (data != null) {
//     map['data'] = data?.map((v) => v.toJson()).toList();
//   }
//   return map;
// }

}



/*class VendorTypeResponse{
  VendorTypeResponse({
    this.data,
  });

  VendorTypeResponse.fromJson(dynamic json) {
    if (json != null) {
      data = [];
      json.forEach((v) {
        data?.add(VendorType.fromJson(v));
      });
    }
  }
  List<VendorType>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
class VendorType {
  VendorType({
    this.id,
    this.name,
    this.status,
    this.platform,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,});

  VendorType.fromJson(dynamic json) {

    id = json['id'];
    name = json['name'];
    status = json['status'];
    platform = json['platform'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  int? status;
  dynamic platform;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    map['platform'] = platform;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}*/

